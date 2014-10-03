//
//  THFlexSensor.h
//  TangoHapps
//
//  Created by Timm Beckmann on 02/04/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THHardwareComponent.h"

@interface THFlexSensor : THHardwareComponent
{
    BOOL _insideRange;
}

@property (nonatomic) NSInteger value;
@property (nonatomic) NSInteger minValueNotify;
@property (nonatomic) NSInteger maxValueNotify;
@property (nonatomic) THSensorNotifyBehavior notifyBehavior;

@property (nonatomic, readonly) THElementPin * minusPin;
@property (nonatomic, readonly) THElementPin * analogPin;

@end
