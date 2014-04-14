//
//  THGestureFingerEditable.m
//  TangoHapps
//
//  Created by Timm Beckmann on 02/04/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THFlexSensorEditable.h"
#import "THFlexSensor.h"

@implementation THFlexSensorEditable

@dynamic value;
@dynamic minValueNotify;
@dynamic maxValueNotify;
@dynamic notifyBehavior;

-(void) loadFlexSensor{
    self.sprite = [CCSprite spriteWithFile:@"flexSensor.png"];
    [self addChild:self.sprite];
    
    CGSize size = CGSizeMake(75, 20);
    
    //_valueLabel = [CCLabelTTF labelWithString:@"" fontName:kSimulatorDefaultFont fontSize:15 dimensions:size hAlignment:kCCVerticalTextAlignmentCenter];
    
    _valueLabel = [CCLabelTTF labelWithString:@"" dimensions:size hAlignment:NSTextAlignmentCenter vAlignment:kCCVerticalTextAlignmentCenter fontName:kSimulatorDefaultFont fontSize:15];
    
    _valueLabel.position = ccp(self.contentSize.width/2,self.contentSize.height/2-50);
    _valueLabel.visible = NO;
    [self addChild:_valueLabel z:1];
    
    self.acceptsConnections = YES;
}

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THFlexSensor alloc] init];
        
        self.type = kHardwareTypeFlexSensor;
        
        [self loadFlexSensor];
        [self loadPins];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    [self loadFlexSensor];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THFlexSensorEditable * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    //[controllers addObject:[THPotentiometerProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Pins

-(THElementPinEditable*) minusPin{
    return [self.pins objectAtIndex:1];
}

-(THElementPinEditable*) analogPin{
    return [self.pins objectAtIndex:2];
}

-(THElementPinEditable*) plusPin{
    return [self.pins objectAtIndex:0];
}

#pragma mark - Methods

-(void) handleTouchBegan{
    self.isDown = YES;
}

-(void) handleTouchEnded{
    self.isDown = NO;
}

-(void) update{
    
    if(self.isDown){
        _touchDownIntensity += 2.0f;
    } else {
        _touchDownIntensity -= 1.0f;
    }
    _touchDownIntensity = [THClientHelper Constrain:_touchDownIntensity min:0 max:kMaxFlexSensorValue];
    
    THFlexSensor * flexSensor = (THFlexSensor*) self.simulableObject;
    flexSensor.value = _touchDownIntensity;
    _valueLabel.string = [NSString stringWithFormat:@"%d",flexSensor.value];
}

-(NSInteger) value{
    
    THFlexSensor * flexSensor = (THFlexSensor*) self.simulableObject;
    return flexSensor.value;
}

-(NSInteger) minValueNotify{
    
    THFlexSensor * flexSensor = (THFlexSensor*) self.simulableObject;
    return flexSensor.minValueNotify;
}

-(void) setMinValueNotify:(NSInteger)minValueNotify{
    
    THFlexSensor * flexSensor = (THFlexSensor*) self.simulableObject;
    flexSensor.minValueNotify = minValueNotify;
}

-(NSInteger) maxValueNotify{
    
    THFlexSensor * flexSensor = (THFlexSensor*) self.simulableObject;
    return flexSensor.maxValueNotify;
}

-(void) setMaxValueNotify:(NSInteger)maxValueNotify{
    
    THFlexSensor * flexSensor = (THFlexSensor*) self.simulableObject;
    flexSensor.maxValueNotify = maxValueNotify;
}

-(THSensorNotifyBehavior) notifyBehavior{
    
    THFlexSensor * flexSensor = (THFlexSensor*) self.simulableObject;
    return flexSensor.notifyBehavior;
}

-(void) setNotifyBehavior:(THSensorNotifyBehavior)notifyBehavior{
    THFlexSensor * flexSensor = (THFlexSensor*) self.simulableObject;
    flexSensor.notifyBehavior = notifyBehavior;
}

-(void) handleRotation:(float) degree{
    
    THFlexSensor * flexSensor = (THFlexSensor*) self.simulableObject;
    _value += degree*10;
    
    _value = [THClientHelper Constrain:_value min:0 max:kMaxFlexSensorValue];
    flexSensor.value = (NSInteger) _value;
}

-(void) willStartEdition{
    _valueLabel.visible = NO;
}

-(void) willStartSimulation{
    THFlexSensor * flexSensor = (THFlexSensor*) self.simulableObject;
    _value = flexSensor.value;
    _valueLabel.visible = YES;
    
    [super willStartSimulation];
}

-(NSString*) description{
    return @"Flex Sensor";
}


@end
