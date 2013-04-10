//
//  THCompass.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/20/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THCompass.h"
#import "THElementPin.h"

@implementation THCompass

-(void) load{
    
    TFProperty * property1 = [TFProperty propertyWithName:@"accelerometerX" andType:kDataTypeInteger];
    TFProperty * property2 = [TFProperty propertyWithName:@"accelerometerY" andType:kDataTypeInteger];
    TFProperty * property3 = [TFProperty propertyWithName:@"accelerometerZ" andType:kDataTypeInteger];
    
    TFProperty * property4 = [TFProperty propertyWithName:@"heading" andType:kDataTypeFloat];
    self.viewableProperties = [NSMutableArray arrayWithObjects:property1,property2,property3,property4,nil];
    
    self.viewableProperties = [NSMutableArray arrayWithObjects:property1,property2,property3,property4,nil];
    
    TFEvent * event1 = [TFEvent eventNamed:kEventXChanged];
    event1.param1 = [TFPropertyInvocation invocationWithProperty:property1 target:self];
    TFEvent * event2 = [TFEvent eventNamed:kEventYChanged];
    event2.param1 = [TFPropertyInvocation invocationWithProperty:property2 target:self];
    TFEvent * event3 = [TFEvent eventNamed:kEventZChanged];
    event3.param1 = [TFPropertyInvocation invocationWithProperty:property3 target:self];
    
    TFEvent * event4 = [TFEvent eventNamed:kEventHeadingChanged];
    event4.param1 = [TFPropertyInvocation invocationWithProperty:property4 target:self];
    
    self.events = [NSArray arrayWithObjects:event1,event2,event3,event4,nil];
}

-(void) loadPins{
    
    THElementPin * minusPin = [THElementPin pinWithType:kElementPintypeMinus];
    minusPin.hardware = self;
    THElementPin * sclPin = [THElementPin pinWithType:kElementPintypeScl];
    sclPin.hardware = self;
    sclPin.defaultBoardPinMode = kPinModeCompass;
    THElementPin * sdaPin = [THElementPin pinWithType:kElementPintypeSda];
    sdaPin.hardware = self;
    sdaPin.defaultBoardPinMode = kPinModeCompass;
    
    THElementPin * plusPin = [THElementPin pinWithType:kElementPintypePlus];
    
    [self.pins addObject:minusPin];
    [self.pins addObject:sclPin];
    [self.pins addObject:sdaPin];
    [self.pins addObject:plusPin];
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
    THCompass * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Methods

-(THElementPin*) pin5Pin{
    return [self.pins objectAtIndex:1];
}

-(THElementPin*) pin4Pin{
    return [self.pins objectAtIndex:2];
}

-(void) updatePinValue{
    
    THElementPin * pin = self.pin5Pin;
    THBoardPin * lilypadPin = (THBoardPin*) pin.attachedToPin;
    lilypadPin.currentValue = self.accelerometerX;
}

-(void) setAccelerometerX:(NSInteger)accelerometerX{
    if(accelerometerX != _accelerometerX){
        _accelerometerX = accelerometerX;
        //NSLog(@"new x: %d",_x);
        
        [self triggerEventNamed:kEventXChanged];
        [self updatePinValue];
    }
}

-(void) setAccelerometerY:(NSInteger)accelerometerY{
    if(accelerometerY != _accelerometerY){
        _accelerometerY = accelerometerY;
        //NSLog(@"new y: %d",_y);
        
        [self triggerEventNamed:kEventYChanged];
        [self updatePinValue];
    }
}

-(void) setAccelerometerZ:(NSInteger)accelerometerZ{
    if(accelerometerZ != _accelerometerZ){
        _accelerometerZ = accelerometerZ;
        //NSLog(@"new z: %d",_z);
        
        [self triggerEventNamed:kEventZChanged];
        [self updatePinValue];
    }
}

-(void) setHeading:(NSInteger)heading{
    if(heading != _heading){
        _heading = heading;
        [self triggerEventNamed:kEventHeadingChanged];
        [self updatePinValue];
    }
}

-(void) didStartSimulating{
    [self triggerEventNamed:kEventXChanged];
    [self triggerEventNamed:kEventYChanged];
    [self triggerEventNamed:kEventZChanged];
    
    [self triggerEventNamed:kEventHeadingChanged];
    
    [super didStartSimulating];
}

-(NSString*) description{
    return @"compass";
}

@end
