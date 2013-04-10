//
//  THPotentiometerEditableObject.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/8/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THClotheObjectEditableObject.h"

@interface THPotentiometerEditableObject : THClotheObjectEditableObject {
    float _value;
    UIRotationGestureRecognizer * _rotationRecognizer;
    float _touchDownIntensity;
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
