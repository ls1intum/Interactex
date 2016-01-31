//
//  THSubtractionOperator.m
//  TangoHapps
//
//  Created by Juan Haladjian on 29/01/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THSubtractionOperator.h"

@implementation THSubtractionOperator

-(id) init{
    self = [super init];
    if(self){
        [self loadSubtractionOperator];
        
    }
    return self;
}

-(void) loadSubtractionOperator{
    
    TFProperty * property = [TFProperty propertyWithName:@"result" andType:kDataTypeFloat];
    self.properties = [NSMutableArray arrayWithObject:property];
    
    
    TFMethod * method1 = [TFMethod methodWithName:@"setOperand1"];
    method1.numParams = 1;
    method1.firstParamType = kDataTypeFloat;
    
    TFMethod * method2 = [TFMethod methodWithName:@"setOperand2"];
    method2.numParams = 1;
    method2.firstParamType = kDataTypeFloat;
    
    TFMethod * method3 = [TFMethod methodWithName:@"operate"];
    
    self.methods = [NSMutableArray arrayWithObjects:method1,method2,method3,nil];
    
    TFEvent * event = [TFEvent eventNamed:kEventOperationFinished];
    event.param1 = [TFPropertyInvocation invocationWithProperty:property target:self];
    self.events = [NSMutableArray arrayWithObject:event];
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        _operand1 = [decoder decodeFloatForKey:@"operand1"];
        _operand2 = [decoder decodeFloatForKey:@"operand2"];
        
        [self loadSubtractionOperator];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeFloat:_operand1 forKey:@"operand1"];
    [coder encodeFloat:_operand2 forKey:@"operand2"];
}

-(id)copyWithZone:(NSZone *)zone {
    THSubtractionOperator * copy = [super copyWithZone:zone];
    
    copy.operand1 = self.operand1;
    copy.operand2 = self.operand2;
    
    return copy;
}

#pragma mark - Methods

-(void) setOperand1:(float) number{
    operand1Set = YES;
    _operand1 = number;
    if(operand2Set){
        [self operateAndTrigger];
    }
}

-(void) setOperand2:(float) number{
    operand2Set = YES;
    _operand2 = number;
    if(operand1Set){
        [self operateAndTrigger];
    }
}

-(float) operate{
    
   self.result = (self.operand1 - self.operand2);
    return self.result;
}

-(void) didStartSimulating{
    //[self triggerEventNamed:kEventOperationFinished];
    [super didStartSimulating];
}

-(NSString*) description{
    return @"subtraction";
}


@end
