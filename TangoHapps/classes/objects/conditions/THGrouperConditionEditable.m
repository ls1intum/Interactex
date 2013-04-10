//
//  THGrouperConditionEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THGrouperConditionEditable.h"
#import "THGrouperEditableProperties.h"
#import "THGrouperCondition.h"

@implementation THGrouperConditionEditable

@dynamic type;

-(void) loadSprite{
    
    self.sprite = [CCSprite spriteWithFile:@"grouper.png"];
    [self addChild:self.sprite];
}

-(id) init{
    self = [super init];
    if(self){
        [self loadSprite];
        self.simulableObject = [[THGrouperCondition alloc] init];
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
    THGrouperConditionEditable * copy = [super copyWithZone:zone];
    
    copy.obj1 = self.obj1;
    copy.obj2 = self.obj2;
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    _currentGrouperProperties = [THGrouperEditableProperties properties];
    [controllers addObject:_currentGrouperProperties];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(THGrouperType) type{
    THGrouperCondition * condition = (THGrouperCondition*) self.simulableObject;
    return condition.type;
}

-(void) setType:(THGrouperType)type{
    THGrouperCondition * condition = (THGrouperCondition*) self.simulableObject;
    condition.type = type;
}

-(void) setValue1:(BOOL) number{
    THGrouperCondition * condition = (THGrouperCondition*) self.simulableObject;
    condition.value1 = number;
}

-(BOOL) value1{
    THGrouperCondition * condition = (THGrouperCondition*) self.simulableObject;
    return condition.value1;
}

-(void) setValue2:(BOOL) number{
    THGrouperCondition * condition = (THGrouperCondition*) self.simulableObject;
    condition.value2 = number;
}

-(BOOL) value2{
    THGrouperCondition * condition = (THGrouperCondition*) self.simulableObject;
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
    
    [_currentGrouperProperties reloadState];
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
    
    [_currentGrouperProperties reloadState];
}

-(void) addConnectionTo:(TFEditableObject *)object animated:(BOOL)animated{
    
    [_currentGrouperProperties reloadState];
    [super addConnectionTo:object animated:animated];
}

-(void) prepareToDie{
    self.obj1 = nil;
    self.obj2 = nil;
    _currentGrouperProperties = nil;
    [super prepareToDie];
}

-(NSString*) description{
    return @"Grouper";
}

@end
