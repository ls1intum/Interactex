//
//  THArithmeticOperator.m
//  TangoHapps
//
//  Created by Juan Haladjian on 31/01/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THArithmeticOperator.h"

@implementation THArithmeticOperator

-(void) operateAndTrigger{
    [self operate];
    [self triggerEventNamed:kEventOperationFinished];
}

-(float) operate{
    self.result = -1;
    return -1;
}

@end
