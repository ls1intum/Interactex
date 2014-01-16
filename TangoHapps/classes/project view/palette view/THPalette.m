/*
THPalette.m
Interactex Designer

Created by Juan Haladjian on 05/10/2013.

Interactex Designer is a configuration tool to easily setup, simulate and connect e-Textile hardware with smartphone functionality. Interactex Client is an app to store and replay projects made with Interactex Designer.

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
The first version of the software was designed and implemented as part of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was founded by Telekom Innovation Laboratories Berlin. It has been extended with funding from EIT ICT, as part of the activity "Connected Textiles".

Interactex is built using the Tango framework developed by TU Munich.

In the Interactex software, we use the GHUnit (a test framework for iOS developed by Gabriel Handford) and cocos2D libraries (a framework for building 2D games and graphical applications developed by Zynga Inc.). 
www.cocos2d-iphone.org
github.com/gabriel/gh-unit

Interactex also implements the Firmata protocol. Its software serial library is based on the original Arduino Firmata library.
www.firmata.org

All hardware part graphics in Interactex Designer are reproduced with kind permission from Fritzing. Fritzing is an open-source hardware initiative to support designers, artists, researchers and hobbyists to work creatively with interactive electronics.
www.frizting.org

Martijn ten Bhömer from TU Eindhoven contributed PureData support. Contact: m.t.bhomer@tue.nl.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

#import "THPalette.h"
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
        //CGSize paletteItemSize = [self clampSizeToConstraints:paletteItem.frame.size];
        CGSize paletteItemSize = CGSizeMake(kPaletteItemSize, kPaletteItemSize);
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
    
     if(sender.state == UIGestureRecognizerStateBegan){
     THPaletteItem * paletteItem = (THPaletteItem*)[sender view];
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
