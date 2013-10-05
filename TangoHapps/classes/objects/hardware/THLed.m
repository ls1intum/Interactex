/*
THLed.m
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

#import "THLed.h"
#import "THElementPin.h"

@implementation THLed

@synthesize on = _on;
@dynamic digitalPin;
@dynamic minusPin;

-(void) loadLed{
    
    TFProperty * property1 = [TFProperty propertyWithName:@"on" andType:kDataTypeBoolean];
    TFProperty * property2 = [TFProperty propertyWithName:@"intensity" andType:kDataTypeInteger];
    self.properties = [NSMutableArray arrayWithObjects:property1,property2,nil];
    
    TFMethod * method1 =[TFMethod methodWithName:@"varyIntensity"];
    method1.numParams = 1;
    method1.firstParamType = kDataTypeInteger;
    
    TFMethod * method2 =[TFMethod methodWithName:@"setIntensity"];
    method2.numParams = 1;
    method2.firstParamType = kDataTypeInteger;
    
    TFMethod * method3 = [TFMethod methodWithName:kMethodTurnOn];
    TFMethod * method4 = [TFMethod methodWithName:kMethodTurnOff];
    self.methods = [NSMutableArray arrayWithObjects:method1,method2,method3,method4,nil];
    
    TFEvent * event0 = [TFEvent eventNamed:kEventOnChanged];
    event0.param1 = [TFPropertyInvocation invocationWithProperty:property1 target:self];
    TFEvent * event1 = [TFEvent eventNamed:kEventIntensityChanged];
    event1.param1 = [TFPropertyInvocation invocationWithProperty:property2 target:self];
    TFEvent * event2 = [TFEvent eventNamed:kEventTurnedOn];
    TFEvent * event3 = [TFEvent eventNamed:kEventTurnedOff];
    self.events = [NSMutableArray arrayWithObjects:event0,event1,event2,event3,nil];
}

-(void) loadPins{
    
    THElementPin * pin1 = [THElementPin pinWithType:kElementPintypeMinus];
    pin1.hardware = self;
    THElementPin * pin2 = [THElementPin pinWithType:kElementPintypeDigital];
    pin2.hardware = self;
    pin2.defaultBoardPinMode = kPinModeDigitalOutput;
    [self.pins addObject:pin1];
    [self.pins addObject:pin2];
}

-(id) init{
    self = [super init];
    if(self){
        [self loadLed];
        [self loadPins];
        self.intensity = 255;
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder{
    self = [super initWithCoder:decoder];
    self.onAtStart = [decoder decodeBoolForKey:@"onAtStart"];
    self.intensity = [decoder decodeIntegerForKey:@"intensity"];
    
    [self loadLed];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    [super encodeWithCoder:coder];
    [coder encodeBool:self.onAtStart forKey:@"onAtStart"];
    [coder encodeInteger:self.intensity forKey:@"intensity"];
}

-(id)copyWithZone:(NSZone *)zone{
    THLed * copy = [super copyWithZone:zone];
    
    copy.on = self.on;
    copy.onAtStart = self.onAtStart;
    copy.intensity = self.intensity;
    
    return copy;
}

#pragma mark - Methods

-(THElementPin*) minusPin{
    return [self.pins objectAtIndex:0];
}

-(THElementPin*) digitalPin{
    return [self.pins objectAtIndex:1];
}

-(void) handlePin:(THBoardPin*) pin changedValueTo:(NSInteger) newValue{
    //NSLog(@"pin changed: %d",newValue);
    
    if(pin.mode == kPinModeDigitalOutput){
        if(!self.on && newValue == kDigitalPinValueHigh){
            [self turnOn];
        } else if(self.on && newValue == kDigitalPinValueLow){
            [self turnOff];
        }
    } else {
        self.intensity = newValue;
    }
}

-(void) updatePinValue {

    THElementPin * pin = [self.pins objectAtIndex:1];
    THBoardPin * lilypadPin = (THBoardPin*) pin.attachedToPin;
    
    if(lilypadPin.mode == kPinModeDigitalOutput){
        lilypadPin.value = self.on;
    } else {
        if(self.on){
            lilypadPin.value = self.intensity;
        } else {
            lilypadPin.value = 0;
        }
    }
    //NSLog(@"lilypin: %@",lilypadPin);
}

-(void) setOn:(BOOL)on{
    _on = on;
    [self triggerEventNamed:kEventOnChanged];
    [self updatePinValue];
}

- (void)turnOn {
    if(!self.on){
        NSLog(@"led on");
        self.on = YES;
        
        [self triggerEventNamed:kEventTurnedOn];
    }
}

- (void)turnOff {
    if(self.on){
        NSLog(@"led off");
        self.on = NO;
        
        [self triggerEventNamed:kEventTurnedOff];
    }
}

-(void) clampIntensity {
    if(_intensity > kMaxAnalogValue){
        _intensity = kMaxAnalogValue;
    } else if(_intensity < 0){
        _intensity = 0;
    }
}

-(void) varyIntensity:(NSInteger) di {
    self.intensity = self.intensity + di;
}

-(void) setIntensity:(NSInteger)intensity {
    
    _intensity = intensity;
    [self clampIntensity];
    [self triggerEventNamed:kEventIntensityChanged];
    [self updatePinValue];
}

-(void) didStartSimulating{
    
    [self triggerEventNamed:kEventIntensityChanged];
    
    THElementPin * pin = [self.pins objectAtIndex:1];
    THBoardPin * lilypadPin = (THBoardPin*) pin.attachedToPin;    
    if(lilypadPin.mode == kPinModePWM || self.onAtStart){
        [self turnOn];
    } else {
        [self triggerEventNamed:kEventOnChanged];
    }

    [super didStartSimulating];
}

-(NSString*) description{
    return @"led";
}

@end
