//
//  THConditionEditableObject.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THCondition.h"

@class THConditionObject;
@class THTriggerableProperties;


@interface THConditionEditableObject : TFEditableObject <THCondition>
{
    THTriggerableProperties * _currentProperties;
}

@end
