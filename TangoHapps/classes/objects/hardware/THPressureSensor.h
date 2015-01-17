//
//  THPressureSensor.h
//  TangoHapps
//
//  Created by Guven Candogan on 15/01/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THHardwareComponent.h"

@interface THPressureSensor : THHardwareComponent

@property (nonatomic) NSInteger pressure;

@property (nonatomic, readonly) THElementPin * minusPin;
@property (nonatomic, readonly) THElementPin * analogPin;
@property (nonatomic, readonly) THElementPin * plusPin;

@end
