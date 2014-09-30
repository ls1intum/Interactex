//
//  THFlexSensor.m
//  TangoHapps
//
//  Created by Timm Beckmann on 02/04/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THFlexSensor.h"
#import "THElementPin.h"

@implementation THFlexSensor
//@dynamic plusPin;

float const kMaxFlexSensorValue = 1023;

#pragma mark - Initialization

-(id) init{
    self = [super init];
    if(self){
        [self load];
        [self loadPins];
        self.minValueNotify = 0;
        self.maxValueNotify = 255;
    }
    return self;
}

-(void) load{
    
    TFProperty * property1 = [TFProperty propertyWithName:@"value" andType:kDataTypeInteger];
    self.properties = [NSMutableArray arrayWithObjects:property1,nil];
    
    TFEvent * event = [TFEvent eventNamed:kEventValueChanged];
    event.param1 = [TFPropertyInvocation invocationWithProperty:property1 target:self];
    self.events = [NSMutableArray arrayWithObjects:event,nil];
}

-(void) loadPins{
    
    //THElementPin * pin1 = [THElementPin pinWithType:kElementPintypePlus];
    //pin1.hardware = self;
    THElementPin * pin2 = [THElementPin pinWithType:kElementPintypeMinus];
    //pin2.hardware = self;
    THElementPin * pin3 = [THElementPin pinWithType:kElementPintypeAnalog];
    //pin3.hardware = self;
    pin3.defaultBoardPinMode = kPinModeAnalogInput;
    
    //[self.pins addObject:pin1];
    [self.pins addObject:pin2];
    [self.pins addObject:pin3];
}



#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder{
    self = [super initWithCoder:decoder];
    
    self.minValueNotify = [decoder decodeIntegerForKey:@"minValueNotify"];
    self.maxValueNotify = [decoder decodeIntegerForKey:@"maxValueNotify"];
    self.notifyBehavior = [decoder decodeIntegerForKey:@"notifyBehavior"];
    
    [self load];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    [super encodeWithCoder:coder];
    
    [coder encodeInteger:self.minValueNotify forKey:@"minValueNotify"];
    [coder encodeInteger:self.maxValueNotify forKey:@"maxValueNotify"];
    [coder encodeInteger:self.notifyBehavior forKey:@"notifyBehavior"];
}

-(id)copyWithZone:(NSZone *)zone{
    THFlexSensor * copy = [super copyWithZone:zone];
    copy.minValueNotify = self.minValueNotify;
    copy.maxValueNotify = self.maxValueNotify;
    copy.notifyBehavior = self.notifyBehavior;
    
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
    
    THElementPin * pin = self.plusPin;
    THBoardPin * lilypadPin = (THBoardPin*) pin.attachedToPin;
    lilypadPin.value = self.value;
    
}

-(void) handlePin:(THPin*) pin changedValueTo:(NSInteger) newValue{
    _value = newValue;
    [self checkNotifyValueChanged];
}

-(void) checkNotifyValueChanged{
    
    if(self.notifyBehavior == kSensorNotifyBehaviorAlways){
        [self triggerEventNamed:kEventValueChanged];
    } else if(self.notifyBehavior == kSensorNotifyBehaviorWhenInRange){
        if(_value >= self.minValueNotify && _value <= self.maxValueNotify){
            [self triggerEventNamed:kEventValueChanged];
        }
    } else {
        BOOL newInsideRange;
        if(_value >= self.minValueNotify && _value <= self.maxValueNotify){
            newInsideRange = YES;
        } else {
            newInsideRange = NO;
        }
        
        if(newInsideRange != _insideRange){
            _insideRange = newInsideRange;
            if(newInsideRange){
                [self triggerEventNamed:kEventValueChanged];
            }
        }
    }
}

-(void) setValue:(NSInteger)value{
    value = [THClientHelper Constrain:value min:0 max:kMaxFlexSensorValue];
    if(value != _value){
        _value = value;
        //NSLog(@"new val: %d",_value);
        [self checkNotifyValueChanged];
        
        [self updatePinValue];
    }
}

-(void) didStartSimulating{
    [self triggerEventNamed:kEventValueChanged];
    [super didStartSimulating];
}

-(NSString*) description{
    return @"flex sensor";
}
@end

