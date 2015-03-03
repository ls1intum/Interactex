/*
THBuzzerEditableObject.m
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

#import "THBuzzerEditableObject.h"
#import "THBuzzerProperties.h"
#import "THToneGenerator.h"
#import "THBuzzer.h"
#import "THPin.h"
#import "THElementPin.h"
#import "THElementPinEditable.h"

@implementation THBuzzerEditableObject
@synthesize on = _on;
@dynamic frequency;

-(id) init{
    self = [super init];
    if(self){
        
        self.simulableObject = [[THBuzzer alloc] init];
        
        [self loadBuzzer];
        [super loadPins];
    }
    return self;
}

-(void) loadBuzzer{
    
    self.type = kHardwareTypeBuzzer;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        [self loadBuzzer];
        
        self.onAtStart = [decoder decodeBoolForKey:@"onAtStart"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeBool:self.onAtStart forKey:@"onAtStart"];
}

-(id)copyWithZone:(NSZone *)zone {
    THBuzzerEditableObject * copy = [super copyWithZone:zone];
    
    copy.onAtStart = self.onAtStart;
    copy.on = self.on;
    copy.frequency = self.frequency;
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THBuzzerProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(THElementPinEditable*) minusPin{
    return [self.pins objectAtIndex:1];
}

-(THElementPinEditable*) digitalPin{
    return [self.pins objectAtIndex:0];
}

-(float) frequency{
    THBuzzer * buzzer = (THBuzzer*)self.simulableObject;
    return buzzer.frequency;
}

-(void) setFrequency:(float)frequency{
    
    THBuzzer * buzzer = (THBuzzer*)self.simulableObject;
    buzzer.frequency = frequency;
}

-(void) varyFrequency:(float) dt{
    THBuzzer * buzzer = (THBuzzer*)self.simulableObject;
    [buzzer varyFrequency:dt];
}

-(void) updateToPinValue{
    
    THElementPinEditable * pine = [self.pins objectAtIndex:0];
    THElementPin * pin = (THElementPin*) pine.simulableObject;
    THBoardPin * lilypadPin = (THBoardPin*) pin.attachedToPin;
    
    if(lilypadPin.type == kPintypeDigital){
        if(lilypadPin.value == kDigitalPinValueHigh && !self.on){
            [self turnOn];
        } else if(lilypadPin.value == kDigitalPinValueLow && self.on){
            [self turnOff];
        }
    } else if(lilypadPin.type == kPintypeAnalog){
        THBuzzer * buzzer = (THBuzzer*)self.simulableObject;
        buzzer.frequency = lilypadPin.value;
    }
}

-(void) update{
    THBuzzer * buzzer = (THBuzzer*) self.simulableObject;
    
    if(buzzer.on && !self.on){
        [self handleBuzzerOn];
    } else if(!buzzer.on &&self.on){
        [self handleBuzzerOff];
    }
    [self adaptFrequencyToBuzzer];
}

-(void) adaptFrequencyToBuzzer{
    THBuzzer * buzzer = (THBuzzer*)self.simulableObject;
    toneGenerator.frequency = buzzer.frequency;
}

-(CCAction*) shakeAction{
    CGPoint displ = ccp(1,1);
    CGPoint pos1 = ccpAdd(self.position, displ);
    CGPoint pos2 = ccpSub(self.position, displ);
    float moveTime = 0.05f;
    
    CCMoveTo * move1 = [CCMoveTo actionWithDuration:moveTime position: pos1];
    CCMoveTo * move2 = [CCMoveTo actionWithDuration:moveTime position: pos2];
    
    CCSequence * shake = [CCSequence actions:move1,move2, nil];
    return [CCRepeatForever actionWithAction:shake];
}

-(void) shake{
    shakeAction = [self shakeAction];
    [self runAction:shakeAction];
}

-(void) stopShaking{
    [self stopAction:shakeAction];
}

-(void) playSound{
    if(!toneGenerator){
        toneGenerator = [[THToneGenerator alloc] init];
    }
    
    THBuzzer * buzzer = (THBuzzer*)self.simulableObject;
    toneGenerator.frequency = buzzer.frequency;
    
    [toneGenerator play];
}

-(void) stopPlayingSound{
    [toneGenerator stop];
}

-(void) handleBuzzerOn{
    [self shake];
    [self playSound];
    self.on = YES;
}

-(void) handleBuzzerOff{
    [self stopShaking];
    [self stopPlayingSound];
    self.on = NO;
}

- (void)turnOn{
    if(!self.on){
        THBuzzer * buzzer = (THBuzzer*) self.simulableObject;
        [buzzer turnOn];
    }
}

- (void)turnOff{
    if(self.on){
        THBuzzer * buzzer = (THBuzzer*) self.simulableObject;
        [buzzer turnOff];
    }
}

-(void) willStartSimulation{
    [toneGenerator stop];
    
    if(self.onAtStart){
        [self turnOn];
    }
    
    [super willStartSimulation];
}

-(void) addToLayer:(TFLayer *)layer{
    
    [super addToLayer:layer];
}

-(void) prepareToDie{
    toneGenerator = nil;
    [super prepareToDie];
}

-(NSString*) description{
    return @"Buzzer";
}

@end
