/*
THBuzzer.m
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

#import "THBuzzer.h"
#import "THToneGenerator.h"
#import "THElementPin.h"
#import "THPin.h"

@implementation THBuzzer


float const kBuzzerMaxFrequency = 20000;
float const kBuzzerMinFrequency = 20;

-(void) load{
        
    TFProperty * property1 = [TFProperty propertyWithName:@"frequency" andType:kDataTypeFloat];
    TFProperty * property2 = [TFProperty propertyWithName:@"on" andType:kDataTypeBoolean];
    self.properties = [NSMutableArray arrayWithObjects:property1, property2, nil];
    
    TFMethod * method1 =[TFMethod methodWithName:@"varyFrequency"];
    method1.numParams = 1;
    method1.firstParamType = kDataTypeFloat;
    
    TFMethod * method2 =[TFMethod methodWithName:@"setFrequency"];
    method2.numParams = 1;
    method2.firstParamType = kDataTypeFloat;
    
    TFMethod * method3 = [TFMethod methodWithName:@"turnOn"];
    TFMethod * method4 = [TFMethod methodWithName:@"turnOff"];
    self.methods = [NSMutableArray arrayWithObjects:method1,method2,method3,method4,nil];

    TFEvent * event0 = [TFEvent eventNamed:kEventOnChanged];
    event0.param1 = [TFPropertyInvocation invocationWithProperty:property2 target:self];
    TFEvent * event1 = [TFEvent eventNamed:@"frequencyChanged"];
    event1.param1 = [TFPropertyInvocation invocationWithProperty:property1 target:self];
    TFEvent * event2 = [TFEvent eventNamed:kEventTurnedOn];
    TFEvent * event3 = [TFEvent eventNamed:kEventTurnedOff];
    self.events = [NSMutableArray arrayWithObjects:event0,event1,event2,event3,nil];
}

-(void) loadPins{
    
    THElementPin * pin1 = [THElementPin pinWithType:kElementPintypeDigital];
    pin1.hardware = self;
    pin1.defaultBoardPinMode = kPinModePWM;
    THElementPin * pin2 = [THElementPin pinWithType:kElementPintypeMinus];
    pin2.hardware = self;
    
    [self.pins addObject:pin1];
    [self.pins addObject:pin2];
}

-(id) init{
    self = [super init];
    if(self){
        [self load];
        [self loadPins];
        
        self.frequency = 2500;
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    [self load];
    
    self.frequency = [decoder decodeFloatForKey:@"frequency"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeFloat:self.frequency forKey:@"frequency"];
}

-(id)copyWithZone:(NSZone *)zone
{
    THBuzzer * copy = [super copyWithZone:zone];
    
    copy.frequency = self.frequency;
    copy.on = self.on;
    
    return copy;
}

#pragma mark - Methods

-(THElementPin*) minusPin{
    return [self.pins objectAtIndex:1];
}

-(THElementPin*) digitalPin{
    return [self.pins objectAtIndex:0];
}

//[0 255] --> [20 20000]
-(float) pinToFrequency:(NSInteger) analogValue{
    return [THClientHelper LinearMapping:analogValue min:0 max:255 retMin:kBuzzerMinFrequency retMax:kBuzzerMaxFrequency];
}

-(NSInteger) frequencyToPin:(float) frequency{
    
    float newVal = [THClientHelper LinearMapping:frequency min:kBuzzerMinFrequency max:kBuzzerMaxFrequency retMin:0 retMax:255];
    
    return (NSInteger) (newVal + 0.5f);//round
}

-(void) handlePin:(THBoardPin*) pin changedValueTo:(NSInteger) newValue{
    
    if(newValue < 0){
        return;
    }
    if(pin.mode == kPinModeDigitalOutput){
        if(!self.on && newValue == kDigitalPinValueHigh){
            [self turnOn];
        } else if(self.on && newValue == kDigitalPinValueLow){
            [self turnOff];
        }
    } else if(pin.mode == kPinModePWM){
        self.frequency = [self pinToFrequency:newValue];
    }
}

-(void) updatePinValue{
    
    THElementPin * pin = self.digitalPin;
    THBoardPin * lilypadPin = (THBoardPin*) pin.attachedToPin;
    
    if(lilypadPin.mode == kPinModeDigitalOutput){
        
        [lilypadPin setValueWithoutNotifications:self.on];
        
    } else if(lilypadPin.mode == kPinModePWM){
        
        float newPinValue = [self frequencyToPin:self.frequency];
        [lilypadPin setValueWithoutNotifications:(self.on ? newPinValue : -1)];
    }
}

-(void) setOn:(BOOL)on{
    _on = on;
    [self triggerEventNamed:kEventOnChanged];
    [self updatePinValue];
}

- (void)turnOn{
    if(!self.on){
        self.on = YES;
        [self triggerEventNamed:kEventTurnedOn];
    }
}

- (void)turnOff{
    if(self.on){
        self.on = NO;
        [self triggerEventNamed:kEventTurnedOff];
    }
}

-(void) varyFrequency:(float) dt{
    self.frequency += dt;
}

-(void) setFrequency:(float)frequency{
    
    _frequency = frequency;
    
    [self triggerEventNamed:kEventFrequencyChanged];
    [self updatePinValue];
}

-(void) didStartSimulating{
    [self triggerEventNamed:kEventFrequencyChanged];
    [self triggerEventNamed:kEventOnChanged];
    [super didStartSimulating];
}

-(NSString*) description{
    return @"buzzer";
}

@end
