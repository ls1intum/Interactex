//
//  THBuzzer.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THBuzzer.h"
#import "THToneGenerator.h"
#import "THElementPin.h"
#import "THPin.h"

@implementation THBuzzer


float const kBuzzerMaxFrequency = 20000;
float const kBuzzerMinFrequency = 20;

-(void) load{
        
    TFProperty * property1 = [TFProperty propertyWithName:@"frequency" andType:kDataTypeFloat];
    TFProperty * property2 = [TFProperty propertyWithName:@"on" andType:kDataTypeBoolean];
    self.viewableProperties = [NSMutableArray arrayWithObjects:property1, property2, nil];
    
    TFMethod * method1 =[TFMethod methodWithName:@"varyFrequency"];
    method1.numParams = 1;
    method1.firstParamType = kDataTypeFloat;
    
    TFMethod * method2 =[TFMethod methodWithName:@"setFrequency"];
    method2.numParams = 1;
    method2.firstParamType = kDataTypeFloat;
    
    TFMethod * method3 = [TFMethod methodWithName:@"turnOn"];
    TFMethod * method4 = [TFMethod methodWithName:@"turnOff"];
    self.methods = [NSArray arrayWithObjects:method1,method2,method3,method4,nil];

    TFEvent * event0 = [TFEvent eventNamed:kEventOnChanged];
    event0.param1 = [TFPropertyInvocation invocationWithProperty:property2 target:self];
    TFEvent * event1 = [TFEvent eventNamed:@"frequencyChanged"];
    event1.param1 = [TFPropertyInvocation invocationWithProperty:property1 target:self];
    TFEvent * event2 = [TFEvent eventNamed:kEventTurnedOn];
    TFEvent * event3 = [TFEvent eventNamed:kEventTurnedOff];
    self.events = [NSArray arrayWithObjects:event0,event1,event2,event3,nil];
}

-(void) loadPins{
    
    THElementPin * pin1 = [THElementPin pinWithType:kElementPintypeDigital];
    pin1.hardware = self;
    pin1.defaultBoardPinMode = kPinModeBuzzer;
    THElementPin * pin2 = [THElementPin pinWithType:kElementPintypeMinus];
    pin2.hardware = self;
    
    [self.pins addObject:pin1];
    [self.pins addObject:pin2];
}

-(id) init{
    self = [super init];
    if(self){
        [self load];
        [self loadPins];
        
        self.frequency = 2500;
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    [self load];
    
    self.frequency = [decoder decodeFloatForKey:@"frequency"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeFloat:self.frequency forKey:@"frequency"];
}

-(id)copyWithZone:(NSZone *)zone
{
    THBuzzer * copy = [super copyWithZone:zone];
    
    copy.frequency = self.frequency;
    copy.on = self.on;
    
    return copy;
}

#pragma mark - Methods

-(THElementPin*) minusPin{
    return [self.pins objectAtIndex:1];
}

-(THElementPin*) digitalPin{
    return [self.pins objectAtIndex:0];
}

//[0 255] --> [20 20000]
-(float) pinToFrequency:(NSInteger) analogValue{
    return [THClientHelper LinearMapping:analogValue min:0 max:255 retMin:kBuzzerMinFrequency retMax:kBuzzerMaxFrequency];
}

-(NSInteger) frequencyToPin:(float) frequency{
    
    float newVal = [THClientHelper LinearMapping:frequency min:kBuzzerMinFrequency max:kBuzzerMaxFrequency retMin:0 retMax:255];
    
    return (NSInteger) (newVal + 0.5f);//round
}

-(void) handlePin:(THBoardPin*) pin changedValueTo:(NSInteger) newValue{
    
    if(newValue < 0){
        return;
    }
    if(pin.mode == kPinModeDigitalOutput){
        if(!self.on && newValue == kDigitalPinValueHigh){
            [self turnOn];
        } else if(self.on && newValue == kDigitalPinValueLow){
            [self turnOff];
        }
    } else if(pin.mode == kPinModeBuzzer){
        self.frequency = [self pinToFrequency:newValue];
    }
}

-(void) updatePinValue{
    
    THElementPin * pin = self.digitalPin;
    THBoardPin * lilypadPin = (THBoardPin*) pin.attachedToPin;
    
    if(lilypadPin.mode == kPinModeDigitalOutput){
        
        [lilypadPin setValueWithoutNotifications:self.on];
        
    } else if(lilypadPin.mode == kPinModeBuzzer){
        
        float newPinValue = [self frequencyToPin:self.frequency];
        [lilypadPin setValueWithoutNotifications:(self.on ? newPinValue : -1)];
    }
}

-(void) setOn:(BOOL)on{
    _on = on;
    [self triggerEventNamed:kEventOnChanged];
    [self updatePinValue];
}

- (void)turnOn{
    if(!self.on){
        self.on = YES;
        [self triggerEventNamed:kEventTurnedOn];
    }
}

- (void)turnOff{
    if(self.on){
        self.on = NO;
        [self triggerEventNamed:kEventTurnedOff];
    }
}

-(void) varyFrequency:(float) dt{
    self.frequency += dt;
}

-(void) setFrequency:(float)frequency{
    
    _frequency = frequency;
    
    [self triggerEventNamed:kEventFrequencyChanged];
    [self updatePinValue];
}

-(void) didStartSimulating{
    [self triggerEventNamed:kEventFrequencyChanged];
    [self triggerEventNamed:kEventOnChanged];
    [super didStartSimulating];
}

-(NSString*) description{
    return @"buzzer";
}

@end
