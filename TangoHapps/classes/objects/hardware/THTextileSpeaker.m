/*
 THTextileSpeaker.m
 Interactex Designer
 
 Created by Juan Haladjian on 04/16/2016.
 
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

#import "THTextileSpeaker.h"
#import "THElementPin.h"

@implementation THTextileSpeaker


-(void) loadVibrationBoard{
    
    TFProperty * property1 = [TFProperty propertyWithName:@"on" andType:kDataTypeBoolean];
    self.properties = [NSMutableArray arrayWithObjects:property1,nil];
    
    TFMethod * method1 =[TFMethod methodWithName:@"turnOn"];
    TFMethod * method2 =[TFMethod methodWithName:@"turnOff"];
    TFMethod * method3 =[TFMethod methodWithName:@"playSong"];
    method3.numParams = 1;
    method3.firstParamType = kDataTypeInteger;
    TFMethod * method4 =[TFMethod methodWithName:@"setVolume"];
    method4.numParams = 1;
    method4.firstParamType = kDataTypeFloat;
    TFMethod * method5 =[TFMethod methodWithName:@"setSender"];
    method5.numParams = 1;
    method5.firstParamType = kDataTypeBoolean;
    TFMethod * method6 =[TFMethod methodWithName:@"setOn"];
    method6.numParams = 1;
    method6.firstParamType = kDataTypeBoolean;
    TFMethod * method7 =[TFMethod methodWithName:@"setFrequency"];
    method7.numParams = 1;
    method7.firstParamType = kDataTypeFloat;
    
    self.methods = [NSMutableArray arrayWithObjects:method1,method2,method3,method4,method5,method6,nil];
    
    TFEvent * event1 = [TFEvent eventNamed:kEventTurnedOn];
    TFEvent * event2 = [TFEvent eventNamed:kEventTurnedOff];
    self.events = [NSMutableArray arrayWithObjects:event1,event2,nil];
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
        [self loadVibrationBoard];
        [self loadPins];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder{
    self = [super initWithCoder:decoder];
    
    self.onAtStart = [decoder decodeBoolForKey:@"onAtStart"];
    
    [self loadVibrationBoard];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    [super encodeWithCoder:coder];
    
    [coder encodeBool:self.onAtStart forKey:@"onAtStart"];
}

-(id)copyWithZone:(NSZone *)zone{
    THTextileSpeaker * copy = [super copyWithZone:zone];
    
    copy.on = self.on;
    copy.onAtStart = self.onAtStart;
    
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
    
    if(pin.mode == kPinModeDigitalOutput){
        if(!self.on && newValue == kDigitalPinValueHigh){
            [self turnOn];
        } else if(self.on && newValue == kDigitalPinValueLow){
            [self turnOff];
        }
    } else {
        self.sound = newValue;
    }
}

-(void) updatePinValue {
    
    THElementPin * pin = [self.pins objectAtIndex:1];
    THBoardPin * lilypadPin = (THBoardPin*) pin.attachedToPin;
    
    if(lilypadPin.mode == kPinModeDigitalOutput){
        [lilypadPin setValueWithoutNotifications:self.on];
    } else {
        [lilypadPin setValueWithoutNotifications:self.sound];
    }
}

-(void) setOn:(BOOL)on{
    _on = on;
    [self triggerEventNamed:kEventOnChanged];
    [self updatePinValue];
}

- (void)turnOn {
    if(!self.on){
        self.on = YES;
        
        [self triggerEventNamed:kEventTurnedOn];
    }
}

- (void)turnOff {
    if(self.on){
        self.on = NO;
        
        [self triggerEventNamed:kEventTurnedOff];
    }
}

-(void) setSound:(NSInteger)sound {
    
    _sound = sound;
    
    [self updatePinValue];
}

-(void) playSong:(NSInteger)sound{
    self.sound = sound;
}

-(void) setVolume:(float) volume{
    _volume = volume;
}

-(void) setFrequency:(float) frequency{
    _frequency = frequency;
}

-(void) setSender:(BOOL) sender{//0 = AM, 1= FM
    _sender = sender;
}

-(void) didStartSimulating{
    
    [self triggerEventNamed:kEventFrequencyChanged];
    
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
    return @"textile Speaker";
}

@end
