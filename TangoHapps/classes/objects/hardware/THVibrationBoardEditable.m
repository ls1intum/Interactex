//
//  THVibrationBoardEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 4/12/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THVibrationBoardEditable.h"
#import "THVibrationBoard.h"
#import "THVibrationBoardProperties.h"
#import "THElementPinEditable.h"
#import "THElementPin.h"

@implementation THVibrationBoardEditable

@dynamic on;
@dynamic onAtStart;
@dynamic frequency;

-(void) loadVibrationBoard{
    self.sprite = [CCSprite spriteWithFile:@"vibeBoard.png"];
    [self addChild:self.sprite];
    
    _lightSprite = [CCSprite spriteWithFile:@"yellowLight.png"];
    _lightSprite.visible = NO;
    _lightSprite.position = ccp(20,20);
    [self.sprite addChild:_lightSprite];
    
    self.acceptsConnections = YES;
    
    self.type = kHardwareTypeVibeBoard;
}

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THVibrationBoard alloc] init];
        
        
        [self loadVibrationBoard];
        [self loadPins];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    [self loadVibrationBoard];
    [self adaptFrequency];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder*) coder
{
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone*) zone
{
    THVibrationBoardEditable * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THVibrationBoardProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(THElementPinEditable*) minusPin{
    return [self.pins objectAtIndex:0];
}

-(THElementPinEditable*) digitalPin{
    return [self.pins objectAtIndex:1];
}

-(void) updateToPinValue{
    
    THElementPinEditable * pine = [self.pins objectAtIndex:1];
    THElementPin * pin = (THElementPin*) pine.simulableObject;
    THBoardPin * lilypadPin = (THBoardPin*) pin.attachedToPin;
    
    if(lilypadPin.type == kPintypeDigital){
        if(lilypadPin.value == kDigitalPinValueHigh && !self.on){
            [self turnOn];
        } else if(lilypadPin.value == kDigitalPinValueLow && self.on){
            [self turnOff];
        }
    } else if(lilypadPin.type == kPintypeAnalog){
        THVibrationBoard * vibrationBoard = (THVibrationBoard*)self.simulableObject;
        vibrationBoard.frequency = lilypadPin.value;
    }
}

-(void) update{
    
    if(self.on && !_lightSprite.visible){
        [self handleOn];
    } else if(!self.on && _lightSprite.visible){
        [self handleOff];
    }
    [self adaptFrequency];
}

-(void) adaptFrequency{
    
    THVibrationBoard * vibrationBoard = (THVibrationBoard*)self.simulableObject;
    _lightSprite.opacity = vibrationBoard.frequency;
}

-(BOOL) on{
    THVibrationBoard * vibrationBoard = (THVibrationBoard*)self.simulableObject;
    return vibrationBoard.on;
}

-(NSInteger) frequency{
    THVibrationBoard * vibrationBoard = (THVibrationBoard*)self.simulableObject;
    return vibrationBoard.frequency;
}

-(void) setFrequency:(NSInteger)frequency{
    
    THVibrationBoard * vibrationBoard = (THVibrationBoard*)self.simulableObject;
    vibrationBoard.frequency = frequency;
}

-(void) handleOn{
    _lightSprite.visible = YES;
}

-(void) handleOff{
    _lightSprite.visible = NO;
}

- (void)turnOn{
    THVibrationBoard * vibrationBoard = (THVibrationBoard*)self.simulableObject;
    [vibrationBoard turnOn];
}

- (void)turnOff{
    THVibrationBoard * vibrationBoard = (THVibrationBoard*)self.simulableObject;
    [vibrationBoard turnOff];
}

-(NSString*) description{
    return @"VibeBoard";
}

@end
