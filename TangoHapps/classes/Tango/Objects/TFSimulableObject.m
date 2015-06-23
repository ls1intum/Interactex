/*
TFSimulableObject.m
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

#import "TFSimulableObject.h"
#import "TFMethodInvokeAction.h"
#import "TFMethod.h"
#import "TFPropertyInvocation.h"
#import "TFProperty.h"
#import "TFEvent.h"

@implementation TFSimulableObject

@synthesize events = _events;
@synthesize methods = _methods;
@synthesize properties = _properties;
@synthesize visible = _visible;

#pragma mark - Archiving

-(void) loadSimulable{
    _visible = YES;
}

-(id) init{
    self = [super init];
    if(self){
        //_actions = [NSMutableDictionary dictionary];
        _events = [NSMutableArray array];
        [self loadSimulable];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    
    //_actions = [decoder decodeObjectForKey:@"actions"];
    
    [self loadSimulable];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    
    //[coder encodeObject:_actions forKey:@"actions"];
}

-(id)copyWithZone:(NSZone *)zone{
    TFSimulableObject * copy = [[[self class] alloc] init];
    //copy.actions = self.actions;
    
    return copy;
}

#pragma mark - Protocols

-(BOOL) acceptsPropertiesOfType:(TFDataType)type{
    
    for (TFMethod * method in _methods) {
        if([method acceptsParemeterOfType:type]){
            return YES;
        }
    }
    return NO;
}

-(TFProperty*) propertyNamed:(NSString*) name{
    for (TFProperty * property in self.properties) {
        if([property.name isEqualToString:name]){
            return property;
        }
    }
    return nil;
}

-(void) deregisterAllProperties{
    
}

#pragma mark - Methods

-(TFMethod*) methodNamed:(NSString*) methodName{
    for (TFMethod * method in self.methods) {
        if([method.name isEqualToString:methodName]){
            return method;
        }
    }
    NSAssert(NO, @"looking for non-existing method");
    return nil;
}

-(TFEvent*) eventNamed:(NSString*) eventName{
    for (TFEvent * event in self.events) {
        if([event.name isEqualToString:eventName]){
            return event;
        }
    }
    NSAssert(NO, @"looking for non-existing event");
    return nil;
}

#pragma mark - Events

-(void) triggerEventNamed:(NSString*) name{
    if(self.simulating){
        [[NSNotificationCenter defaultCenter] postNotificationName:name  object:self];
    }
}

-(void) triggerEvent:(TFEvent*) event{
    if(self.simulating){
        [[NSNotificationCenter defaultCenter] postNotificationName:event.name  object:self];
    }
}

#pragma mark - UI

-(void) tapped{}

#pragma mark - Lifecycle

-(void) willStartSimulating{
    _simulating = YES;
}

-(void) didStartSimulating{
}

-(void) stopSimulating{
    _simulating = NO;
}

-(void) prepareToDie{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _methods = nil;
    _events = nil;
    _properties = nil;
}

-(void) dealloc{

    if ([@"YES" isEqualToString: [[[NSProcessInfo processInfo] environment] objectForKey:@"printDeallocsSimulableObjects"]]) {
            NSLog(@"deallocing %@",self);
    }
}

@end
