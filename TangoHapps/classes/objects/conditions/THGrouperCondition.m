//
//  THGrouperCondition.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THGrouperCondition.h"

NSString * const kGrouperTypeStrings[kNumGrouperTypes] = {@"and",@"or"};

@implementation THGrouperCondition

#pragma mark - Init

-(void) loadMethods{
    TFMethod * method1 = [TFMethod methodWithName:kMethodSetValue1];
    method1.numParams = 1;
    method1.firstParamType = kDataTypeBoolean;

    TFMethod * method2 = [TFMethod methodWithName:kMethodSetValue2];
    method2.numParams = 1;
    method2.firstParamType = kDataTypeBoolean;
    
    self.methods = [NSMutableArray arrayWithObjects:method1,method2,nil];
}

-(id) init{
    self = [super init];
    if(self){
        [self loadMethods];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    
    self = [super initWithCoder:decoder];
    
    self.type = [decoder decodeIntegerForKey:@"type"];
    
    [self loadMethods];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    
    [super encodeWithCoder:coder];
    [coder encodeInteger:self.type forKey:@"type"];
}

-(id)copyWithZone:(NSZone *)zone
{
    THGrouperCondition * copy = [super copyWithZone:zone];
    
    copy.type = self.type;
    
    return copy;
}

#pragma mark - Methods

-(void) setValue1:(BOOL) b{
    _value1set = YES;
    _value1 = b;
    if(_value2set){
        [self evaluateAndTrigger];
    }
}

-(void) setValue2:(BOOL) b{
    _value2set = YES;
    _value2 = b;
    if(_value1set){
        [self evaluateAndTrigger];
    }
}

-(BOOL) testCondition{
    if(self.type == kGrouperTypeAnd){
        return self.value1 && self.value2;
    } else {
        return self.value1 || self.value2;
    }
    return NO;
}

-(NSString*) description{
    return @"grouper";
}

-(void) prepareToDie{
    [super prepareToDie];
}

@end
