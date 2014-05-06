//
//  THGestureComponentEditableObject.m
//  TangoHapps
//
//  Created by Timm Beckmann on 06.05.14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THGestureComponentEditableObject.h"
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
#import "THAutorouteProperties.h"
#import "THHardwareComponentProperties.h"

@implementation THGestureComponentEditableObject

@synthesize type = _type;
@synthesize pins = _pins;
@dynamic hardwareProblems;
@dynamic isInputObject;

-(void) loadObject{
    
    self.z = kGestureObjectZ;
    self.acceptsConnections = YES;
}

-(void) addPinChilds{
    
    for (THElementPinEditable * pin in self.pins) {
        [self addChild:pin];
    }
}

-(void) loadPins{
    int i = 0;
    THHardwareComponent * clotheObject = (THHardwareComponent*) self.simulableObject;
    for (THElementPin * pin in clotheObject.pins) {
        THElementPinEditable * pinEditable = [[THElementPinEditable alloc] init];
        pinEditable.simulableObject = pin;
        pinEditable.position = ccpAdd(ccp(self.contentSize.width/2.0f, self.contentSize.height/2.0f), kPinPositions[self.type][i]);
        pinEditable.position = ccpAdd(pinEditable.position, ccp(pinEditable.contentSize.width/2.0f, pinEditable.contentSize.height/2.0f));
        //NSLog(@"%f pos: %f %f",pinEditable.anchorPoint.x, pinEditable.position.x,pinEditable.position.y);
        [_pins addObject:pinEditable];
        
        i++;
    }
    
    [self addPinChilds];
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

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        _pins = [decoder decodeObjectForKey:@"pins"];
        _type = [decoder decodeIntegerForKey:@"type"];
        
        [self loadObject];
        [self addPinChilds];
        
        self.attachedToGesture = [decoder decodeObjectForKey:@"attachedToGesture"];
        _objectName = [decoder decodeObjectForKey:@"objectName"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:_pins forKey:@"pins"];
    [coder encodeInteger:_type forKey:@"type"];
    [coder encodeObject:self.attachedToGesture forKey:@"attachedToGesture"];
    [coder encodeObject:_objectName forKey:@"objectName"];
}

-(id)copyWithZone:(NSZone *)zone {
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
    [controllers addObject:[THHardwareComponentProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(void) updateNameLabel{
    CGSize const kEditableObjectNameLabelSize = {100,20};
    if(self.nameLabel){
        [self.nameLabel removeFromParentAndCleanup:YES];
    }
    self.nameLabel = [CCLabelTTF labelWithString:self.objectName dimensions:kEditableObjectNameLabelSize hAlignment:NSTextAlignmentCenter fontName:kSimulatorDefaultFont fontSize:9];
    self.nameLabel.position = ccp(self.contentSize.width/2,-20);
    [self addChild:self.nameLabel];
}

-(void) setObjectName:(NSString *)objectName{
    if(![self.objectName isEqualToString:objectName]){
        _objectName = objectName;
        
        [self updateNameLabel];
    }
}

-(void)handleBoardRemoved:(THBoardEditable *)board{
    for (THElementPinEditable * pin in self.pins) {
        if([board.pins containsObject:pin.attachedToPin]){
            [pin dettachFromPin];
        }
    }
}

-(void) setAttachedToGesture:(THGesture *)attachedToGesture{
    if(_attachedToGesture != attachedToGesture){

        _attachedToGesture = attachedToGesture;
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
    [project addGestureComponent:self];
}

-(void) removeFromWorld{
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project removeGestureComponent:self];
    [super removeFromWorld];
}

-(void) addConnectionFromElementPin:(THElementPinEditable*) elementPin toBoardPin:(THBoardPinEditable*) boardPin{
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    
    [boardPin attachPin:elementPin];
    [elementPin attachToPin:boardPin animated:NO];
    [project addWireFrom:elementPin to:boardPin];
}

-(void) autoroutePlusAndMinusPins{
    
    THElementPinEditable * plusPin = [self plusPin];
    if(!plusPin.attachedToPin){
        [self autoroutePin:plusPin];
    }
    
    THElementPinEditable * minusPin = [self minusPin];
    if(!minusPin.attachedToPin){
        [self autoroutePin:minusPin];
    }
}

-(void) autoroutePin:(THElementPinEditable*) pin{
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    if(project.boards.count == 1){
        
        THBoardEditable * board = [project.boards objectAtIndex:0];
        
        for (THBoardPinEditable * boardPin in board.pins) {
            if([pin acceptsConnectionsTo:boardPin]){
                [self addConnectionFromElementPin:pin toBoardPin:boardPin];
                return;
            }
        }
    }
}

-(void) autoroute{
    
    for (THElementPinEditable * pin in self.pins) {
        if(!pin.attachedToPin){
            [self autoroutePin:pin];
        }
    }
}

-(void) addToLayer:(TFLayer*) layer{
    [self updateNameLabel];
    
    
    [layer addEditableObject:self];
    
    [self autoroutePlusAndMinusPins];
    
    [super addToLayer:layer];
}

-(void) removeFromLayer:(TFLayer*) layer{
    [layer removeEditableObject:self];
    
    [super removeFromLayer:layer];
}

-(THElementPinEditable*) mainPin{
    return nil;
}

-(void) prepareToDie{
    
    for (THElementPinEditable * pin in _pins) {
        [pin prepareToDie];
    }
    
    _pins = nil;
    [super prepareToDie];
}

@end
