//
//  Led.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "THLed.h"
#import "THElementPin.h"

@implementation THLed

@synthesize on = _on;
@dynamic digitalPin;
@dynamic minusPin;

-(void) loadLed{
    
    TFProperty * property1 = [TFProperty propertyWithName:@"on" andType:kDataTypeBoolean];
    TFProperty * property2 = [TFProperty propertyWithName:@"intensity" andType:kDataTypeInteger];
    self.viewableProperties = [NSMutableArray arrayWithObjects:property1,property2,nil];
    
    TFMethod * method1 =[TFMethod methodWithName:@"varyIntensity"];
    method1.numParams = 1;
    method1.firstParamType = kDataTypeInteger;
    
    TFMethod * method2 =[TFMethod methodWithName:@"setIntensity"];
    method2.numParams = 1;
    method2.firstParamType = kDataTypeInteger;
    
    TFMethod * method3 = [TFMethod methodWithName:kMethodTurnOn];
    TFMethod * method4 = [TFMethod methodWithName:kMethodTurnOff];
    self.methods = [NSArray arrayWithObjects:method1,method2,method3,method4,nil];
    
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
        [self loadLed];
        [self loadPins];
        self.intensity = 255;
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder{
    self = [super initWithCoder:decoder];
    self.onAtStart = [decoder decodeBoolForKey:@"onAtStart"];
    self.intensity = [decoder decodeIntegerForKey:@"intensity"];
    
    [self loadLed];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    [super encodeWithCoder:coder];
    [coder encodeBool:self.onAtStart forKey:@"onAtStart"];
    [coder encodeInteger:self.intensity forKey:@"intensity"];
}

-(id)copyWithZone:(NSZone *)zone{
    THLed * copy = [super copyWithZone:zone];
    
    copy.on = self.on;
    copy.onAtStart = self.onAtStart;
    copy.intensity = self.intensity;
    
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
    //NSLog(@"pin changed: %d",newValue);
    
    if(pin.mode == kPinModeDigitalOutput){
        if(!self.on && newValue == kDigitalPinValueHigh){
            [self turnOn];
        } else if(self.on && newValue == kDigitalPinValueLow){
            [self turnOff];
        }
    } else {
        self.intensity = newValue;
    }
}

-(void) updatePinValue {

    THElementPin * pin = [self.pins objectAtIndex:1];
    THBoardPin * lilypadPin = (THBoardPin*) pin.attachedToPin;
    
    if(lilypadPin.mode == kPinModeDigitalOutput){
        lilypadPin.currentValue = self.on;
    } else {
        if(self.on){
            lilypadPin.currentValue = self.intensity;
        } else {
            lilypadPin.currentValue = 0;
        }
    }
    //NSLog(@"lilypin: %@",lilypadPin);
}

-(void) setOn:(BOOL)on{
    _on = on;
    [self triggerEventNamed:kEventOnChanged];
    [self updatePinValue];
}

- (void)turnOn {
    if(!self.on){
        NSLog(@"led on");
        self.on = YES;
        
        [self triggerEventNamed:kEventTurnedOn];
    }
}

- (void)turnOff {
    if(self.on){
        NSLog(@"led off");
        self.on = NO;
        
        [self triggerEventNamed:kEventTurnedOff];
    }
}

-(void) clampIntensity {
    if(_intensity > kMaxAnalogValue){
        _intensity = kMaxAnalogValue;
    } else if(_intensity < 0){
        _intensity = 0;
    }
}

-(void) varyIntensity:(NSInteger) di {
    self.intensity = self.intensity + di;
}

-(void) setIntensity:(NSInteger)intensity {
    
    _intensity = intensity;
    [self clampIntensity];
    [self triggerEventNamed:kEventIntensityChanged];
    [self updatePinValue];
}

-(void) didStartSimulating{
    
    [self triggerEventNamed:kEventIntensityChanged];
    
    THElementPin * pin = [self.pins objectAtIndex:1];
    THBoardPin * lilypadPin = (THBoardPin*) pin.attachedToPin;    
    if(lilypadPin.mode == kPinModePWM || self.onAtStart){
        [self turnOn];
    } else {
        [self triggerEventNamed:kEventOnChanged];
    }

    [super didStartSimulating];
}

-(NSString*) description{
    return @"led";
}

@end
