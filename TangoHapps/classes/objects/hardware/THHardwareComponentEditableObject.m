/*
THHardwareComponentEditableObject.m
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

#import "THHardwareComponentEditableObject.h"
#import "THHardwareComponent.h"
#import "THClotheObjectProperties.h"
#import "THElementPinEditable.h"
#import "THElementPin.h"
#import "THHardwareProblem.h"
#import "THEditor.h"
#import "THLilypadEditable.h"
#import "THBoardPinEditable.h"
#import "THWire.h"
#import "THEditor.h"

@implementation THHardwareComponentEditableObject

@synthesize type = _type;
@synthesize pins = _pins;
@dynamic hardwareProblems;
@dynamic isInputObject;

-(void) loadObject{
    
    self.z = kClotheObjectZ;
    self.acceptsConnections = YES;
    
}

-(void) addPinChilds{
    
    for (THElementPinEditable * pin in self.pins) {
        [self addChild:pin];
    }
}

-(void) loadSewedSprite{
    
    _sewedSprite = [CCSprite spriteWithFile:@"sewed.png"];
    _sewedSprite.rotation = 45;
    _sewedSprite.position = kSewedPositions[self.type];
    _sewedSprite.visible = NO;
    
    [self addChild:_sewedSprite z:5];
}

-(void) loadPins{
    int i = 0;
    THHardwareComponent * clotheObject = (THHardwareComponent*) self.simulableObject;
    for (THElementPin * pin in clotheObject.pins) {
        THElementPinEditable * pinEditable = [[THElementPinEditable alloc] init];
        pinEditable.simulableObject = pin;
        pinEditable.hardware = self;
        pinEditable.position = ccpAdd(ccp(self.contentSize.width/2.0f, self.contentSize.height/2.0f), kPinPositions[self.type][i]);
        pinEditable.position = ccpAdd(pinEditable.position, ccp(pinEditable.contentSize.width/2.0f, pinEditable.contentSize.height/2.0f));
        //NSLog(@"%f pos: %f %f",pinEditable.anchorPoint.x, pinEditable.position.x,pinEditable.position.y);
        [_pins addObject:pinEditable];
        
        i++;
    }
    
    [self addPinChilds];
    [self loadSewedSprite];
}

-(id) init{
    
    self = [super init];
    if(self){
        _pins = [NSMutableArray array];

        [self loadObject];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    _pins = [decoder decodeObjectForKey:@"pins"];
    _type = [decoder decodeIntegerForKey:@"type"];
    
    [self loadObject];
    [self addPinChilds];
    [self loadSewedSprite];
    _attachedToClothe = [decoder decodeObjectForKey:@"attachedToClothe"];

    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:_pins forKey:@"pins"];
    [coder encodeInteger:_type forKey:@"type"];
    [coder encodeObject:self.attachedToClothe forKey:@"attachedToClothe"];
}

-(id)copyWithZone:(NSZone *)zone
{
    THHardwareComponentEditableObject * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Property Controllers

-(NSArray*) hardwareProblems{
    NSMutableArray * problems = [NSMutableArray array];
    for (THElementPinEditable * pin in self.pins) {
        if(!pin.attachedToPin){
            THHardwareProblem * problem = [[THHardwareProblemNotConnected alloc] init];
            problem.pin = pin;
            [problems addObject:problem];
        }
    }
    return problems;
}

-(NSArray*)propertyControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THClotheObjectProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(void) setAttachedToClothe:(THClothe *)attachedToClothe{
    if(_attachedToClothe != attachedToClothe){
        if(attachedToClothe){
            
            _sewedSprite.visible = YES;
        } else {
            _sewedSprite.visible = NO;
        }
        _attachedToClothe = attachedToClothe;
    }
}

-(void) setIsInputObject:(BOOL)isInputObject{
    
    THHardwareComponent * object = (THHardwareComponent*) self.simulableObject;
    object.isInputObject = isInputObject;
}

-(BOOL) isInputObject{
    THHardwareComponent * object = (THHardwareComponent*) self.simulableObject;
    return object.isInputObject;
}

-(THElementPinEditable*) pinAtPosition:(CGPoint) position{
    
    for (THElementPinEditable * pin in _pins) {
        if(ccpDistance(pin.center, position) < kLilypadPinRadius){
            return pin;
        }
    }
    
    return nil;
}

-(void) updateToPinValue{
}

-(CGPoint) absolutePosition{
    if(self.parent == nil) return self.position;
    CGPoint pos = [self convertToWorldSpace:ccp(0,0)];
    return pos;
}

-(NSString*) description{
    return @"Clothe Object";
}

-(THElementPinEditable*) plusPin{
    for (THElementPinEditable * pin in _pins) {
        if(pin.type == kElementPintypePlus){
            return pin;
        }
    }
    return nil;
}

-(THElementPinEditable*) minusPin{
    for (THElementPinEditable * pin in _pins) {
        if(pin.type == kElementPintypeMinus){
            return pin;
        }
    }
    return nil;
}

-(void) addToWorld{
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addClotheObject:self];
}

-(void) removeFromWorld{
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project removeClotheObject:self];
    [super removeFromWorld];
}

-(void) addToLayer:(TFLayer*) layer{
    [layer addEditableObject:self];
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    THLilyPadEditable * lilypad = project.lilypad;
    
    THElementPinEditable * plusPin = [self plusPin];
    if(plusPin && !plusPin.attachedToPin){
        [lilypad.plusPin attachPin:plusPin];
        [plusPin attachToPin:lilypad.plusPin animated:NO];
        [project addWireFrom:plusPin to:lilypad.plusPin];
    }
    
    THElementPinEditable * minusPin = [self minusPin];
    if(minusPin && !minusPin.attachedToPin){
        [lilypad.minusPin attachPin:minusPin];
        [minusPin attachToPin:lilypad.minusPin animated:NO];
        [project addWireFrom:minusPin to:lilypad.minusPin];
    }
}

-(void) removeFromLayer:(TFLayer*) layer{
    [layer removeEditableObject:self];
}

-(void) prepareToDie{
    
    for (THElementPinEditable * pin in _pins) {
        [pin prepareToDie];
    }
    
    _pins = nil;
    [super prepareToDie];
}


@end
