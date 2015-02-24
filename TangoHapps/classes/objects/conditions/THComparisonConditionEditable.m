/*
THComparisonConditionEditable.m
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

#import "THComparisonConditionEditable.h"
#import "THComparisonCondition.h"
#import "THComparatorEditableProperties.h"
#import "THGrouperConditionEditable.h"
#import "TFMethodInvokeAction.h"

@implementation THComparisonConditionEditable

NSString * const kConditionTypeStrings[kNumConditionTypes] = {@"<",@"=",@">"};
NSString * const kConditionTypeDescriptionStrings[kNumConditionTypes] = {@"smaller than",@"equals to",@"bigger than"};

@dynamic programmingElementType;

#pragma mark - Init

-(id) init{
    self = [super init];
    if(self){
        [self loadComparator];
        self.simulableObject = [[THComparisonCondition alloc] init];
    }
    return self;
}

-(void) loadComparator{
    
    self.programmingElementType = kProgrammingElementTypeComparator;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];

    if(self) {
        [self loadComparator];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THComparisonConditionEditable * copy = [super copyWithZone:zone];
    
    copy.conditionType = self.conditionType;
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    _currentComparatorProperties = [THComparatorEditableProperties properties];
    [controllers addObject:_currentComparatorProperties];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(THConditionType) conditionType{
    THComparisonCondition * condition = (THComparisonCondition*) self.simulableObject;
    return condition.conditionType;
}

-(void) setConditionType:(THConditionType)conditionType{
    THComparisonCondition * condition = (THComparisonCondition*) self.simulableObject;
    condition.conditionType = conditionType;
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
        
    } else if(object == self.action2.source){
        
        self.action2 = nil;
    }
    
    [_currentComparatorProperties reloadState];
    [super reloadProperties];
}

-(void) handleRegisteredAsTargetForAction:(TFMethodInvokeAction*) action{
    
    //Nazmus added
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    THInvocationConnectionLine * previousConnectionToSameAction = nil;
    if ([action.method.name isEqualToString:kMethodSetValue1]) {
        if(self.action1 != nil) {
            
            for (THInvocationConnectionLine * connection in project.invocationConnections) {
                if(connection.obj1 == self || connection.obj2 == self){
                    if ([connection.action.method.name isEqualToString:kMethodSetValue1]) {
                        previousConnectionToSameAction = connection;
                    }
                }
            }
            if (previousConnectionToSameAction) {
                [project deregisterAction:self.action1];
                [project removeInvocationConnection:previousConnectionToSameAction];
            }
        }
        self.action1 = action;
    } else {
        if(self.action2 != nil) {
            
            for (THInvocationConnectionLine * connection in project.invocationConnections) {
                if(connection.obj1 == self || connection.obj2 == self){
                    if ([connection.action.method.name isEqualToString:kMethodSetValue2]) {
                        previousConnectionToSameAction = connection;
                    }
                }
            }
            if (previousConnectionToSameAction) {
                [project deregisterAction:self.action2];
                [project removeInvocationConnection:previousConnectionToSameAction];
            }
        }
        self.action2 = action;
    }
    ////
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleObjectRemoved:) name:kNotificationObjectRemoved object:action.source];
    
    [_currentComparatorProperties reloadState];
}


-(NSString*) conditionTypeString{
    return kConditionTypeDescriptionStrings[self.conditionType];
}

-(NSString*) description{
    return @"Comparison";
}

-(void) prepareToDie{
    _currentComparatorProperties = nil;
    [super prepareToDie];
}

@end
