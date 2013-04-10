//
//  THButtonEditableObject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/19/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THButtonEditableObject.h"

#import "THButtonProperties.h"
#import "THButton.h"
#import "THViewEditableObject.h"
#import "THElementPin.h"
#import "THResistorExtension.h"
#import "THElementPinEditable.h"
#import "THBoardPinEditable.h"

@implementation THButtonEditableObject

@dynamic events;

-(void) loadSprite{
    
    self.sprite = [CCSprite spriteWithFile:@"button.png"];
    [self addChild:self.sprite z:1];
}

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THButton alloc] init];
        self.type = kHardwareTypeButton;
        
        [self loadSprite];
        [self loadPins];
        //[self loadExtension];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    [self loadSprite];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THButtonProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(void) updatePinValue{
    THElementPinEditable * digitalPin = self.digitalPin;
    THBoardPinEditable * boardPin = digitalPin.attachedToPin;
    THButton * button = (THButton*) self.simulableObject;
    boardPin.currentValue = button.isDown;
}

-(void) handleTouchEnded{
    THButton * button = (THButton*) self.simulableObject;
    if(button.isDown){
        [button handleStoppedPressing];
        [self updatePinValue];
    }
}

-(void) handleTouchBegan{
    THButton * button = (THButton*) self.simulableObject;
    if(!button.isDown){
        [button handleStartedPressing];
        [self updatePinValue];
    }
}

-(void) prepareToDie{
    [super prepareToDie];
}

-(NSString*) description{
    return @"Button";
}

@end
