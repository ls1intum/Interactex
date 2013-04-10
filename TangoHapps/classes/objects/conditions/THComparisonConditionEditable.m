//
//  THConditionEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THComparisonConditionEditable.h"
#import "THComparisonCondition.h"
#import "THComparatorEditableProperties.h"
#import "THGrouperConditionEditable.h"

@implementation THComparisonConditionEditable

@dynamic type;

#pragma mark - Init

-(void) loadSprite{
    
    self.sprite = [CCSprite spriteWithFile:@"comparator.png"];
    [self addChild:self.sprite];
}

-(id) init{
    self = [super init];
    if(self){
        [self loadSprite];
        self.simulableObject = [[THComparisonCondition alloc] init];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    [self loadSprite];
    
    self.obj1 = [decoder decodeObjectForKey:@"object1"];
    self.obj2 = [decoder decodeObjectForKey:@"object2"];
    
    if(self.obj1 != nil){
        [self registerNotificationsFor:self.obj1];
    }
    if(self.obj2 != nil){
        [self registerNotificationsFor:self.obj1];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.obj1 forKey:@"object1"];
    [coder encodeObject:self.obj2 forKey:@"object2"];
}

-(id)copyWithZone:(NSZone *)zone
{
    THComparisonConditionEditable * copy = [super copyWithZone:zone];
    
    copy.obj1 = self.obj1;
    copy.obj2 = self.obj2;
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    _currentComparatorProperties = [THComparatorEditableProperties properties];
    [controllers addObject:_currentComparatorProperties];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}


#pragma mark - Protocols
/*
-(void) registerAction:(THAction *)action forProperty:(THProperty *)property{
    THMethodInvokeAction * methodInvoke = (THMethodInvokeAction*) action;
    if(self.obj1 == nil){
        self.obj1 = action.target;
        self.propertyName1 = methodInvoke.firstParam.property.name;
        
    } else if(self.obj2 == nil){
        self.obj2 = action.target;
        self.propertyName2 = methodInvoke.firstParam.property.name;
        
    } else {
        self.obj1 = action.target;
        self.propertyName1 = methodInvoke.firstParam.property.name;
        self.obj2 = nil;
    }
    
    [super registerAction:action forProperty:property];
}*/


#pragma mark - Methods

-(THConditionType) type{
    THComparisonCondition * condition = (THComparisonCondition*) self.simulableObject;
    return condition.type;
}

-(void) setType:(THConditionType)type{
    
    THComparisonCondition * condition = (THComparisonCondition*) self.simulableObject;
    condition.type = type;
}

-(void) setValue1:(float) number{
    THComparisonCondition * condition = (THComparisonCondition*) self.simulableObject;
    condition.value1 = number;
}

-(float) value1{
    
    THComparisonCondition * condition = (THComparisonCondition*) self.simulableObject;
    return condition.value1;
}

-(void) setValue2:(float) number{
    THComparisonCondition * condition = (THComparisonCondition*) self.simulableObject;
    condition.value2 = number;
}

-(float) value2{
    
    THComparisonCondition * condition = (THComparisonCondition*) self.simulableObject;
    return condition.value2;
}

-(void) handleObjectRemoved:(NSNotification*) notification{
    
    TFEditableObject * object = notification.object;
    
    if(object == self.obj1){
        self.obj1 = nil;
        self.propertyName1 = nil;
    } else if(object == self.obj2){
        self.obj2 = nil;
        self.propertyName2 = nil;
    }
    
    [_currentComparatorProperties reloadState];
    [super reloadProperties];
    //[super handleEditableObjectRemoved:notification];
}

-(void) handleRegisteredAsTargetForAction:(TFMethodInvokeAction*) action{
    
    if(self.obj1 == nil){
        self.obj1 = action.source;
        self.propertyName1 = action.firstParam.property.name;
        
    } else if(self.obj2 == nil){
        self.obj2 = action.source;
        self.propertyName2 = action.firstParam.property.name;
        
    } else {
        self.obj1 = action.source;
        self.propertyName1 = action.firstParam.property.name;
        self.obj2 = nil;
        self.propertyName2 = nil;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleObjectRemoved:) name:kNotificationObjectRemoved object:action.source];
    
    [_currentComparatorProperties reloadState];
}

-(void) addConnectionTo:(TFEditableObject *)object animated:(BOOL)animated{
    
    [_currentComparatorProperties reloadState];
    [super addConnectionTo:object animated:animated];
}

-(NSString*) description{
    return @"Comparison";
}

-(void) prepareToDie{
    _currentComparatorProperties = nil;
    self.obj1 = nil;
    self.obj2 = nil;
    [super prepareToDie];
}

@end
