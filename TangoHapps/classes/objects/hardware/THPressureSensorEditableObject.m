//
//  THPressureSensorEditableObject.m
//  TangoHapps
//
//  Created by Guven Candogan on 15/01/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THPressureSensorEditableObject.h"
#import "THPressureSensor.h"
#import "THElementPinEditable.h"
#import "THElementPin.h"
#import "THBoardPinEditable.h"

@implementation THPressureSensorEditableObject

@dynamic pressure;
@dynamic notifyBehavior;
@dynamic minValueNotify;
@dynamic maxValueNotify;

-(void) loadPressureSensor{
    self.sprite = [CCSprite spriteWithFile:@"pressureSensor.png"];
    [self addChild:self.sprite];
    
    CGSize size = CGSizeMake(75, 20);
    
    _pressureLabel = [CCLabelTTF labelWithString:@"" fontName:kSimulatorDefaultFont fontSize:15 dimensions:size hAlignment:kCCVerticalTextAlignmentCenter];
    
    _pressureLabel.position = ccp(self.contentSize.width/2,self.contentSize.height/2-80);
    _pressureLabel.color = kDefaultSimulationLabelColor;
    _pressureLabel.visible = NO;
    [self addChild:_pressureLabel z:1];

    self.acceptsConnections = YES;
}

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THPressureSensor alloc] init];
        
        self.type = kHardwareTypePressureSensor;
        
        [self loadPressureSensor];
        [self loadPins];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    [self loadPressureSensor];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THPressureSensorEditableObject * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Pins


-(THElementPin*) minusPin{
    return [self.pins objectAtIndex:1];
}

-(THElementPin*) analogPin{
    return [self.pins objectAtIndex:2];
}

-(THElementPin*) plusPin{
    return [self.pins objectAtIndex:0];
}


#pragma mark - Methods

-(void) updatePinValue{
    THElementPinEditable * pin = self.analogPin;
    THBoardPinEditable * boardPin = pin.attachedToPin;
    THPressureSensor * sensor = (THPressureSensor *) self.simulableObject;
    boardPin.value = sensor.pressure;
}

-(void) handleTouchBegan{
    self.isDown = YES;
}

-(void) handleTouchEnded{
    self.isDown = NO;
}

-(void) update{
    
    if(self.isDown){
        _pressureIntensity += kDefaultAnalogSimulationIncrease;
    } else {
        _pressureIntensity -= kDefaultAnalogSimulationIncrease;
    }
    _pressureIntensity = [THClientHelper Constrain:_pressureIntensity min:0 max:kMaxAnalogValue];
    
    THPressureSensor * pressureSensor = (THPressureSensor*) self.simulableObject;
    pressureSensor.pressure = _pressureIntensity;
    _pressureLabel.string = [NSString stringWithFormat:@"%ld",(long)pressureSensor.pressure];
}

-(NSInteger) pressure{
    
    THPressureSensor * pressureSensor = (THPressureSensor*) self.simulableObject;
    return pressureSensor.pressure;
}

-(void) willStartEdition{
    _pressureLabel.visible = NO;
}

-(void) willStartSimulation{
    THPressureSensor * pressureSensor = (THPressureSensor*) self.simulableObject;
    _pressure = pressureSensor.pressure;
    _pressureLabel.visible = YES;
    
    [super willStartSimulation];
}

-(THSensorNotifyBehavior) notifyBehavior{
    
    THPressureSensor * pressureSensor = (THPressureSensor*) self.simulableObject;
    return pressureSensor.notifyBehavior;
}

-(void) setNotifyBehavior:(THSensorNotifyBehavior)notifyBehavior{
    THPressureSensor * pressureSensor = (THPressureSensor*) self.simulableObject;
    pressureSensor.notifyBehavior = notifyBehavior;
}

-(NSInteger) minValueNotify{
    
    THPressureSensor * pressureSensor = (THPressureSensor*) self.simulableObject;
    return pressureSensor.minValueNotify;
}

-(void) setMinValueNotify:(NSInteger)minValueNotify{
    
    THPressureSensor * pressureSensor = (THPressureSensor*) self.simulableObject;
    pressureSensor.minValueNotify = minValueNotify;
}

-(NSInteger) maxValueNotify{
    
    THPressureSensor * pressureSensor = (THPressureSensor*) self.simulableObject;
    return pressureSensor.maxValueNotify;
}

-(void) setMaxValueNotify:(NSInteger)maxValueNotify{
    
    THPressureSensor * pressureSensor = (THPressureSensor*) self.simulableObject;
    pressureSensor.maxValueNotify = maxValueNotify;
}

-(NSString*) description{
    return @"Pressure Sensor";
}

@end
