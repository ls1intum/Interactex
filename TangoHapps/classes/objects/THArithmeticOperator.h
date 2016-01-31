//
//  THArithmeticOperator.h
//  TangoHapps
//
//  Created by Juan Haladjian on 31/01/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THProgrammingElement.h"

@interface THArithmeticOperator : THProgrammingElement

@property (nonatomic) float result;

-(void) operateAndTrigger;
-(float) operate;

@end
