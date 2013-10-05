//
//  THBoolValue.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/5/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THBoolValue.h"

@implementation THBoolValue


-(void) load{
    
    TFProperty * property = [TFProperty propertyWithName:@"value" andType:kDataTypeBoolean];
    self.properties = [NSMutableArray arrayWithObject:property];
    
    TFMethod * method = [TFMethod methodWithName:@"setValue"];
    method.numParams = 1;
    method.firstParamType = kDataTypeBoolean;
    self.methods = [NSMutableArray arrayWithObject:method];
    
    TFEvent * event = [TFEvent eventNamed:kEventValueChanged];
    event.param1 = [TFPropertyInvocation invocationWithProperty:property target:self];
    self.events = [NSMutableArray arrayWithObject:event];
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
    THBoolValue * copy = [super copyWithZone:zone];
    
    copy.value = self.value;
    
    return copy;
}

#pragma mark - Methods

-(void) setValue:(BOOL)value{
    _value = value;
    [self triggerEventNamed:kEventValueChanged];
}

-(void) didStartSimulating{
    [self triggerEventNamed:kEventValueChanged];
    [super didStartSimulating];
}

-(NSString*) description{
    return @"boolean";
}


@end
