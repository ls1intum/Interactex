//
//  THCondition.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THComparisonCondition.h"

NSString * const kConditionTypeStrings[kNumConditionTypes] = {@"<",@"=",@">"};

@implementation THComparisonCondition

#pragma mark - Archiving

-(void) loadMethods{
    TFMethod * method1 = [TFMethod methodWithName:kMethodSetValue1];
    method1.numParams = 1;
    method1.firstParamType = kDataTypeFloat;
    
    TFMethod * method2 = [TFMethod methodWithName:kMethodSetValue2];
    method2.numParams = 1;
    method2.firstParamType = kDataTypeFloat;
    
    
    self.methods = [NSMutableArray arrayWithObjects:method1,method2,nil];
}

-(id) init{
    self = [super init];
    if(self){
        [self loadMethods];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    [self loadMethods];
    
    self.type = [decoder decodeIntegerForKey:@"type"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeInteger:self.type forKey:@"type"];
}

-(id)copyWithZone:(NSZone *)zone
{
    THComparisonCondition * copy = [super copyWithZone:zone];
    
    copy.type = self.type;
    
    return copy;
}

#pragma mark - Methods

-(void) setValue1:(float) number{
    _value1set = YES;
    _value1 = number;
    if(_value2set){
        [self evaluateAndTrigger];
    }
}

-(void) setValue2:(float) number{
    _value2set = YES;
    _value2 = number;
    if(_value1set){
        [self evaluateAndTrigger];
    }
}

-(BOOL) testCondition{
    
    if(self.type == kConditionTypeBiggerThan){
        return self.value1 > self.value2;
    } else if(self.type == kConditionTypeSmallerThan){
        return self.value1 < self.value2;
    } else {
        return fabs(self.value1 - self.value2) < 0.0001;
    }
    
    return NO;
}

-(NSString*) description{
    return @"comparison";
}

-(void) prepareToDie{
    [super prepareToDie];
}
@end
