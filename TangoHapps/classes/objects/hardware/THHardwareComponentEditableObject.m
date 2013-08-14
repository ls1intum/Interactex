//
//  THClotheObjectEditableObject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/19/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THHardwareComponentEditableObject.h"
#import "THHardwareComponent.h"
#import "THClotheObjectProperties.h"
#import "THElementPinEditable.h"
#import "THElementPin.h"
#import "THHardwareProblem.h"
#import "THResistorExtension.h"
#import "THCustomEditor.h"
#import "THLilypadEditable.h"
#import "THBoardPinEditable.h"
#import "THWire.h"

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
    
    self.pinned = [decoder decodeBoolForKey:@"pinned"];

    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:_pins forKey:@"pins"];
    [coder encodeInteger:_type forKey:@"type"];
    [coder encodeBool:_pinned forKey:@"pinned"];
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

-(void) setPinned:(BOOL)pinned{
    if(_pinned != pinned){
        _sewedSprite.visible = pinned;
        _pinned = pinned;
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

-(void) drawPinWires{
    
    for (THElementPinEditable * pin in self.pins) {
        [TFHelper drawWires:pin.wires];
    }
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
    THCustomProject * project = (THCustomProject*) [TFDirector sharedDirector].currentProject;
    [project addClotheObject:self];
}

-(void) removeFromWorld{
    THCustomProject * project = (THCustomProject*) [TFDirector sharedDirector].currentProject;
    [project removeClotheObject:self];
    [super removeFromWorld];
}

-(void) addToLayer:(TFLayer*) layer{
    [layer addEditableObject:self];
    
    THCustomProject * project = (THCustomProject*) [TFDirector sharedDirector].currentProject;
    THLilyPadEditable * lilypad = project.lilypad;
    
    THElementPinEditable * plusPin = [self plusPin];
    if(plusPin && !plusPin.attachedToPin){
        [lilypad.plusPin attachPin:plusPin];
        [plusPin attachToPin:lilypad.plusPin animated:NO];
    }
    
    THElementPinEditable * minusPin = [self minusPin];
    if(minusPin && !minusPin.attachedToPin){
        [lilypad.minusPin attachPin:minusPin];
        [minusPin attachToPin:lilypad.minusPin animated:NO];
    }
}

-(void) removeFromLayer:(TFLayer*) layer{
    [layer removeEditableObject:self];
}

-(void) prepareToDie{
    
    self.attachedToClothe = nil;
    
    for (THElementPinEditable * pin in _pins) {
        [pin prepareToDie];
    }
    
    _pins = nil;
    [super prepareToDie];
}


@end
