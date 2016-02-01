//
//  THArithmeticOperator.m
//  TangoHapps
//
//  Created by Juan Haladjian on 31/01/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THArithmeticOperator.h"

@implementation THArithmeticOperator

-(id) init{
    self = [super init];
    if(self){
        [self loadOperator];
        
    }
    return self;
}

-(void) loadOperator{
    
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
        
        _operand1Set = [decoder decodeBoolForKey:@"operand1Set"];
        _operand2Set = [decoder decodeBoolForKey:@"operand2Set"];
        
        [self loadOperator];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeFloat:_operand1 forKey:@"operand1"];
    [coder encodeFloat:_operand2 forKey:@"operand2"];
    
    [coder encodeBool:_operand1Set forKey:@"operand1Set"];
    [coder encodeBool:_operand2Set forKey:@"operand2Set"];
}


#pragma mark - Methods

-(void) setOperand1:(float) number{
    _operand1Set = YES;
    _operand1 = number;
    if(_operand2Set){
        [self operateAndTrigger];
    }
}

-(void) setOperand2:(float) number{
    _operand2Set = YES;
    _operand2 = number;
    if(_operand1Set){
        [self operateAndTrigger];
    }
}

-(void) operateAndTrigger{
    [self operate];
    [self triggerEventNamed:kEventOperationFinished];
}


-(float) operate{
    self.result = -1;
    return -1;
}

@end
