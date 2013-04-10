//
//  THCondition.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THConditionObject.h"

#define kNumConditionTypes 3

extern NSString * const kConditionTypeStrings[kNumConditionTypes];

typedef enum{
    kConditionTypeSmallerThan,
    kConditionTypeEquals,
    kConditionTypeBiggerThan
} THConditionType;

@class THProperty;

@interface THComparisonCondition : THConditionObject <NSCoding>
{
    
}

@property (nonatomic) THConditionType type;

@property (nonatomic) BOOL value1set;
@property (nonatomic) BOOL value2set;

@property (nonatomic) float value1;
@property (nonatomic) float value2;

@end
