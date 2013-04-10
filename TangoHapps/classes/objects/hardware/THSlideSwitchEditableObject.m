//
//  THSwitchEditableObject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/11/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THSlideSwitchEditableObject.h"
#import "THSlideSwitch.h"

#import "THSwitchProperties.h"
#import "THElementPin.h"
#import "THPin.h"
#import "THResistorExtension.h"
#import "THElementPinEditable.h"

@implementation THSlideSwitchEditableObject

@dynamic on;

-(void) loadSlideSwitch{
    
    self.sprite = [CCSprite spriteWithFile:@"switch.png"];
    [self addChild:self.sprite z:1];
    
    
    _switchOnSprite = [CCSprite spriteWithFile:@"switchOn.png"];
    _switchOnSprite.visible = NO;
    //_switchOnSprite.anchorPoint = ccp(0,0);
    _switchOnSprite.position = ccp(self.sprite.contentSize.width/2.0f,self.sprite.contentSize.height/2.0f);
    [self addChild:_switchOnSprite];
}

-(id) init{
    self = [super init];
    if(self){        
        self.simulableObject = [[THSlideSwitch alloc] init];
        
        self.type = kHardwareTypeSwitch;
        
        [self loadSlideSwitch];
        [self loadPins];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    [self loadSlideSwitch];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    //[controllers addObject:[THSwitchProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(BOOL) on{
    
    THSlideSwitch * clotheSwitch = (THSlideSwitch*) self.simulableObject;
    return clotheSwitch.on;
}

-(void) update{
    
    if(self.on){
        [self handleSwitchOn];
    } else if(!self.on){
        [self handleSwitchOff];
    }
}

-(void) handleSwitchOn{
    _switchOnSprite.visible = YES;
}

-(void) handleSwitchOff{
    _switchOnSprite.visible = NO;
}

- (void)turnOn{
    THSlideSwitch * clotheSwitch = (THSlideSwitch*) self.simulableObject;
    [clotheSwitch switchOn];
}

- (void)turnOff{
    THSlideSwitch * clotheSwitch = (THSlideSwitch*) self.simulableObject;
    [clotheSwitch switchOff];
}

-(void) updatePinValue{
    
    THSlideSwitch * clotheswitch = (THSlideSwitch*) self.simulableObject;
    THElementPin * switchPin = [clotheswitch.pins objectAtIndex:0];
    THBoardPin * boardPin = (THBoardPin*) switchPin.attachedToPin;
    boardPin.currentValue = clotheswitch.on;
}

-(void) handleTouchBegan{
    THSlideSwitch * clotheSwitch = (THSlideSwitch*) self.simulableObject;
    [clotheSwitch toggle];
    [self updatePinValue];
}

-(NSString*) description{
    return @"Button";
}

@end
