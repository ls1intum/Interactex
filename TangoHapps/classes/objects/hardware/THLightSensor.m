//
//  THLightSensor.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/12/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THLightSensor.h"
#import "THElementPin.h"

@implementation THLightSensor

-(void) load{
    
    TFProperty * property = [TFProperty propertyWithName:@"light" andType:kDataTypeInteger];
    self.properties = [NSMutableArray arrayWithObject:property];
    
    TFEvent * event = [TFEvent eventNamed:kEventLightChanged];
    event.param1 = [TFPropertyInvocation invocationWithProperty:property target:self];
    self.events = [NSArray arrayWithObject:event];
}

-(void) loadPins{
    
    THElementPin * pin1 = [THElementPin pinWithType:kElementPintypeMinus];
    pin1.hardware = self;
    THElementPin * pin2 = [THElementPin pinWithType:kElementPintypeAnalog];
    pin2.hardware = self;
    pin2.defaultBoardPinMode = kPinModeAnalogInput;
    THElementPin * pin3 = [THElementPin pinWithType:kElementPintypePlus];
    pin3.hardware = self;
    
    [self.pins addObject:pin1];
    [self.pins addObject:pin2];
    [self.pins addObject:pin3];
}

-(id) init{
    self = [super init];
    if(self){
        [self load];
        [self loadPins];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder{
    self = [super initWithCoder:decoder];
    
    [self load];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone{
    THLightSensor * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Protocols

-(NSString*) description{
    return @"light sensor";
}

#pragma mark - Methods

-(THElementPin*) minusPin{
    return [self.pins objectAtIndex:0];
}

-(THElementPin*) analogPin{
    return [self.pins objectAtIndex:1];
}

-(THElementPin*) plusPin{
    return [self.pins objectAtIndex:2];
}

-(void) updatePinValue{
    
    THElementPin * pin = self.analogPin;
    THBoardPin * lilypadPin = (THBoardPin*) pin.attachedToPin;
    lilypadPin.value = self.light;
}

-(void) handlePin:(THBoardPin*) pin changedValueTo:(NSInteger) newValue{
    self.light = newValue;
}

-(void) setLight:(NSInteger)light{
    if(_light != light){
        _light = light;
        [self triggerEventNamed:kEventLightChanged];
        [self updatePinValue];
    }
}
@end
