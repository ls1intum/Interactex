/*
THLilypadEditable.m
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

#import "THLilyPadEditable.h"
#import "THPinEditable.h"
#import "THLilyPad.h"
#import "THBoardPinEditable.h"
#import "THLilypadProperties.h"
#import "THBoardProperties.h"
#import "THPowerSupplyEditable.h"

@implementation THLilyPadEditable
@synthesize pins = _pins;
@dynamic numberOfDigitalPins;
@dynamic numberOfAnalogPins;

CGPoint const kLilypadPowerSupplyPosition = {189,131};
float const kLilypadPowerSupplyOverlapRadius = 40;

-(void) loadLilypad{
    self.z = kLilypadZ;
    self.boardType = kBoardTypeLilypad;
}

-(void) addPins{
    for (THPinEditable * pin in _pins) {
        [self addChild:pin z:1];
    }
}

-(id) init{
    self = [super init];
    if(self){
        
        THLilyPad * lilyPad = [[THLilyPad alloc] init];
        self.simulableObject = lilyPad;
        
        [self loadLilypad];
        [self loadBoard];
        
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        
        [self loadLilypad];
        [self loadBoard];
        
        self.powerSupply = [decoder decodeObjectForKey:@"powerSupply"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.powerSupply forKey:@"powerSupply"];
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THLilypadProperties properties]];
    [controllers addObject:[THBoardProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(NSInteger) numberOfDigitalPins{
    THLilyPad * lilypad = (THLilyPad*) self.simulableObject;
    return lilypad.numberOfDigitalPins;
}

-(NSInteger) numberOfAnalogPins{
    THLilyPad * lilypad = (THLilyPad*) self.simulableObject;
    return lilypad.numberOfAnalogPins;
}

-(THBoardPinEditable*) digitalPinWithNumber:(NSInteger) number{
    
    THLilyPad * lilypad = (THLilyPad*) self.simulableObject;
    NSInteger idx = [lilypad pinIdxForPin:number ofType:kPintypeDigital];
    if(idx >= 0){
        return _pins[idx];
    }
    return nil;
}

-(void) setPowerSupply:(THPowerSupplyEditable*) powerSupply{
    
    if(powerSupply != _powerSupply){
        if(powerSupply){
            
            [_powerSupply removeFromParentAndCleanup:YES];
            _powerSupply = powerSupply;
            self.powerSupply.position = kLilypadPowerSupplyPosition;
            //self.powerSupply.rotation = CC_DEGREES_TO_RADIANS(90);
            _powerSupply.canBeMoved = NO;
            
            [self addChild:_powerSupply z:2];
            
        } else {
            
            [_powerSupply removeFromParentAndCleanup:YES];
            _powerSupply = nil;
        }
    }
}

#pragma mark - Pins

-(THBoardPinEditable*) minusPin{
    return [self.pins objectAtIndex:5];
}

-(THBoardPinEditable*) plusPin{
    return [self.pins objectAtIndex:6];
}

-(THBoardPinEditable*) sclPin{
    return [self analogPinWithNumber:5];
}

-(THBoardPinEditable*) sdaPin{
    return [self analogPinWithNumber:4];
}

-(THBoardPinEditable*) analogPinWithNumber:(NSInteger) number{
    THLilyPad * lilypad = (THLilyPad*) self.simulableObject;
    NSInteger idx = [lilypad pinIdxForPin:number ofType:kPintypeAnalog];
    if(idx >= 0){
        return _pins[idx];
    }
    return nil;
}

-(BOOL) acceptsPowerSupplyAtLocation:(CGPoint) location{
    
    //    CGPoint position = [self convertToNodeSpace:object.position];
    
    location = [self convertToNodeSpace:location];
    if(ccpDistance(location, kLilypadPowerSupplyPosition) < kLilypadPowerSupplyOverlapRadius){
        return YES;
    }
    
    return NO;
}

#pragma mark - Lifecycle

-(void) willStartSimulation{
    [super willStartSimulation];
}

-(NSString*) description{
    return @"Lilypad";
}

@end
