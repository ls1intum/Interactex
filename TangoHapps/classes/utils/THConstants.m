//
//  Constants.c
//  TangoHapps
//
//  Created by Juan Haladjian on 9/7/12.
//
//

#import "THConstants.h"

NSString * const kNotificationPropertyValueChanged = @"notificationPropertyValueChanged";

NSString * const kNotificationSimulationStarted = @"notificationSimulationStarted";
NSString * const kNotificationSimulationEnded = @"notificationSimulationEnded";

NSString * const kNotificationPropertiesChanged = @"notificationPropertiesChanged";

NSString * const kGameKitSessionId = @"TANGO_SESSION";
float const kWifiCellHeightCollapsed = 44;
float const kWifiCellHeightExtended = 64;

CGPoint const kiPhoneImageDistanceViewTopLeftToCenter = {20,30};

NSString * const kNotificationLedOn = @"notificationLedOn";
NSString * const kNotificationLedOff = @"notificationLedOff";

NSString * const kNotificationBuzzerOn = @"notificationBuzzerOn";
NSString * const kNotificationBuzzerOff = @"notificationBuzzerOff";

NSString * const kNotificationBuzzerFrequencyChanged = @"notificationBuzzerFrequencyChanged";
NSString * const kNotificationLedIntensityChanged = @"notificationLedIntensityChanged";

NSString * const kNotificationSwitchOn = @"switchedOn";
NSString * const kNotificationSwitchOff = @"switchedOff";

float const kMaxAnalogValue = 255;
float const kLilypadPinRadius = 21;
float const kMaxPotentiometerValue = 1023;

NSString * const kNotificationLilypadObjectAdded = @"notificationLilypadObjectAdded";
NSString * const kNotificationLilypadObjectRemoved = @"notificationLilypadObjectRemoved";

NSString * const kNotificationLilypadAdded = @"notificationLilypadAdded";
NSString * const kNotificationLilypadRemoved = @"notificationLilypadRemoved";

NSString * const kNotificationPinAttached = @"notificationPinAttached";
NSString * const kNotificationPinDeattached = @"notificationPinDeattached";

NSString * const kNotificationPinValueChanged = @"notificationPinValueChanged";

CGPoint const kLilypadDefaultPosition = {400,500};

NSString * const kPaletteNameClothes = @"clothes";
NSString * const kPaletteNameSoftware = @"software";
NSString * const kPaletteNameHardware = @"hardware";
NSString * const kPaletteNameTriggers = @"triggers";

NSString* const kPinTexts[kNumPinTypes] = {@"D", @"A", @"PWM", @"-", @"+"};
NSString * const kElementPinTexts[kNumElementPinTypes] = {@"D", @"A", @"+", @"-", @"SCL", @"SDA"};
NSString* const kPinModeTexts[kNumPinModes] = {@"D In", @"D Out",@"A In",@"PWM", @"Buzzer", @"Compass", @"Undefined"};

NSInteger const kNumPinsPerElement[kNumHardwareTypes] = {2,2,2,2,3,3,4,4};

CGPoint const kPinPositions[kNumHardwareTypes][kMaxNumPinsPerElement] = {
    {{-25,0},{25,0}},//led
    {{-24,14},{24,-14}},//buzzer
    {{-21,-18},{22,-18},{0,18}},//button
    {{-25,-18},{25,-18},{0,18}},//switch
    {{-25,-10},{0,20},{25,-10}},//potentiometer
    {{-22,-8},{0,23},{25,-8}},//light sensor
    {{-20,20},{20,20},{20,-20},{-20,-20}},//compass
    {{0,20},{-22,-7},{0,-25},{22,-7}}//three color led
};

NSInteger const kLilypadPwmPins[kLilypadNumPwmPins] = {3,5,6,9,10,11};

