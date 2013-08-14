//
//  THBuzzerEditableObject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/19/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THBuzzerEditableObject.h"
#import "THBuzzerProperties.h"
#import "THToneGenerator.h"
#import "THBuzzer.h"
#import "THPin.h"
#import "THElementPin.h"
#import "THElementPinEditable.h"

@implementation THBuzzerEditableObject
@synthesize on = _on;
@dynamic frequency;

-(void) loadBuzzer{
        
    self.sprite = [CCSprite spriteWithFile:@"buzzer.png"];
    [self addChild:self.sprite];
    
    self.acceptsConnections = YES;
    self.isInputObject = NO;
}

-(id) init{
    self = [super init];
    if(self){
        
        self.simulableObject = [[THBuzzer alloc] init];
        self.type = kHardwareTypeBuzzer;
        
        [self loadBuzzer];
        [self loadPins];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    [self loadBuzzer];
    
    self.onAtStart = [decoder decodeBoolForKey:@"onAtStart"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeBool:self.onAtStart forKey:@"onAtStart"];
}

-(id)copyWithZone:(NSZone *)zone
{
    THBuzzerEditableObject * copy = [super copyWithZone:zone];
    
    copy.onAtStart = self.onAtStart;
    copy.on = self.on;
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THBuzzerProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(THElementPinEditable*) minusPin{
    return [self.pins objectAtIndex:1];
}

-(THElementPinEditable*) digitalPin{
    return [self.pins objectAtIndex:0];
}

-(float) frequency{
    THBuzzer * buzzer = (THBuzzer*)self.simulableObject;
    return buzzer.frequency;
}

-(void) setFrequency:(float)frequency{
    
    THBuzzer * buzzer = (THBuzzer*)self.simulableObject;
    buzzer.frequency = frequency;
}

-(void) varyFrequency:(float) dt{
    THBuzzer * buzzer = (THBuzzer*)self.simulableObject;
    [buzzer varyFrequency:dt];
}

-(void) updateToPinValue{
    
    THElementPinEditable * pine = [self.pins objectAtIndex:0];
    THElementPin * pin = (THElementPin*) pine.simulableObject;
    THBoardPin * lilypadPin = (THBoardPin*) pin.attachedToPin;
    
    if(lilypadPin.type == kPintypeDigital){
        if(lilypadPin.value == kDigitalPinValueHigh && !self.on){
            [self turnOn];
        } else if(lilypadPin.value == kDigitalPinValueLow && self.on){
            [self turnOff];
        }
    } else if(lilypadPin.type == kPintypeAnalog){
        THBuzzer * buzzer = (THBuzzer*)self.simulableObject;
        buzzer.frequency = lilypadPin.value;
    }
}

-(void) update{
    THBuzzer * buzzer = (THBuzzer*) self.simulableObject;
    
    if(buzzer.on && !self.on){
        [self handleBuzzerOn];
    } else if(!buzzer.on &&self.on){
        [self handleBuzzerOff];
    }
    [self adaptFrequencyToBuzzer];
}

-(void) adaptFrequencyToBuzzer{
    THBuzzer * buzzer = (THBuzzer*)self.simulableObject;
    toneGenerator.frequency = buzzer.frequency;
}

-(CCAction*) shakeAction{
    CGPoint displ = ccp(1,1);
    CGPoint pos1 = ccpAdd(self.position, displ);
    CGPoint pos2 = ccpSub(self.position, displ);
    float moveTime = 0.05f;
    
    CCMoveTo * move1 = [CCMoveTo actionWithDuration:moveTime position: pos1];
    CCMoveTo * move2 = [CCMoveTo actionWithDuration:moveTime position: pos2];
    
    CCSequence * shake = [CCSequence actions:move1,move2, nil];
    return [CCRepeatForever actionWithAction:shake];
}

-(void) shake{
    shakeAction = [self shakeAction];
    [self runAction:shakeAction];
}

-(void) stopShaking{
    [self stopAction:shakeAction];
}

-(void) playSound{
    if(!toneGenerator){
        toneGenerator = [[THToneGenerator alloc] init];
    }
    
    THBuzzer * buzzer = (THBuzzer*)self.simulableObject;
    toneGenerator.frequency = buzzer.frequency;
    
    [toneGenerator play];
}

-(void) stopPlayingSound{
    [toneGenerator stop];
}

-(void) handleBuzzerOn{
    [self shake];
    [self playSound];
    self.on = YES;
}

-(void) handleBuzzerOff{
    [self stopShaking];
    [self stopPlayingSound];
    self.on = NO;
}

- (void)turnOn{
    if(!self.on){
        THBuzzer * buzzer = (THBuzzer*) self.simulableObject;
        [buzzer turnOn];
    }
}

- (void)turnOff{
    if(self.on){
        THBuzzer * buzzer = (THBuzzer*) self.simulableObject;
        [buzzer turnOff];
    }
}

-(void) willStartSimulation{
    [toneGenerator stop];
    
    if(self.onAtStart){
        [self turnOn];
    }
    
    [super willStartSimulation];
}

-(void) prepareToDie{
    toneGenerator = nil;
    [super prepareToDie];
}

-(NSString*) description{
    return @"Buzzer";
}

@end
