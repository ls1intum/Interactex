//
//  THArithmeticOperator.h
//  TangoHapps
//
//  Created by Juan Haladjian on 31/01/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THProgrammingElement.h"

@interface THArithmeticOperator : THProgrammingElement {
    BOOL _operand1Set;
    BOOL _operand2Set;
}

@property (nonatomic) float result;
@property (nonatomic) float operand1;
@property (nonatomic) float operand2;

-(void) operateAndTrigger;
-(float) operate;

@end
