//
//  THGrouperCondition.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THConditionObject.h"

#define kNumGrouperTypes 2

extern NSString * const kGrouperTypeStrings[kNumGrouperTypes];

typedef enum{
    kGrouperTypeAnd,
    kGrouperTypeOr
} THGrouperType;

@interface THGrouperCondition : THConditionObject <NSCoding>
{
    
}

@property (nonatomic) THGrouperType type;

@property (nonatomic) BOOL value1set;
@property (nonatomic) BOOL value2set;

@property (nonatomic) BOOL value1;
@property (nonatomic) BOOL value2;

@end
