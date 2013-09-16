/*
 * TangoFramework
 *
 * Copyright (c) 2012 Juan Haladjian
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
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
@synthesize properties = _viewableProperties;
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
    return nil;
}

-(TFEvent*) eventNamed:(NSString*) eventName{
    for (TFEvent * event in self.events) {
        if([event.name isEqualToString:eventName]){
            return event;
        }
    }
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
    _viewableProperties = nil;
}

-(void) dealloc{

    if ([@"YES" isEqualToString: [[[NSProcessInfo processInfo] environment] objectForKey:@"printDeallocsSimulableObjects"]]) {
            NSLog(@"deallocing %@",self);
    }
}

@end
