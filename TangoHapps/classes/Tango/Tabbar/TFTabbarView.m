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

#import "TFTabbarView.h"
#import "TFTabbarSection.h"

@implementation TFTabbarView

-(id)initWithFrame:(CGRect)frame
{
    if([super initWithFrame:frame]){
        [self setBackgroundColor:[UIColor clearColor]];
        [self setClipsToBounds:YES];
        [self setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
        _currentY = 0;
        _sections = [NSMutableArray array];
    }
    return self;
}

-(void)addPaletteSection:(TFTabbarSection*) section {
    
    CGRect containerFrame = CGRectMake(0, _currentY, section.frame.size.width, section.frame.size.height);
    section.frame = containerFrame;
    
    _currentY += section.frame.size.height;

    [self setContentSize:CGSizeMake(self.frame.size.width, _currentY)];
    
    [self addSubview:section];
    [_sections addObject:section];
}

-(void) relayoutSections{
    
    _currentY = 0;
    for (TFTabbarSection * section in _sections) {
        
        CGRect containerFrame = CGRectMake(0, _currentY, section.frame.size.width, section.frame.size.height);
        section.frame = containerFrame;
        
        _currentY += section.frame.size.height;
    }
    
    [self setContentSize:CGSizeMake(self.frame.size.width, _currentY)];
}

-(TFTabbarSection*) sectionForPalette:(TFPalette*) palette{
    for (TFTabbarSection * section in _sections) {
        if(section.palette == palette){
            return section;
        }
    }
    return nil;
}


-(TFTabbarSection*) sectionNamed:(NSString*) name {
    for (TFTabbarSection * section in _sections) {
        if([section.title isEqualToString:name]){
            return section;
        }
    }
    return nil;
}

-(TFTabbarSection*) sectionAtLocation:(CGPoint) location{
    for (TFTabbarSection * section in _sections) {
        if(CGRectContainsPoint(section.frame,location)){
            return section;
        }
    }
    return nil;
}

-(void) removeSection:(TFTabbarSection*) section{
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