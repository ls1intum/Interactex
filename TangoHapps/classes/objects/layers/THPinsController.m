/*
THPinsController.m
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

#import "THPinsController.h"
#import "THBoardPinEditable.h"
#import "THLilypadEditable.h"
#import "THLilyPad.h"
#import "THPinsControllerContainer.h"

@implementation THPinsController

float const kPinControllerContainerHeight = 40;
float const kPinControllerPadding = 10;
float const kPinsControllerMaxHeight = 400;
float const kPinsControllerMinHeight = 300;
float const kPinsControllerTitleLabelHeight = 30;

float const kPinControllerNoPinsLabelHeight = 50;
float const kPinControllerNoPinsLabelWidth = 300;

NSString * const kPinControllerNoPinsText = @"No pins connected";

-(BOOL) areTherePins{
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    for (THBoardPinEditable * pin in project.lilypad.pins) {
        if(pin.attachedPins.count > 0 && pin.type != kPintypeMinus && pin.type != kPintypePlus){
            return YES;
        }
    }
    return NO;
}

-(void) adaptContentSize{
    CGRect currentFrame = self.frame;
    self.contentSize = CGSizeMake(currentFrame.size.width, _currentY);
    if(_currentY < kPinsControllerMaxHeight){
        self.frame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y, currentFrame.size.width, _currentY);
    }
}

-(void) addPinContainers{
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    
    for (THBoardPinEditable * pin in project.lilypad.pins) {
        if(pin.attachedPins.count > 0 && pin.type != kPintypeMinus && pin.type != kPintypePlus){
            
            CGRect frame = CGRectMake(kPinControllerPadding, _currentY, self.frame.size.width - 20, kPinControllerContainerHeight);
            THPinsControllerContainer * pinsContainer = [[THPinsControllerContainer alloc] initWithFrame:frame];
            pinsContainer.pin = pin;
            [self addSubview:pinsContainer];
            [_containerViews addObject:pinsContainer];
            
            _currentY += kPinControllerContainerHeight + kPinControllerInnerPadding;
        }
    }
    
    [self adaptContentSize];
}

-(void) addTitleLabel {
    
    
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, kPinsControllerTitleLabelHeight);
    UINavigationBar * navBar = [[UINavigationBar alloc] initWithFrame:frame];
    UINavigationItem * item = [[UINavigationItem alloc] initWithTitle:@"Pins Controller"];
    navBar.items = [NSArray arrayWithObject:item];
    [self addSubview:navBar];
    
    UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moved:)];
    [navBar addGestureRecognizer:panRecognizer];
    
    _currentY = kPinsControllerTitleLabelHeight + kPinControllerPadding;
}

-(void) addNoPinsLabel{
    
    CGRect frame = CGRectMake(kPinControllerPadding, _currentY, kPinControllerNoPinsLabelWidth, kPinControllerNoPinsLabelHeight);
    _currentY += kPinControllerNoPinsLabelHeight;
    
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.text = kPinControllerNoPinsText;
    label.font = [UIFont systemFontOfSize:20];
    [self addSubview:label];
    
    [self adaptContentSize];
}

-(void) moved:(UIPanGestureRecognizer*) sender {
    CGPoint translation = [sender translationInView:self];
    [sender setTranslation:ccp(0,0) inView:self];
    self.center = ccpAdd(self.center, translation);
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        _containerViews = [NSMutableArray array];
        [self addTitleLabel];
        if([self areTherePins]){
            [self addPinContainers];
        } else {
            [self addNoPinsLabel];
        }
    }
    return self;
}

-(void) prepareToDie{
    for (THPinsControllerContainer * container in _containerViews) {
        [container prepareToDie];
    }
}

@end
