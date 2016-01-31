//
//  THSubtractionOperator.h
//  TangoHapps
//
//  Created by Juan Haladjian on 29/01/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THArithmeticOperator.h"

@interface THSubtractionOperator : THArithmeticOperator
{
    BOOL operand1Set;
    BOOL operand2Set;
}

@property (nonatomic) float operand1;
@property (nonatomic) float operand2;

@end
