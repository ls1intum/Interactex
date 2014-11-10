//
//  THFlexSensorEditable.h
//  TangoHapps
//
//  Created by Timm Beckmann on 02/04/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THHardwareComponentEditableObject.h"

@class CCLabelTTF;

@interface THFlexSensorEditable : THHardwareComponentEditableObject {
    float _value;
    float _bendIntensity;
    CCLabelTTF * _valueLabel;
}

@property (nonatomic) NSInteger isDown;

@property (nonatomic, readonly) NSInteger value;
@property (nonatomic) NSInteger minValueNotify;
@property (nonatomic) NSInteger maxValueNotify;
@property (nonatomic) THSensorNotifyBehavior notifyBehavior;

@property (nonatomic, readonly) THElementPinEditable * minusPin;
@property (nonatomic, readonly) THElementPinEditable * analogPin;
@property (nonatomic, readonly) THElementPinEditable * plusPin;

@end

