//
//  THVibrationBoard.m
//  TangoHapps
//
//  Created by Juan Haladjian on 4/12/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THVibrationBoard.h"
#import "THElementPin.h"

@implementation THVibrationBoard

-(void) loadVibrationBoard{
    
    TFProperty * property1 = [TFProperty propertyWithName:@"on" andType:kDataTypeBoolean];
    TFProperty * property2 = [TFProperty propertyWithName:@"frequency" andType:kDataTypeInteger];
    self.viewableProperties = [NSMutableArray arrayWithObjects:property1,property2,nil];
    
    TFMethod * method1 =[TFMethod methodWithName:@"setFrequency"];
    method1.numParams = 1;
    method1.firstParamType = kDataTypeInteger;
    
    TFMethod * method2 = [TFMethod methodWithName:kMethodTurnOn];
    TFMethod * method3 = [TFMethod methodWithName:kMethodTurnOff];
    self.methods = [NSArray arrayWithObjects:method1,method2,method3,nil];
    
    TFEvent * event0 = [TFEvent eventNamed:kEventOnChanged];
    event0.param1 = [TFPropertyInvocation invocationWithProperty:property1 target:self];
    TFEvent * event1 = [TFEvent eventNamed:kEventIntensityChanged];
    event1.param1 = [TFPropertyInvocation invocationWithProperty:property2 target:self];
    TFEvent * event2 = [TFEvent eventNamed:kEventTurnedOn];
    TFEvent * event3 = [TFEvent eventNamed:kEventTurnedOff];
    self.events = [NSArray arrayWithObjects:event0,event1,event2,event3,nil];
}

-(void) loadPins{
    
    THElementPin * pin1 = [THElementPin pinWithType:kElementPintypeMinus];
    pin1.hardware = self;
    THElementPin * pin2 = [THElementPin pinWithType:kElementPintypeDigital];
    pin2.hardware = self;
    pin2.defaultBoardPinMode = kPinModeDigitalOutput;
    [self.pins addObject:pin1];
    [self.pins addObject:pin2];
}

-(id) init{
    self = [super init];
    if(self){
        [self loadVibrationBoard];
        [self loadPins];
        self.frequency = 255;
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder{
    self = [super initWithCoder:decoder];
    self.frequency = [decoder decodeIntegerForKey:@"frequency"];
    
    [self loadVibrationBoard];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    [super encodeWithCoder:coder];
    [coder encodeInteger:self.frequency forKey:@"frequency"];
}

-(id)copyWithZone:(NSZone *)zone{
    THVibrationBoard * copy = [super copyWithZone:zone];
    
    copy.on = self.on;
    copy.frequency = self.frequency;
    
    return copy;
}

#pragma mark - Methods

-(THElementPin*) minusPin{
    return [self.pins objectAtIndex:0];
}

-(THElementPin*) digitalPin{
    return [self.pins objectAtIndex:1];
}

-(void) handlePin:(THBoardPin*) pin changedValueTo:(NSInteger) newValue{
    
    if(pin.mode == kPinModeDigitalOutput){
        if(!self.on && newValue == kDigitalPinValueHigh){
            [self turnOn];
        } else if(self.on && newValue == kDigitalPinValueLow){
            [self turnOff];
        }
    } else {
        self.frequency = newValue;
    }
}

-(void) updatePinValue {
    
    THElementPin * pin = [self.pins objectAtIndex:1];
    THBoardPin * lilypadPin = (THBoardPin*) pin.attachedToPin;
    
    if(lilypadPin.mode == kPinModeDigitalOutput){
        lilypadPin.currentValue = self.on;
    } else {
        lilypadPin.currentValue = self.frequency;
    }
}

-(void) setOn:(BOOL)on{
    _on = on;
    [self triggerEventNamed:kEventOnChanged];
    [self updatePinValue];
}

- (void)turnOn {
    if(!self.on){
        NSLog(@"vibe on");
        self.on = YES;
        
        [self triggerEventNamed:kEventTurnedOn];
    }
}

- (void)turnOff {
    if(self.on){
        NSLog(@"vibe off");
        self.on = NO;
        
        [self triggerEventNamed:kEventTurnedOff];
    }
}

-(void) clampFrequency {
    if(_frequency > kMaxAnalogValue){
        _frequency = kMaxAnalogValue;
    } else if(_frequency < 0){
        _frequency = 0;
    }
}

-(void) varyFrequency:(NSInteger) di {
    self.frequency = self.frequency + di;
}

-(void) setFrequency:(NSInteger)frequency {
    
    _frequency = frequency;
    [self clampFrequency];
    [self triggerEventNamed:kEventFrequencyChanged];
    [self updatePinValue];
}

-(void) didStartSimulating{
    
    [self triggerEventNamed:kEventFrequencyChanged];
    
    THElementPin * pin = [self.pins objectAtIndex:1];
    THBoardPin * lilypadPin = (THBoardPin*) pin.attachedToPin;
    if(lilypadPin.mode == kPinModePWM){
        [self turnOn];
    } else {
        [self triggerEventNamed:kEventOnChanged];
    }
    
    [super didStartSimulating];
}

-(NSString*) description{
    return @"vibeboard";
}


@end
