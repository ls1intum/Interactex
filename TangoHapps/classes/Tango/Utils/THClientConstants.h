//
//  THClientConstants.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/9/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kNumDataTypes 5

typedef enum{
    kDataTypeBoolean,
    kDataTypeInteger,
    kDataTypeFloat,
    kDataTypeString,
    kDataTypeAny
} TFDataType;

typedef enum {
    kDigitalPinValueLow = 0,
    kDigitalPinValueHigh = 1
} THDigitalPinValue ;

#define kNumHardwareTypes 9
#define kMaxNumPinsPerElement 4

typedef enum{
    kHardwareTypeLed,
    kHardwareTypeBuzzer,
    kHardwareTypeButton,
    kHardwareTypeSwitch,
    kHardwareTypePotentiometer,
    kHardwareTypeLightSensor,
    kHardwareTypeCompass,
    kHardwareTypeThreeColorLed,
    kHardwareTypeVibeBoard
}THHardwareType;

#define kNumPinTypes 4

typedef enum{
    kPintypeDigital,
    kPintypeAnalog,
    kPintypeMinus,
    kPintypePlus,
} THPinType;


#define kNumPinModes 7

typedef enum{
    kPinModeDigitalInput = 0,
    kPinModeDigitalOutput = 1,
    kPinModeAnalogInput = 2,
    kPinModePWM = 3,
    kPinModeBuzzer = 4,
    kPinModeCompass = 5,
    kPinModeUndefined = 6
} THPinMode;


#define kNumElementPinTypes 6
typedef enum{
    kElementPintypeDigital,
    kElementPintypeAnalog,
    kElementPintypePlus,
    kElementPintypeMinus,
    kElementPintypeScl,
    kElementPintypeSda
} THElementPinType;


typedef struct{
    THElementPinType type;
    CGPoint position;
    
} THPinDescriptor;



#define kNumiPhoneTypes 2

typedef enum{
    kiPhoneType4S,
    kiPhoneType5
} THIPhoneType;

extern CGRect const kiPhoneFrames[kNumiPhoneTypes];


//notifications
extern NSString * const kNotificationLedOn;
extern NSString * const kNotificationLedOff;

extern NSString * const kNotificationBuzzerOn;
extern NSString * const kNotificationBuzzerOff;

extern NSString * const kNotificationBuzzerFrequencyChanged;
extern NSString * const kNotificationLedIntensityChanged;
extern NSString * const kNotificationPinValueChanged;

extern NSString * const kNotificationSwitchOn;
extern NSString * const kNotificationSwitchOff;


extern NSString * const kNotificationLilypadObjectAdded;
extern NSString * const kNotificationLilypadObjectRemoved;

extern NSString * const kNotificationLilypadAdded;
extern NSString * const kNotificationLilypadRemoved;

extern NSString * const kNotificationPinAttached;
extern NSString * const kNotificationPinDeattached;

//events
extern NSString * const kEventTurnedOn;
extern NSString * const kEventTurnedOff;
extern NSString * const kEventOnChanged;
extern NSString * const kEventIntensityChanged;
extern NSString * const kEventFrequencyChanged;
extern NSString * const kEventValueChanged;
extern NSString * const kEventMapperValueChanged;
extern NSString * const kEventDxChanged;
extern NSString * const kEventDyChanged;
extern NSString * const kEventLightChanged;
extern NSString * const kEventStartedPressing;
extern NSString * const kEventStoppedPressing;
extern NSString * const kEventConditionIsTrue;
extern NSString * const kEventConditionIsFalse;
extern NSString * const kEventConditionChanged;
extern NSString * const kEventXChanged;
extern NSString * const kEventYChanged;
extern NSString * const kEventZChanged;
extern NSString * const kEventHeadingChanged;
extern NSString * const kEventTapped;
extern NSString * const kEventDoubleTapped;
extern NSString * const kEventScaleChanged;
extern NSString * const kEventLongPressed;
extern NSString * const kEventColorChanged;
extern NSString * const kEventTriggered;

//methods
extern NSString * const kMethodTurnOn;
extern NSString * const kMethodTurnOff;
extern NSString * const kMethodSetValue1;
extern NSString * const kMethodSetValue2;
extern NSString * const kMethodSetRed;
extern NSString * const kMethodSetGreen;
extern NSString * const kMethodSetBlue;

#define kMaxNumNotifyBehaviors 3

typedef enum {
    kSensorNotifyBehaviorAlways,
    kSensorNotifyBehaviorWhenInRange,
    kSensorNotifyBehaviorOncePerPeak,
} THSensorNotifyBehavior;


extern NSString * const kGameKitSessionId;


extern NSString * const dataTypeStrings[kNumDataTypes];
extern NSInteger const kNumPinsPerElement[kNumHardwareTypes];


extern NSString* const kPinTexts[kNumPinTypes];
extern NSString* const kPinModeTexts[kNumPinModes];
extern NSString* const kElementPinTexts[kNumElementPinTypes];

extern NSString * const kPaletteItemsDirectory;
extern NSString * const kProjectsDirectory;
extern NSString * const kProjectImagesDirectory;

extern float const kMaxAnalogValue;


extern float const kBuzzerMaxFrequency;
extern float const kBuzzerMinFrequency;


#define kLilypadNumPwmPins 6

extern NSInteger const kLilypadPwmPins[kLilypadNumPwmPins];
