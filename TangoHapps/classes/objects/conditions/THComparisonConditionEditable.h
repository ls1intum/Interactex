//
//  THConditionEditable.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THConditionEditableObject.h"
#import "THComparisonCondition.h"

@class THComparisonCondition;
@class THComparatorEditableProperties;

@interface THComparisonConditionEditable : THConditionEditableObject <NSCoding>
{
    THComparatorEditableProperties * _currentComparatorProperties;
}

@property (nonatomic, strong) TFEditableObject * obj1;
@property (nonatomic, strong) TFEditableObject * obj2;

@property (nonatomic, copy) NSString * propertyName1;
@property (nonatomic, copy) NSString * propertyName2;

@property (nonatomic) float value1;
@property (nonatomic) float value2;

@property (nonatomic) THConditionType type;

@end
