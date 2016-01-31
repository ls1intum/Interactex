//
//  THArithmeticOperatorEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 31/01/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THArithmeticOperatorEditable.h"
#import "THArithmeticOperator.h"

@implementation THArithmeticOperatorEditable

-(float) result{
    THArithmeticOperator * arithmeticOperator = (THArithmeticOperator*) self.simulableObject;
    return arithmeticOperator.result;
}

@end
