//
//  THMPU6050Editable.h
//  TangoHapps
//
//  Created by Juan Haladjian on 15/03/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THHardwareComponentEditableObject.h"

#import <CoreLocation/CoreLocation.h>

@class THAccelerometerData;

@interface THMPU6050Editable : THHardwareComponentEditableObject <UIAccelerometerDelegate>{
        }
/*
@property (nonatomic) float accelerometerX;
@property (nonatomic) float accelerometerY;
 @property (nonatomic) float accelerometerZ;*/

@property (nonatomic) THAccelerometerData* accelerometer;

@property (nonatomic, readonly) THElementPinEditable * sclPin;
@property (nonatomic, readonly) THElementPinEditable * sdaPin;

@property (nonatomic) THI2CComponentType componentType;

@end
