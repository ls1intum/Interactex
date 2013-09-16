//
//  THMapper.m
//  TangoHapps
//
//  Created by Juan Haladjian on 12/11/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THMapper.h"
#import "THLinearFunction.h"

@implementation THMapper

-(void) load{
    
    TFProperty * property = [TFProperty propertyWithName:@"value" andType:kDataTypeFloat];
    self.properties = [NSMutableArray arrayWithObject:property];
    
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
        
        _max = 300;
        _function = [THLinearFunction functionWithA:1.0f b:0.0f];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if(self){
        _min = [decoder decodeFloatForKey:@"min"];
        _max = [decoder decodeFloatForKey:@"max"];
        _function = [decoder decodeObjectForKey:@"function"];
        
        [self load];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeFloat:_min forKey:@"min"];
    [coder encodeFloat:_max forKey:@"max"];
    [coder encodeObject:_function forKey:@"function"];
}

-(id)copyWithZone:(NSZone *)zone
{
    THMapper * copy = [super copyWithZone:zone];
    
    copy.min = self.min;
    copy.max = self.max;
    copy.function = self.function;
    
    return copy;
}

#pragma mark - Methods

-(float) mapAndConstrain:(float) value{
    value = [self.function evaluate:value];
    return [THClientHelper Constrain: value min: self.min max:self.max];
}

-(void) setValue:(float)value{
    _value = [self mapAndConstrain:value];
    [self triggerEventNamed:kEventValueChanged];
}

-(void) didStartSimulating{
    [self triggerEventNamed:kEventValueChanged];
    [super didStartSimulating];
}

-(NSString*) description{
    return @"value";
}


@end
