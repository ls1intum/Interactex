//
//  THLightSensorEditableObject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/12/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THLightSensorEditableObject.h"
#import "THLightSensor.h"
#import "THElementPinEditable.h"
#import "THElementPin.h"
#import "THBoardPinEditable.h"

@implementation THLightSensorEditableObject

-(void) loadLightSensor{
    self.sprite = [CCSprite spriteWithFile:@"lightSensor.png"];
    [self addChild:self.sprite z:kClotheObjectZ];
    
    _lightSprite = [CCSprite spriteWithFile: @"light.png"];
    _lightSprite.opacity = 0;
    _lightSprite.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
    [self addChild:_lightSprite];
    
    self.acceptsConnections = YES;
    
}

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THLightSensor alloc] init];
        
        self.type = kHardwareTypeLightSensor;
        
        [self loadLightSensor];
        [self loadPins];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    [self loadLightSensor];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THLightSensorEditableObject * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    //[controllers addObject:[THLightSensorProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(void) handleTouchBegan{
    self.isDown = YES;
}

-(void) handleTouchEnded{
    self.isDown = NO;
}

-(THElementPinEditable*) minusPin{
    return [self.pins objectAtIndex:0];
}

-(THElementPinEditable*) analogPin{
    return [self.pins objectAtIndex:1];
}

-(THElementPinEditable*) plusPin{
    return [self.pins objectAtIndex:2];
}

-(void) updatePinValue{
    THElementPinEditable * analogPin = self.analogPin;
    THBoardPinEditable * boardPin = analogPin.attachedToPin;
    THLightSensor * sensor = (THLightSensor*) self.simulableObject;
    boardPin.value = sensor.light;
}

-(void) update{
    
    if(self.isDown){
        _lightTouchDownIntensity += 1.5f;
    } else {
        _lightTouchDownIntensity -= 1.0f;
    }
    THLightSensor * lightSensor = (THLightSensor*) self.simulableObject;
    _lightTouchDownIntensity = [THClientHelper Constrain:_lightTouchDownIntensity min:0 max:255];
    
    lightSensor.light =_lightTouchDownIntensity;
    _lightSprite.opacity = _lightTouchDownIntensity;
}

-(void) willStartSimulation{
    _lightSprite.visible = YES;
    [super willStartSimulation];
}

-(void) willStartEdition{
    _lightSprite.visible = NO;
    [super willStartEdition];
}

-(NSInteger) light{
    THLightSensor * lightSensor = (THLightSensor*) self.simulableObject;
    return lightSensor.light;
}

-(NSString*) description{
    return @"Light Sensor";
}

@end
