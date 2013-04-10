//
//  THConditionObject.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/16/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THCondition.h"

@interface THConditionObject : TFSimulableObject <THCondition>
{
}

@property (nonatomic, readonly) BOOL isTrue;

-(void) evaluateAndTrigger;

@end
