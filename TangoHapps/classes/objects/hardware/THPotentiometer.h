//
//  THPotentiometer.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/8/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THHardwareComponent.h"

extern float const kMaxPotentiometerValue;

@interface THPotentiometer : THHardwareComponent
{
    BOOL _insideRange;
}

@property (nonatomic) NSInteger value;
@property (nonatomic) NSInteger minValueNotify;
@property (nonatomic) NSInteger maxValueNotify;
@property (nonatomic) THSensorNotifyBehavior notifyBehavior;

@property (nonatomic, readonly) THElementPin * minusPin;
@property (nonatomic, readonly) THElementPin * analogPin;
@property (nonatomic, readonly) THElementPin * plusPin;

@end
