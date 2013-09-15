//
//  THInvocationConnectionLine.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THInvocationConnectionLine.h"
#import "TFConnectionLine.h"
#import "THCustomEditor.h"
#import "THInvocationConnectionProperties.h"

@implementation THInvocationConnectionLine

NSString * const invocationConnectionLineSpriteNames[THInvocationConnectionLineNumStates][kNumDataTypes] = {
    {@"circleEmpty", @"squareEmpty", @"squareEmpty", @"triangleEmpty", @"starEmpty"},
    {@"circleFilled", @"squareFilled", @"squareFilled", @"triangleFilled", @"starFilled"}};


#pragma mark - Initialization

-(id) initWithObj1:(TFEditableObject*) obj1 obj2:(TFEditableObject*) obj2{
    self = [super init];
    if(self){
        self.connectionLine = [[TFConnectionLine alloc] initWithObj1:obj1 obj2:obj2];

        [self loadConnectionLine];

    }
    return self;
}

-(id) init{
    self = [super init];
    if(self){
        self.connectionLine = [[TFConnectionLine alloc] init];
        
        [self loadConnectionLine];
    }
    return self;
}

-(void) loadConnectionLine{
    self.zoomable = NO;
    [self reloadSprite];
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        self.connectionLine = [decoder decodeObjectForKey:@"connectionLine"];
        self.numParameters = [decoder decodeIntegerForKey:@"numParameters"];
        self.state = [decoder decodeIntegerForKey:@"state"];
        self.parameterType = [decoder decodeIntegerForKey:@"parameterType"];
        self.action = [decoder decodeObjectForKey:@"action"];
        
        [self loadConnectionLine];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.connectionLine forKey:@"connectionLine"];
    [coder encodeInteger:self.numParameters forKey:@"numParameters"];
    [coder encodeInteger:self.state forKey:@"state"];
    [coder encodeInteger:self.parameterType forKey:@"parameterType"];
    [coder encodeObject:self.action forKey:@"action"];
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THInvocationConnectionProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(CGPoint) calculateLineCenter{
    CGPoint pos1 = self.obj1.absolutePosition;
    CGPoint pos2 = self.obj2.absolutePosition;
    return ccpMult(ccpAdd(pos1,pos2),0.5f);
}

-(void) reloadSprite{
    if(self.numParameters == 1){
        
        [_invocationStateSprite removeFromParentAndCleanup:YES];
        NSString * spriteName = invocationConnectionLineSpriteNames[self.state][self.parameterType];
        spriteName = [spriteName stringByAppendingString:@".png"];
        _invocationStateSprite = [CCSprite spriteWithFile:spriteName];
        _invocationStateSprite.position = [self calculateLineCenter];
        [self addChild:_invocationStateSprite];
    }
}

-(void) setObj1:(TFEditableObject *)obj1{
        
    self.connectionLine.obj1 = obj1;
}

-(void) setObj2:(TFEditableObject *)obj2{
    
    self.connectionLine.obj2 = obj2;
}

-(TFEditableObject*) obj1{
    return self.connectionLine.obj1;
}

-(TFEditableObject*) obj2{
    return self.connectionLine.obj2;
}

-(void) setShouldAnimate:(BOOL)shouldAnimate{
    
    self.connectionLine.shouldAnimate = shouldAnimate;
}

-(BOOL) shouldAnimate{
    return self.connectionLine.shouldAnimate;
}

-(void) startShining{
    [self.connectionLine startShining];
}

-(void) draw{
    _invocationStateSprite.position = [self calculateLineCenter];
    
    [self.connectionLine draw];
    
    [super draw];
}

#pragma mark - Layer

-(void) addToLayer:(TFLayer *)layer{
    [layer addEditableObject:self];
}

-(void) removeFromLayer:(TFLayer *)layer{
    [layer removeEditableObject:self];
}

-(BOOL) testPoint:(CGPoint)point{
    if(self.visible && ccpDistance(_invocationStateSprite.position, point) < 40){
        return YES;
    }
    return NO;
}

@end
