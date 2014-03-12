/*
THThreeColorLed.m
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

Martijn ten Bhömer from TU Eindhoven contributed PureData support. Contact: m.t.bhomer@tue.nl.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

#import "THThreeColorLed.h"
#import "THElementPin.h"

@implementation THThreeColorLed

@synthesize on = _on;
@dynamic redPin;
@dynamic greenPin;
@dynamic bluePin;
@dynamic minusPin;

-(void) loadThreeColorLed{
    
    TFProperty * property1 = [TFProperty propertyWithName:@"on" andType:kDataTypeBoolean];
    TFProperty * property2 = [TFProperty propertyWithName:@"red" andType:kDataTypeInteger];
    TFProperty * property3 = [TFProperty propertyWithName:@"green" andType:kDataTypeInteger];
    TFProperty * property4 = [TFProperty propertyWithName:@"blue" andType:kDataTypeInteger];
    self.properties = [NSMutableArray arrayWithObjects:property1,property2,property3, property4, nil];
    
    TFMethod * method1 = [TFMethod methodWithName:kMethodTurnOn];
    TFMethod * method2 = [TFMethod methodWithName:kMethodTurnOff];
    
    
    TFMethod * method3 = [TFMethod methodWithName:kMethodSetRed];
    method3.numParams = 1;
    method3.firstParamType = kDataTypeInteger;
    
    TFMethod * method4 = [TFMethod methodWithName:kMethodSetGreen];
    method4.numParams = 1;
    method4.firstParamType = kDataTypeInteger;
    
    TFMethod * method5 = [TFMethod methodWithName:kMethodSetBlue];
    method5.numParams = 1;
    method5.firstParamType = kDataTypeInteger;
    
    self.methods = [NSMutableArray arrayWithObjects:method1, method2, method3, method4, method5,nil];
    
    TFEvent * event1 = [TFEvent eventNamed:kEventColorChanged];
    TFEvent * event2 = [TFEvent eventNamed:kEventTurnedOn];
    TFEvent * event3 = [TFEvent eventNamed:kEventTurnedOff];
    self.events = [NSMutableArray arrayWithObjects:event1,event2,event3,nil];
}

-(void) loadPins{
    
    THElementPin * minusPin = [THElementPin pinWithType:kElementPintypeMinus];
    minusPin.hardware = self;
    
    THElementPin * redPin = [THElementPin pinWithType:kElementPintypeDigital];
    redPin.hardware = self;
    redPin.defaultBoardPinMode = kPinModePWM;
    
    THElementPin * greenPin = [THElementPin pinWithType:kElementPintypeDigital];
    greenPin.hardware = self;
    greenPin.defaultBoardPinMode = kPinModePWM;
    
    THElementPin * bluePin = [THElementPin pinWithType:kElementPintypeDigital];
    bluePin.hardware = self;
    bluePin.defaultBoardPinMode = kPinModePWM;
    
    [self.pins addObject:minusPin];
    [self.pins addObject:redPin];
    [self.pins addObject:greenPin];
    [self.pins addObject:bluePin];
}

-(id) init{
    self = [super init];
    if(self){
        [self loadThreeColorLed];
        [self loadPins];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder{
    self = [super initWithCoder:decoder];
    self.onAtStart = [decoder decodeBoolForKey:@"onAtStart"];
    self.red = [decoder decodeIntegerForKey:@"red"];
    self.green = [decoder decodeIntegerForKey:@"green"];
    self.blue = [decoder decodeIntegerForKey:@"blue"];
    
    [self loadThreeColorLed];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    [super encodeWithCoder:coder];
    [coder encodeBool:self.onAtStart forKey:@"onAtStart"];
    [coder encodeInteger:self.red forKey:@"red"];
    [coder encodeInteger:self.green forKey:@"green"];
    [coder encodeInteger:self.blue forKey:@"blue"];
}

-(id)copyWithZone:(NSZone *)zone{
    THThreeColorLed * copy = [super copyWithZone:zone];
    
    copy.on = self.on;
    copy.onAtStart = self.onAtStart;
    copy.red = self.red;
    copy.green = self.green;
    copy.blue = self.blue;
    
    return copy;
}

#pragma mark - Methods

-(THElementPin*) minusPin{
    return [self.pins objectAtIndex:0];
}

-(THElementPin*) redPin{
    return [self.pins objectAtIndex:1];
}

-(THElementPin*) greenPin{
    return [self.pins objectAtIndex:2];
}

-(THElementPin*) bluePin{
    return [self.pins objectAtIndex:3];
}

-(void) handlePin:(THBoardPin*) pin changedValueTo:(NSInteger) newValue{
    //NSLog(@"pin changed: %d",newValue);
    
    if(pin == self.redPin.attachedToPin){
        self.red = 255 - newValue;
    } else if(pin == self.greenPin.attachedToPin){
        self.green = 255 - newValue;
    } else if(pin ==  self.bluePin.attachedToPin){
        self.blue = 255 - newValue;
    }
}

-(void) updatePinValue {
    if(self.on){
        self.redPin.attachedToPin.value = 255 - self.red;
        self.greenPin.attachedToPin.value = 255 - self.green;
        self.bluePin.attachedToPin.value = 255 - self.blue;
    } else {
        
        self.redPin.attachedToPin.value = 255 - self.red;
        self.greenPin.attachedToPin.value = 255 - self.green;
        self.bluePin.attachedToPin.value = 255 - self.blue;
    }
}

- (void)turnOn {
    if(!self.on){

        self.on = YES;
        _red = 255;
        _green = 255;
        _blue = 255;
        
        [self triggerEventNamed:kEventTurnedOn];
        [self updatePinValue];
    }
}

- (void)turnOff {
    if(self.on){

        self.on = NO;
        
        [self triggerEventNamed:kEventTurnedOff];
        [self updatePinValue];
    }
}

-(NSInteger) clampColor:(NSInteger) color {
    if(color > kMaxAnalogValue){
        color = kMaxAnalogValue;
    } else if(color < 0){
        color = 0;
    }
    return color;
}

-(void) varyIntensity:(NSInteger) di {
    self.red = self.red + di;
    [self updatePinValue];
}

-(void) setRed:(NSInteger)red {
    
    _red = [self clampColor:red];
    [self triggerEventNamed:kEventColorChanged];
}

-(void) setGreen:(NSInteger)green {
    
    _green = [self clampColor:green];
    [self triggerEventNamed:kEventColorChanged];
}

-(void) setBlue:(NSInteger)blue {
    
    _blue = [self clampColor:blue];
    [self triggerEventNamed:kEventColorChanged];
}

-(void) didStartSimulating{
    
    [self triggerEventNamed:kEventIntensityChanged];
    
    THElementPin * pin = [self.pins objectAtIndex:1];
    THBoardPin * lilypadPin = (THBoardPin*) pin.attachedToPin;
    if(lilypadPin.mode == kPinModePWM || self.onAtStart){
        [self turnOn];
    }
    
    [super didStartSimulating];
}

-(NSString*) description{
    return @"rgbLed";
}

@end
