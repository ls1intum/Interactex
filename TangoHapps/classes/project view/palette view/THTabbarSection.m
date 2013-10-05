/*
THTabbarSection.m
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


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "THTabbarSection.h"
#import "THPaletteItem.h"

@implementation THTabbarSection
@synthesize title = _title;

+(id) sectionWithTitle:(NSString*) title  {
    return [[THTabbarSection alloc] initWithTitle:title];
}

-(void) addLabel {
    
    CGRect frame = CGRectMake(0, 0, kPaletteSectionWidth, kPaletteContainerTitleHeight);
    
    _navigationBar = [[UINavigationBar alloc] initWithFrame:frame];
    UINavigationItem * item = [[UINavigationItem alloc] initWithTitle:self.title];
    [_navigationBar pushNavigationItem:item animated:YES];
    _navigationBar.layer.cornerRadius = 5;

    [self addSubview:_navigationBar];
}

-(void) addPalette:(THPalette*) palette {
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

-(void) palette:(THPalette *)palette didChangeSize:(CGSize)newSize{
    
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
