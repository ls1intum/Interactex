//
//  THConditionEditableObject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THConditionEditableObject.h"
#import "THConditionObject.h"
#import "THHardwareComponentEditableObject.h"
#import "THViewEditableObject.h"

@implementation THConditionEditableObject

-(void) loadCondition{
    self.z = kConditionZ;
    self.acceptsConnections = YES;
}

-(id) init{
    self = [super init];
    if(self){
        [self loadCondition];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
        
    [self loadCondition];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone
{
    THConditionEditableObject * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Methods

-(BOOL) testCondition{
    THConditionObject * condition = (THConditionObject*) self.simulableObject;
    return [condition testCondition];
}

-(void) addToLayer:(TFLayer *)layer{
    [layer addEditableObject:self];
}

-(void) removeFromLayer:(TFLayer *)layer{
    [layer removeEditableObject:self];
}

-(void) addToWorld{
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addCondition:self];
}

-(void) removeFromWorld{
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project removeCondition:self];
    [super removeFromWorld];
}

-(void) prepareToDie{
    _currentProperties = nil;
    
    [super prepareToDie];
}

-(NSString*) description{
    return @"ConditionAbs";
}

@end
