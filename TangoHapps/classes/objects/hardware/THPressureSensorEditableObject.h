//
//  THPressureSensorEditableObject.h
//  TangoHapps
//
//  Created by Guven Candogan on 15/01/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THHardwareComponentEditableObject.h"

@interface THPressureSensorEditableObject : THHardwareComponentEditableObject{

    CCLabelTTF * _pressureLabel;
    float _pressureIntensity;
    float _pressure;
}

@property (nonatomic) NSInteger pressure;

@property (nonatomic, readonly) THElementPinEditable * minusPin;
@property (nonatomic, readonly) THElementPinEditable * analogPin;
@property (nonatomic, readonly) THElementPinEditable * plusPin;

@end
