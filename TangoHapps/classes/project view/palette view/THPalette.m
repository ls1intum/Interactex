/*
 * TangoFramework
 *
 * Copyright (c) 2012 Juan Haladjian
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "THPalette.h"
#import "TFEditor.h"
#import "THCustomPaletteItem.h"

@implementation THPalette

#pragma mark Initialization

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self){
        [self setDelaysContentTouches:NO];
        [self setBackgroundColor:[UIColor clearColor]];
        _paletteItems = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark Managing palette items

-(void) removePaletteItem:(THPaletteItem*) paletteItem{
    [_paletteItems removeObject:paletteItem];
    [paletteItem removeFromSuperview];
    [self layoutSubviews];
    [self resizeToFitContents];
}

-(void)addPaletteItem:(THPaletteItem*)paletteItem {

    [self addSubview:paletteItem];
    [_paletteItems addObject:paletteItem];
    [self setNeedsLayout];
    [self layoutSubviews];
    [self resizeToFitContents];
}

-(void)layoutSubviews {
    
    float x = kPaletteItemsPadding;
    float y = kPaletteItemsPadding;
    for(THPaletteItem * paletteItem in _paletteItems){
        CGSize paletteItemSize = [self clampSizeToConstraints:paletteItem.frame.size];
        paletteItemSize = CGSizeMake(kPaletteItemSize, kPaletteItemSize);
        [paletteItem setFrame:CGRectMake(x, y, paletteItemSize.width, paletteItemSize.height)];
        x += kPaletteItemSize + kPaletteItemsPadding;
        BOOL last = [_paletteItems indexOfObject:paletteItem] == [_paletteItems count] - 1;
        if(!last && x >= self.bounds.size.width - paletteItemSize.width - kPaletteItemsPadding){
            x = kPaletteItemsPadding;
            y += kPaletteItemSize + kPaletteItemsPadding;
        }
    }
    
    self.contentSize = CGSizeMake(self.frame.size.width, y + kPaletteItemSize + kPaletteItemsPadding);
    if(self.contentSize.height != self.frame.size.height){
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.contentSize.width, self.contentSize.height);
        [self.sizeDelegate palette:self didChangeSize:self.contentSize];
    }
}

-(void)addDragablePaletteItem:(THPaletteItem*)paletteItem {
    
    paletteItem.delegate = self;
    [self addPaletteItem:paletteItem];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragItem:)];
    [panRecognizer setMaximumNumberOfTouches:1];
    [paletteItem addGestureRecognizer:panRecognizer];
    
    UILongPressGestureRecognizer * longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressRecognizer.cancelsTouchesInView = NO;
    [paletteItem addGestureRecognizer:longPressRecognizer];
}

-(void) handleTap:(UITapGestureRecognizer*) recognizer{
    CGPoint location = [recognizer locationInView:self];
    THPaletteItem * item = [self paletteItemAtLocation:location];
    if(!item){
        [self.dragDelegate didTapPalette:self];
    }
}

-(void) handleLongPress:(UILongPressGestureRecognizer*) sender{
    THPaletteItem * paletteItem = (THPaletteItem*)[sender view];
    if(sender.state == UIGestureRecognizerStateBegan){
        [self.dragDelegate palette:self didLongPressItem:paletteItem withRecognizer:sender];
    }
}

-(void)dragItem:(UIPanGestureRecognizer*)sender {
    THPaletteItem *draggedItem = (THPaletteItem*)[sender view];
    if(sender.state == UIGestureRecognizerStateBegan){
        [self.dragDelegate palette:self didStartDraggingItem:draggedItem withRecognizer:sender];
    } else if(sender.state == UIGestureRecognizerStateChanged){
        [self.dragDelegate palette:self didDragItem:draggedItem withRecognizer:sender];
    } else if(sender.state == UIGestureRecognizerStateEnded){
        [self.dragDelegate palette:self didDropItem:draggedItem withRecognizer:sender];
    }
}

-(THPaletteItem*)paletteItemAtIndex:(NSInteger)index {
    return [_paletteItems objectAtIndex:index];
}

-(THPaletteItem*)paletteItemAtLocation:(CGPoint)location{
    for (THPaletteItem * item in _paletteItems) {
        if([item testHit:location]){
            [self.editionDelegate palette:self didSelectItem:(THCustomPaletteItem*)item];
            return item;
        }
    }
    return nil;
}

-(void)removeAllPaletteItems {
    for (THPaletteItem *paletteItem in _paletteItems)
        [paletteItem removeFromSuperview];
    [_paletteItems removeAllObjects];
    self.contentSize = CGSizeMake(self.frame.size.width, 0);
}

-(void)resizeToFitContents {    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.contentSize.height);
}

-(void) setEditing:(BOOL) editing{
    if(editing != _editing){
        _editing = editing;
        for (THPaletteItem * paletteItem in _paletteItems) {
            paletteItem.editing = editing;
        }
    }
}

#pragma mark TemporaryPaletteItem

-(void) temporaryAddPaletteItem:(THPaletteItem*) paletteItem{

    [self addPaletteItem:paletteItem];
    _tempPaletteItem = paletteItem;
    _tempPaletteItem.alpha = 0.5f;
}

-(void) removeTemporaryPaletteItem{
    if(_tempPaletteItem){
        [self removePaletteItem:_tempPaletteItem];
        _tempPaletteItem = nil;
    }
}

#pragma mark PaletteItem delegate

-(void) didRemovePaletteItem:(THCustomPaletteItem*) item{
    [_paletteItems removeObject:item];
    [item removeFromSuperview];
    [self.editionDelegate palette:self didRemoveItem:item];
}

-(void) didTapPaletteItem:(THCustomPaletteItem*) item{
    [self.editionDelegate palette:self didSelectItem:item];
}

#pragma mark Private

-(CGSize)clampSizeToConstraints:(CGSize)size {
    size.width = MIN(size.width, kPaletteItemSize);
    size.width = MAX(size.width, kPaletteItemSize);
    size.height = MIN(size.height, kPaletteItemSize);
    size.height = MAX(size.height, kPaletteItemSize);
    
    return size;
}

@end
