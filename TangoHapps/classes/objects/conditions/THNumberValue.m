//
//  THValue.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/16/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THNumberValue.h"

@implementation THNumberValue

-(void) load{
    
    TFProperty * property = [TFProperty propertyWithName:@"value" andType:kDataTypeFloat];
    self.viewableProperties = [NSMutableArray arrayWithObject:property];
    
    TFMethod * method = [TFMethod methodWithName:@"setValue"];
    method.numParams = 1;
    method.firstParamType = kDataTypeFloat;
    self.methods = [NSArray arrayWithObject:method];
    
    TFEvent * event = [TFEvent eventNamed:kEventValueChanged];
    event.param1 = [TFPropertyInvocation invocationWithProperty:property target:self];
    self.events = [NSArray arrayWithObject:event];
}

-(id) init{
    self = [super init];
    if(self){
        [self load];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    _value = [decoder decodeFloatForKey:@"value"];
    
    [self load];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeFloat:_value forKey:@"value"];
}

-(id)copyWithZone:(NSZone *)zone
{
    THNumberValue * copy = [super copyWithZone:zone];
    
    copy.value = self.value;
    
    return copy;
}

#pragma mark - Methods

-(void) setValue:(float)value{
    _value = value;
    [self triggerEventNamed:kEventValueChanged];
}

-(void) didStartSimulating{
    [self triggerEventNamed:kEventValueChanged];
    [super didStartSimulating];
}

-(NSString*) description{
    return @"number value";
}

@end
