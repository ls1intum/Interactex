//
//  THLedEditableObject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/19/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THLedEditableObject.h"
#import "THLed.h"
#import "THLedProperties.h"
#import "THElementPin.h"
#import "THPin.h"
#import "THPinEditable.h"
#import "THElementPinEditable.h"

@implementation THLedEditableObject
@dynamic on;
@dynamic onAtStart;
@dynamic intensity;

-(void) loadLed{
    self.sprite = [CCSprite spriteWithFile:@"led.png"];
    [self addChild:self.sprite];
    
    _lightSprite = [CCSprite spriteWithFile:@"yellowLight.png"];
    _lightSprite.visible = NO;
    _lightSprite.position = ccp(20,20);
    [self.sprite addChild:_lightSprite];
    
    self.acceptsConnections = YES;
}

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THLed alloc] init];

        self.type = kHardwareTypeLed;
        
        [self loadLed];
        [self loadPins];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    [self loadLed];
    [self adaptIntensityToLed];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder*) coder
{
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone*) zone
{
    THLedEditableObject * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THLedProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(THElementPinEditable*) minusPin{
    return [self.pins objectAtIndex:0];
}

-(THElementPinEditable*) digitalPin{
    return [self.pins objectAtIndex:1];
}

-(void) updateToPinValue{
    
    THElementPinEditable * pine = [self.pins objectAtIndex:1];
    THElementPin * pin = (THElementPin*) pine.simulableObject;
    THBoardPin * lilypadPin = (THBoardPin*) pin.attachedToPin;
    
    if(lilypadPin.type == kPintypeDigital){
        if(lilypadPin.currentValue == kDigitalPinValueHigh && !self.on){
            [self turnOn];
        } else if(lilypadPin.currentValue == kDigitalPinValueLow && self.on){
            [self turnOff];
        }
    } else if(lilypadPin.type == kPintypeAnalog){
        THLed * led = (THLed*)self.simulableObject;
        led.intensity = lilypadPin.currentValue;
    }
}

-(void) update{
    
    if(self.on && !_lightSprite.visible){
        [self handleLedOn];
    } else if(!self.on && _lightSprite.visible){
        [self handleLedOff];
    }
    [self adaptIntensityToLed];
}

-(void) setOnAtStart:(BOOL)onAtStart{
    
    THLed * led = (THLed*)self.simulableObject;
    led.onAtStart = onAtStart;
}

-(BOOL) onAtStart{
    
    THLed * led = (THLed*)self.simulableObject;
    return led.onAtStart;
}

-(void) adaptIntensityToLed{
    
    THLed * led = (THLed*)self.simulableObject;
    _lightSprite.opacity = led.intensity;
}

-(BOOL) on{
    THLed * led = (THLed*) self.simulableObject;
    return led.on;
}

-(void) varyIntensity:(NSInteger) di {
    
    THLed * led = (THLed*)self.simulableObject;
    [led varyIntensity:di];
}

-(NSInteger) intensity{
    THLed * led = (THLed*) self.simulableObject;
    return led.intensity;
}

-(void) setIntensity:(NSInteger)intensity{
    
    THLed * led = (THLed*) self.simulableObject;
    led.intensity = intensity;
}

-(void) handleLedOn{
    _lightSprite.visible = YES;
}

-(void) handleLedOff{
    _lightSprite.visible = NO;
}

- (void)turnOn{    
    THLed * led = (THLed*) self.simulableObject;
    [led turnOn];
}

- (void)turnOff{    
    THLed * led = (THLed*) self.simulableObject;
    [led turnOff];
}

-(NSString*) description{
    return @"Led";
}

@end
