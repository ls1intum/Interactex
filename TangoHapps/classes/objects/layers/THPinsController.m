//
//  THPinsController.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/26/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

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
