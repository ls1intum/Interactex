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

#import "THTabbarView.h"
#import "THTabbarSection.h"

@implementation THTabbarView

-(id)initWithFrame:(CGRect)frame {
    if([super initWithFrame:frame]){
        [self setBackgroundColor:[UIColor clearColor]];
        [self setClipsToBounds:YES];
        [self setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
        _currentY = 0;
        _sections = [NSMutableArray array];
    }
    return self;
}

- (THPalette*)emptyPalette {
    CGRect containerFrame = CGRectMake(0, 0, 230, 100);
    THPalette *palette = [[THPalette alloc] initWithFrame:containerFrame];
    return palette;
}

-(void)addPaletteSection:(THTabbarSection*) section {
    
    CGRect containerFrame = CGRectMake(0, _currentY, section.frame.size.width, section.frame.size.height);
    section.frame = containerFrame;
    
    _currentY += section.frame.size.height;

    [self setContentSize:CGSizeMake(self.frame.size.width, _currentY)];
    
    [self addSubview:section];
    [_sections addObject:section];
    
    section.sizeDelegate = self;
    
    [self.tabBarDelegate tabBar:self didAddSection:section];
}

-(void) tabbarSection:(THTabbarSection *)section changedSize:(CGSize)size{
    [self relayoutSections];
}

-(void) reloadData{
    [self removeAllSections];
    
    NSInteger numSections = [self.dataSource numPaletteSectionsForPalette:self];
    
    for (int i = 0; i < numSections; i++) {
        
        THPalette * palette = [self emptyPalette];
        NSInteger numItems = [self.dataSource numPaletteItemsForSection:i palette:self];
        for (int j = 0; j < numItems; j++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            
            THPaletteItem * item = [self.dataSource paletteItemForIndexPath:indexPath palette:self];
            [palette addDragablePaletteItem:item];
            
        }
        
        NSString * title = [self.dataSource titleForSection:i palette:self];
        THTabbarSection * section = [THTabbarSection sectionWithTitle:title];
        [section addPalette:palette];
        
        //section.sizeDelegate = self;
        [self addPaletteSection:section];
    }
    
    [self relayoutSections];
}

-(void) relayoutSections{
    
    _currentY = 0;
    for (THTabbarSection * section in _sections) {
        
        CGRect containerFrame = CGRectMake(0, _currentY, section.frame.size.width, section.frame.size.height);
        section.frame = containerFrame;
        
        _currentY += section.frame.size.height;
    }
    
    //[self recalculateFrame];
    
    [self setContentSize:CGSizeMake(self.frame.size.width, _currentY)];
}

-(void) recalculateFrame{
    
    //float navBarHeight = self.navigationController.navigationBar.frame.size.height;
    float navBarHeight = 0;
    float statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    float maxHeight = 768 - navBarHeight - statusBarHeight;
    float height = MIN(_currentY - self.frame.origin.y, maxHeight - self.frame.origin.y);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    //NSLog(@"origin : %f height: %f",self.frame.origin.y, height);
}

-(THTabbarSection*) sectionForPalette:(THPalette*) palette{
    for (THTabbarSection * section in _sections) {
        if(section.palette == palette){
            return section;
        }
    }
    return nil;
}

-(THTabbarSection*) sectionNamed:(NSString*) name {
    for (THTabbarSection * section in _sections) {
        if([section.title isEqualToString:name]){
            return section;
        }
    }
    return nil;
}

-(THTabbarSection*) sectionAtLocation:(CGPoint) location{
    for (THTabbarSection * section in _sections) {
        if(CGRectContainsPoint(section.frame,location)){
            return section;
        }
    }
    return nil;
}

-(void) removeSection:(THTabbarSection*) section{
    if(section != nil){
        [_sections removeObject:section];
        [section removeFromSuperview];
    }
}

-(void)removeAllSections {
    for(UIView *container in _sections){
        [container removeFromSuperview];
    }
    
    _currentY = 0;
    [_sections removeAllObjects];
}

@end