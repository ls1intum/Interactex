//
//  THGrouperConditionEditable.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THConditionEditableObject.h"
#import "THGrouperCondition.h"

@class THGrouperCondition;
@class THGrouperEditableProperties;

@interface THGrouperConditionEditable : THConditionEditableObject
{
    
    THGrouperEditableProperties * _currentGrouperProperties;
}

@property (nonatomic, weak) TFEditableObject * obj1;
@property (nonatomic, weak) TFEditableObject * obj2;

@property (nonatomic, copy) NSString * propertyName1;
@property (nonatomic, copy) NSString * propertyName2;

@property (nonatomic) BOOL value1;
@property (nonatomic) BOOL value2;

@property (nonatomic) THGrouperType type;

@end
