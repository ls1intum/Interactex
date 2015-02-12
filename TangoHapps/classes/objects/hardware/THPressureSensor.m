//
//  THPressureSensor.m
//  TangoHapps
//
//  Created by Guven Candogan on 15/01/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THPressureSensor.h"
#import "THElementPin.h"

@implementation THPressureSensor

@synthesize pressure = _pressure;

static NSInteger kInitialPressure = 0;

#pragma mark - Creation and Initialization

-(id) init{
    self = [super init];
    if(self){
        
        [self load];
        [self loadPins];
        self.minValueNotify = 0;
        self.maxValueNotify = 255;
        self.pressure = kInitialPressure;
    }
    return self;
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

-(void) load{
    TFProperty * property1 = [TFProperty propertyWithName:@"pressure" andType:kDataTypeInteger];
    self.properties = [NSMutableArray arrayWithObjects:property1,nil];
    
    TFEvent * event = [TFEvent eventNamed:kEventPressureChanged];
    event.param1 = [TFPropertyInvocation invocationWithProperty:property1 target:self];
    self.events = [NSMutableArray arrayWithObjects:event,nil];
    
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        
        self.pressure = [decoder decodeIntegerForKey:@"pressure"];
        self.notifyBehavior = [decoder decodeIntegerForKey:@"notifyBehavior"];
        self.minValueNotify = [decoder decodeIntegerForKey:@"minValueNotify"];
        self.maxValueNotify = [decoder decodeIntegerForKey:@"maxValueNotify"];
        
        [self load];
        [self loadPins];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeInteger:self.pressure forKey:@"pressure"];
    [coder encodeInteger:self.notifyBehavior forKey:@"notifyBehavior"];
    [coder encodeInteger:self.minValueNotify forKey:@"minValueNotify"];
    [coder encodeInteger:self.maxValueNotify forKey:@"maxValueNotify"];
}

-(id)copyWithZone:(NSZone *)zone{
    THPressureSensor * copy = [super copyWithZone:zone];
    copy.pressure = self.pressure;
    copy.notifyBehavior = self.notifyBehavior;
    copy.minValueNotify = self.minValueNotify;
    copy.maxValueNotify = self.maxValueNotify;
    
    return copy;
}

#pragma mark - Methods

-(THElementPin*) minusPin{
    return [self.pins objectAtIndex:1];
}

-(THElementPin*) analogPin{
    return [self.pins objectAtIndex:2];
}

-(THElementPin*) plusPin{
    return [self.pins objectAtIndex:0];
}

-(void) updatePinValue{
    THElementPin * pin = self.analogPin;
    THBoardPin * lilypadPin = (THBoardPin*) pin.attachedToPin;
    lilypadPin.value = self.pressure;
}

-(void) handlePin:(THPin*) pin changedValueTo:(NSInteger) newValue{
    self.pressure = newValue;
    [self checkNotifyValueChanged];
}

-(void) setPressure:(NSInteger)pressure{
    pressure = [THClientHelper Constrain:pressure min:0 max:kMaxAnalogValue];
    if(_pressure!=pressure){
        _pressure=pressure;
        [self checkNotifyValueChanged];
        [self updatePinValue];
    }
}

-(void) didStartSimulating{
    [self triggerEventNamed:kEventPressureChanged];
    [super didStartSimulating];
}

-(void) checkNotifyValueChanged{

    if(self.notifyBehavior == kSensorNotifyBehaviorAlways){
        [self triggerEventNamed:kEventPressureChanged];
    } else if(self.notifyBehavior == kSensorNotifyBehaviorWhenInRange){
        if(_pressure >= self.minValueNotify && _pressure <= self.maxValueNotify){
            [self triggerEventNamed:kEventPressureChanged];
        }
    } else {
        BOOL newInsideRange;
        if(_pressure >= self.minValueNotify && _pressure <= self.maxValueNotify){
            newInsideRange = YES;
        } else {
            newInsideRange = NO;
        }
        
        if(newInsideRange != _insideRange){
            _insideRange = newInsideRange;
            if(newInsideRange){
                [self triggerEventNamed:kEventPressureChanged];
            }
        }
    }

}

-(NSString*) description{
    return @"Pressure sensor";
}
@end
