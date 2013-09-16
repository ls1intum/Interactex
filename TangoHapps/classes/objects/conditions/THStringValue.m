//
//  THStringValue.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/5/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THStringValue.h"

@implementation THStringValue

-(void) load{
    
    TFProperty * property = [TFProperty propertyWithName:@"value" andType:kDataTypeString];
    self.properties = [NSMutableArray arrayWithObject:property];
    
    TFMethod * method = [TFMethod methodWithName:@"setValue"];
    method.numParams = 1;
    method.firstParamType = kDataTypeString;
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

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    _value = [decoder decodeObjectForKey:@"value"];
    
    [self load];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:_value forKey:@"value"];
}

-(id)copyWithZone:(NSZone *)zone {
    THStringValue * copy = [super copyWithZone:zone];
    
    copy.value = self.value;
    
    return copy;
}

#pragma mark - Methods

-(void) setValue:(NSString *)value{
    _value = value;
    [self triggerEventNamed:kEventValueChanged];
}

-(void) didStartSimulating{
    [self triggerEventNamed:kEventValueChanged];
    [super didStartSimulating];
}

-(NSString*) description{
    return @"string";
}

@end
