//
//  THSubtractionOperatorEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 29/01/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THSubtractionOperatorEditable.h"
#import "THSubtractionOperator.h"

@implementation THSubtractionOperatorEditable

-(id) init{
    self = [super init];
    if(self){
        [self loadSubtraction];
        self.simulableObject = [[THSubtractionOperator alloc] init];
    }
    return self;
}

-(void) loadSubtraction{
    
    self.programmingElementType = kProgrammingElementTypeSubtraction;
}

-(void) setOperand1:(float)operand1{
    THSubtractionOperator * operator = (THSubtractionOperator*) self.simulableObject;
    operator.operand1 = operand1;
}

-(void) setOperand2:(float)operand2{
    THSubtractionOperator * operator = (THSubtractionOperator*) self.simulableObject;
    operator.operand2 = operand2;
}


#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if(self) {
        [self loadSubtraction];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THSubtractionOperatorEditable * copy = [super copyWithZone:zone];
    
    
    return copy;
}

@end
