//
//  THComparisonOperatorEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 03/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THComparisonOperatorEditable.h"
#import "THComparisonOperator.h"

@implementation THComparisonOperatorEditable

-(BOOL) result{
    THComparisonOperator * operator = (THComparisonOperator*) self.simulableObject;
    return operator.result;
}

-(void) setOperand1:(float)operand1{
    THComparisonOperator * operator = (THComparisonOperator*) self.simulableObject;
    operator.operand1 = operand1;
}

-(void) setOperand2:(float)operand2{
    THComparisonOperator * operator = (THComparisonOperator*) self.simulableObject;
    operator.operand2 = operand2;
}

@end
