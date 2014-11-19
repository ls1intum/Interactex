//
//  THOutput.m
//  TangoHapps
//
//  Created by Timm Beckmann on 10.06.14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THOutput.h"

@implementation THOutput

-(void) load{

    self.properties = [NSMutableArray array];
    TFProperty * property = [TFProperty propertyWithName:@"value" andType:kDataTypeAny];
    [self.properties addObject:property];
    
    self.events = [NSMutableArray array];
    TFEvent * event = [TFEvent eventNamed:kEventValueChanged];
    event.param1 = [TFPropertyInvocation invocationWithProperty:property target:self];
    [self.events addObject:event];
    
    TFMethod * method =  [TFMethod methodWithName:@"setOutput"];
    method.numParams = 1;
    method.firstParamType = kDataTypeAny;
    self.methods = [NSMutableArray arrayWithObjects:method, nil];
    
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
    [self load];
    
    self.type = (TFDataType) [decoder decodeIntForKey:@"type"];
    
    [self setType:self.type];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeInt:[NSNumber numberWithInt:self.type] forKey:@"type"];
    
}

-(id)copyWithZone:(NSZone *)zone {
    THOutput * copy = [super copyWithZone:zone];
    
    [copy load];
    
    return copy;
}

-(void) setOutput:(id) value {
    _value = value;
    [self triggerEventNamed:kEventValueChanged];
    if (self.type == kDataTypeBoolean) {
        if (value) [self triggerEventNamed:kEventConditionIsTrue];
        else [self triggerEventNamed:kEventConditionIsFalse];
    }
}

-(void) setPropertyType:(TFDataType)type {
    
    self.type = type;
    
    self.properties = [NSMutableArray array];
    TFProperty * property = [TFProperty propertyWithName:@"value" andType:type];
    [self.properties addObject:property];
    
    self.events = [NSMutableArray array];
    TFEvent * event = [TFEvent eventNamed:kEventValueChanged];
    event.param1 = [TFPropertyInvocation invocationWithProperty:property target:self];
    [self.events addObject:event];
    
    if (self.type == kDataTypeBoolean) {
        event = [TFEvent eventNamed:kEventConditionIsTrue];
        [self.events addObject:event];
        event = [TFEvent eventNamed:kEventConditionIsFalse];
        [self.events addObject:event];
    }
    
    self.methods = [NSMutableArray array];
    TFMethod * method =  [TFMethod methodWithName:@"setOutput"];
    method.numParams = 1;
    method.firstParamType = type;
    [self.methods addObject:method];
}

@end
