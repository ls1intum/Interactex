//
//  THThreeColorLedEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 1/7/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THThreeColorLedEditable.h"
#import "THThreeColorLed.h"
#import "THLedProperties.h"
#import "THElementPin.h"
#import "THPin.h"
#import "THPinEditable.h"
#import "THElementPinEditable.h"
#import "THThreeColorLedProperties.h"

@implementation THThreeColorLedEditable

@dynamic on;
@dynamic onAtStart;
@dynamic red;
@dynamic green;
@dynamic blue;

-(void) loadThreeColorLed{
    self.sprite = [CCSprite spriteWithFile:@"threeColorLed.png"];
    [self addChild:self.sprite];
    
    _lightSprite = [CCSprite spriteWithFile:@"light.png"];
    _lightSprite.visible = NO;
    _lightSprite.position = ccp(35,40);
    [self.sprite addChild:_lightSprite];
    
    self.acceptsConnections = YES;
    
    self.type = kHardwareTypeThreeColorLed;
}

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THThreeColorLed alloc] init];
        
        [self loadThreeColorLed];
        [self loadPins];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    [self loadThreeColorLed];
    [self adaptColorToLed];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder*) coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone*) zone {
    THThreeColorLedEditable * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THThreeColorLedProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(THElementPinEditable*) minusPin{
    return [self.pins objectAtIndex:0];
}

-(THElementPinEditable*) redPin{
    return [self.pins objectAtIndex:1];
}

-(THElementPinEditable*) greenPin{
    return [self.pins objectAtIndex:2];
}

-(THElementPinEditable*) bluePin{
    return [self.pins objectAtIndex:3];
}

-(void) updateToPinValue{
    
    THElementPinEditable * pine = [self.pins objectAtIndex:1];
    THElementPin * pin = (THElementPin*) pine.simulableObject;
    THBoardPin * lilypadPin = (THBoardPin*) pin.attachedToPin;
    
    THThreeColorLed * led = (THThreeColorLed*)self.simulableObject;
    led.red = lilypadPin.value;
}

-(void) update{
    
    if(self.on && !_lightSprite.visible){
        [self handleLedOn];
    } else if(!self.on && _lightSprite.visible){
        [self handleLedOff];
    }
    [self adaptColorToLed];
}

-(void) setOnAtStart:(BOOL)onAtStart{
    
    THThreeColorLed * led = (THThreeColorLed*)self.simulableObject;
    led.onAtStart = onAtStart;
}

-(BOOL) onAtStart{
    
    THThreeColorLed * led = (THThreeColorLed*)self.simulableObject;
    return led.onAtStart;
}

-(void) adaptColorToLed{
    
    THThreeColorLed * led = (THThreeColorLed*)self.simulableObject;
    _lightSprite.color = ccc3(led.red, led.green, led.blue);
}

-(BOOL) on{
    THThreeColorLed * led = (THThreeColorLed*) self.simulableObject;
    return led.on;
}

-(NSInteger) red{
    THThreeColorLed * led = (THThreeColorLed*) self.simulableObject;
    return led.red;
}

-(void) setRed:(NSInteger)red{
    
    THThreeColorLed * led = (THThreeColorLed*) self.simulableObject;
    led.red = red;
}

-(NSInteger) green{
    THThreeColorLed * led = (THThreeColorLed*) self.simulableObject;
    return led.green;
}

-(void) setGreen:(NSInteger)green{
    
    THThreeColorLed * led = (THThreeColorLed*) self.simulableObject;
    led.green = green;
}

-(NSInteger) blue{
    THThreeColorLed * led = (THThreeColorLed*) self.simulableObject;
    return led.blue;
}

-(void) setBlue:(NSInteger)blue{
    
    THThreeColorLed * led = (THThreeColorLed*) self.simulableObject;
    led.blue = blue;
}

-(void) handleLedOn{
    _lightSprite.visible = YES;
}

-(void) handleLedOff{
    _lightSprite.visible = NO;
}

- (void)turnOn{
    THThreeColorLed * led = (THThreeColorLed*) self.simulableObject;
    [led turnOn];
}

- (void)turnOff{
    THThreeColorLed * led = (THThreeColorLed*) self.simulableObject;
    [led turnOff];
}

-(NSString*) description{
    return @"Led";
}

@end
