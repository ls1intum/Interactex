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

#import "TFTabbarSection.h"
#import "TFPaletteItem.h"

@implementation TFTabbarSection
@synthesize title = _title;

+(id) sectionWithTitle:(NSString*) title  {
    return [[TFTabbarSection alloc] initWithTitle:title];
}

-(void) addLabel {
    
    CGRect frame = CGRectMake(0, 0, kPaletteSectionWidth, kPaletteContainerTitleHeight);
    
    _navigationBar = [[UINavigationBar alloc] initWithFrame:frame];
    UINavigationItem * item = [[UINavigationItem alloc] initWithTitle:self.title];
    [_navigationBar pushNavigationItem:item animated:YES];
    _navigationBar.layer.cornerRadius = 5;

    [self addSubview:_navigationBar];
}

-(void) addPalette:(TFPalette*) palette {
    _palette = palette;
    _palette.sizeDelegate = self;
    _palette.frame = CGRectMake(0, _navigationBar.frame.size.height + kPaletteSectionPadding, kPaletteSectionWidth, _palette.frame.size.height);
    
    [self addSubview:_palette];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, kPaletteSectionWidth, self.palette.frame.size.height + _navigationBar.frame.size.height + kPaletteSectionPadding);
}

-(void) addView:(UIView*) view {
    
    view.frame = CGRectMake(0, _navigationBar.frame.size.height, kPaletteSectionWidth, view.frame.size.height);
    
    [self addSubview:view];
    
    self.frame = CGRectMake(0, 0, kPaletteSectionWidth, view.frame.size.height + _navigationBar.frame.size.height + kPaletteSectionPadding);
}

-(id) initWithTitle:(NSString*) title{
    
    self = [super init];
    if (self) {
        
        self.title = title;
        
        [self addLabel];
        
        self.backgroundColor = [UIColor grayColor];
        self.layer.cornerRadius = 5;
        self.layer.borderColor = [UIColor blueColor].CGColor;
    }
    return self;
}

-(void) startEditingTitle{
    
}

-(void) stopEditingTitle{
    
}

-(void) setEditing:(BOOL)editing{
    if(_editing != editing){
        _editing = editing;
        [self startEditingTitle];
        self.palette.editing = editing;
    }
}

-(void) palette:(TFPalette *)palette didChangeSize:(CGSize)newSize{
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, kPaletteSectionWidth, newSize.height + _navigationBar.frame.size.height + kPaletteSectionPadding);
    
    [self.sizeDelegate tabbarSection:self changedSize:self.frame.size];
}

-(void) setTitle:(NSString *)title{
    _navigationBar.topItem.title = title;
    _title = title;
}

-(NSString*) title{
    return _title;
}

@end
