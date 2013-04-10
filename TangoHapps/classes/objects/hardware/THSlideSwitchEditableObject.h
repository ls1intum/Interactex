//
//  THSwitchEditableObject.h
//  TangoHapps
//
//  Created by Juan Haladjian on 10/11/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THSwitchEditableObject.h"

@class THTriggerableProperties;

@interface THSlideSwitchEditableObject : THSwitchEditableObject
{
    CCSprite * _switchOnSprite;
}

@property (nonatomic) BOOL on;

@end
