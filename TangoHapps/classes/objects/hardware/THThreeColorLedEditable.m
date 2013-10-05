/*
THThreeColorLedEditable.m
Interactex Designer

Created by Juan Haladjian on 05/10/2013.

Interactex Designer is a configuration tool to easily setup, simulate and connect e-Textile hardware with smartphone functionality. Interactex Client is an app to store and replay projects made with Interactex Designer.

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
The first version of the software was designed and implemented as part of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was founded by Telekom Innovation Laboratories Berlin. It has been extended with funding from EIT ICT, as part of the activity "Connected Textiles".

Interactex is built using the Tango framework developed by TU Munich.

In the Interactex software, we use the GHUnit (a test framework for iOS developed by Gabriel Handford) and cocos2D libraries (a framework for building 2D games and graphical applications developed by Zynga Inc.). 
www.cocos2d-iphone.org
github.com/gabriel/gh-unit

Interactex also implements the Firmata protocol. Its software serial library is based on the original Arduino Firmata library.
www.firmata.org

All hardware part graphics in Interactex Designer are reproduced with kind permission from Fritzing. Fritzing is an open-source hardware initiative to support designers, artists, researchers and hobbyists to work creatively with interactive electronics.
www.frizting.org


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

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
