//
//  THClientConstants.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/9/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THClientConstants.h"



NSString* const dataTypeStrings[kNumDataTypes] = {@"boolean",@"integer", @"float",@"string", @"*"};


NSInteger const kLilypadPwmPins[kLilypadNumPwmPins] = {3,5,6,9,10,11};

CGRect const kiPhoneFrames[kNumiPhoneTypes] = {{26,99,270,404},{26,99,270,481}};

//notifications
NSString * const kNotificationLedOn = @"notificationLedOn";
NSString * const kNotificationLedOff = @"notificationLedOff";

NSString * const kNotificationBuzzerOn = @"notificationBuzzerOn";
NSString * const kNotificationBuzzerOff = @"notificationBuzzerOff";

NSString * const kNotificationBuzzerFrequencyChanged = @"notificationBuzzerFrequencyChanged";
NSString * const kNotificationLedIntensityChanged = @"notificationLedIntensityChanged";

NSString * const kNotificationSwitchOn = @"switchedOn";
NSString * const kNotificationSwitchOff = @"switchedOff";

NSString * const kNotificationLilypadObjectAdded = @"notificationLilypadObjectAdded";
NSString * const kNotificationLilypadObjectRemoved = @"notificationLilypadObjectRemoved";

NSString * const kNotificationLilypadAdded = @"notificationLilypadAdded";
NSString * const kNotificationLilypadRemoved = @"notificationLilypadRemoved";

NSString * const kNotificationPinAttached = @"notificationPinAttached";
NSString * const kNotificationPinDeattached = @"notificationPinDeattached";
NSString * const kNotificationPinValueChanged = @"notificationPinValueChanged";

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
NSString * const kEventConditionChanged = @"conditionChanged";
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

NSString * const kGameKitSessionId = @"TANGO_SESSION";

NSString* const kPinTexts[kNumPinTypes] = {@"D", @"A", @"-", @"+"};
NSString * const kElementPinTexts[kNumElementPinTypes] = {@"D", @"A", @"+", @"-", @"SCL", @"SDA"};
NSString* const kPinModeTexts[kNumPinModes] = {@"D In", @"D Out",@"A In",@"PWM", @"Buzzer", @"Compass", @"Undefined"};


NSString * const kPaletteItemsDirectory = @"paletteItems";
NSString * const kProjectsDirectory = @"projects";
NSString * const kProjectImagesDirectory = @"projectImages";
NSString * const kProjectProxiesFileName = @"projectProxies";

float const kMaxAnalogValue = 255;
