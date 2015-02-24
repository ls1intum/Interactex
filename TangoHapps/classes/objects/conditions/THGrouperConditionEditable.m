/*
THGrouperConditionEditable.m
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

#import "THGrouperConditionEditable.h"
#import "THGrouperEditableProperties.h"
#import "THGrouperCondition.h"

@implementation THGrouperConditionEditable

@dynamic grouperType;

-(id) init{
    self = [super init];
    if(self){
        
        [self loadGrouper];
        self.simulableObject = [[THGrouperCondition alloc] init];
    }
    return self;
}

-(void) loadGrouper{
    
    self.programmingElementType = kProgrammingElementTypeGrouper;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if(self ) {
        
        [self loadGrouper];
        
        self.obj1 = [decoder decodeObjectForKey:@"object1"];
        self.obj2 = [decoder decodeObjectForKey:@"object2"];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.obj1 forKey:@"object1"];
    [coder encodeObject:self.obj2 forKey:@"object2"];
}

-(id)copyWithZone:(NSZone *)zone {
    THGrouperConditionEditable * copy = [super copyWithZone:zone];
    
    copy.obj1 = self.obj1;
    copy.obj2 = self.obj2;
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    _currentGrouperProperties = [THGrouperEditableProperties properties];
    [controllers addObject:_currentGrouperProperties];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(THGrouperType) grouperType {
    THGrouperCondition * condition = (THGrouperCondition*) self.simulableObject;
    return condition.grouperType;
}

-(void) setGrouperType:(THGrouperType)grouperType{
    THGrouperCondition * condition = (THGrouperCondition*) self.simulableObject;
    condition.grouperType = grouperType;
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

-(NSString*) propertyName1 {
    return self.action1.firstParam.property.name;
}

-(NSString*) propertyName2 {
    return self.action2.firstParam.property.name;
}

-(void) handleObjectRemoved:(NSNotification*) notification{
    
    TFEditableObject * object = notification.object;
    
    if(object == self.action1.source){
        
        self.action1 = nil;
        self.obj1 = nil;
        self.propertyName1 = nil;
        
    } else if(object == self.action2.source){
        
        self.action2 = nil;
        self.obj2 = nil;
        self.propertyName2 = nil;
    }
    
    [_currentGrouperProperties reloadState];
    [super reloadProperties];
    
    //[super handleEditableObjectRemoved:notification];
}

-(THInvocationConnectionLine*) invocationConnectionWithActionNamed:(NSString*) methodName{
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    
    for (THInvocationConnectionLine * connection in project.invocationConnections) {
        if(connection.obj1 == self || connection.obj2 == self){
            if ([connection.action.method.name isEqualToString:methodName]) {
                return connection;
            }
        }
    }
    return nil;
}

-(void) handleRegisteredAsTargetForAction:(TFMethodInvokeAction*) action{
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    
    if ([action.method.name isEqualToString:kMethodSetValue1]) {
        if(self.action1 != nil) {
            
            THInvocationConnectionLine * connection = [self invocationConnectionWithActionNamed:kMethodSetValue1];
            if(connection){
                [project deregisterAction:self.action1];
                [project removeInvocationConnection:connection];
            }
        }
        self.action1 = action;
        self.obj1 = action.source;
        self.propertyName1 = action.firstParam.property.name;
        
    } else {
        if(self.action2 != nil) {
            THInvocationConnectionLine * connection = [self invocationConnectionWithActionNamed:kMethodSetValue2];
            if(connection){
                
                [project deregisterAction:self.action2];
                [project removeInvocationConnection:connection];
            }
        }
        self.action2 = action;
        self.obj2 = action.source;
        self.propertyName2 = action.firstParam.property.name;
    }
    ////
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleObjectRemoved:) name:kNotificationObjectRemoved object:action.source];
    
    [_currentGrouperProperties reloadState];
}

-(void) addConnectionTo:(TFEditableObject *)object animated:(BOOL)animated{
    
    [_currentGrouperProperties reloadState];
}

#pragma mark - Methods

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
