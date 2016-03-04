//
//  THComparisonOperator.h
//  TangoHapps
//
//  Created by Juan Haladjian on 03/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THProgrammingElement.h"

@interface THComparisonOperator : THProgrammingElement {
    BOOL _operand1Set;
    BOOL _operand2Set;
}

@property (nonatomic) BOOL result;
@property (nonatomic) float operand1;
@property (nonatomic) float operand2;

-(void) operateAndTrigger;
-(BOOL) operate;

@end