/*
THElementPinType const kPinTypes[kNumHardwareTypes][kMaxNumPinsPerElement] = {
    {kElementPintypeMinus,kElementPintypePin},//led
    {kElementPintypePin,kElementPintypeMinus},//buzzer
    {kElementPintypeS,kElementPintypeMinus},//button
    {kElementPintypePin,kElementPintypeMinus},//switch
    {kElementPintypePlus, kElementPintypePin, kElementPintypeMinus}//potentiometer
};
*/

CGRect const kiPhoneFrames[kNumiPhoneTypes] = {{26,99,270,404},{26,99,270,481}};

float const kUiViewOpacityEditor = 0.5f;

float const kBuzzerMaxFrequency = 20000;
float const kBuzzerMinFrequency = 20;

//events
NSString * const kEventTurnedOn = @"turnedOn";
NSString * const kEventTurnedOff = @"turnedOff";
NSString * const kEventOnChanged = @"onChanged";
NSString * const kEventIntensityChanged = @"intensityChanged";
NSString * const kEventFrequencyChanged = @"frequencyChanged";
NSString * const kEventValueChanged = @"valueChanged";
NSString * const kEventMapperValueChanged = @"mapperValueChanged";
NSString * const kEventDxChanged = @"dxChanged";
NSString * const kEventDyChanged = @"dyChanged";
NSString * const kEventLightChanged = @"lightChanged";
NSString * const kEventStartedPressing = @"startedPressing";
NSString * const kEventStoppedPressing = @"stoppedPressing";
NSString * const kEventConditionIsTrue = @"conditionTrue";
NSString * const kEventConditionIsFalse = @"conditionFalse";
NSString * const kEventXChanged = @"xChanged";
NSString * const kEventYChanged = @"yChanged";
NSString * const kEventZChanged = @"zChanged";

NSString * const kEventTapped = @"tapped";
NSString * const kEventDoubleTapped = @"doubleTapped";
NSString * const kEventScaleChanged = @"scaled";
NSString * const kEventLongPressed = @"longPressed";

NSString * const kEventHeadingChanged = @"eventHeadingChanged";

NSString * const kEventColorChanged = @"eventColorChanged";

NSString * const kEventTriggered = @"triggered";

//methods
NSString * const kMethodTurnOn = @"turnOn";
NSString * const kMethodTurnOff = @"turnOff";
NSString * const kMethodSetValue1 = @"setValue1";
NSString * const kMethodSetValue2 = @"setValue2";

NSString * const kMethodSetRed = @"setRed";
NSString * const kMethodSetGreen = @"setGreen";
NSString * const kMethodSetBlue = @"setBlue";

NSInteger const kCompassMin = 1000;
NSInteger const kAnalogInMin = 1000;

NSString * kNotifyBehaviorsText[kMaxNumNotifyBehaviors] = {@"the value will be notified always when it changed",@"the value will be notified always when it changed whithin the range", @"the value will be notified once when the range is entered"};

NSString * kSimulatorDefaultFont = @"Arial";
CGSize const kDefaultViewMinSize = {50,50};
CGSize const kDefaultViewMaxSize = {300,300};

ccColor3B const kMinusPinColor = {125,125,125};
ccColor3B const kPlusPinColor = {180,30,30};
ccColor3B const kOtherPinColor = {30,150,30};

ccColor4B const kMinusPinHighlightColor = {100,100,100,100};
ccColor4B const kPlusPinHighlightColor = {200,150,150,100};
ccColor4B const kDefaultPinHighlightColor = {100,150,100,100};

CGSize const kDefaultPinSize = {30,30};

CGSize const kiPhoneButtonDefaultSize = {100,50};

CGPoint const kDefaultiPhonePosition = {840, 430};

CGPoint const kSewedPositions[kNumHardwareTypes] = {{65,30},//led
    {60,80},//buzzer
    {65,30},//button
    {65,30},//switch
    {70,65},//potentio
    {70,65},//light
    {70,75},//compass
    {70,65}//tricolor
};
