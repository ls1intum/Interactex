//
//  IFConstants.h
//  iFirmata
//
//  Created by Juan Haladjian on 6/28/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSInteger const IFNumDigitalPins;
extern NSInteger const IFNumAnalogPins;

typedef enum{
    IFPinTypeDigital,
    IFPinTypeAnalog,
} IFPinType;

typedef enum{
    IFPinModeInput,
    IFPinModeOutput,
    IFPinModeAnalog,
    IFPinModePWM,
    IFPinModeServo,
    IFPinModeShift,
    IFPinModeI2C
} IFPinMode;

extern NSString * const IFNotificationModeChanged;
