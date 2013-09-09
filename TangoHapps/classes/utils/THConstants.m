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


float const kWifiCellHeightCollapsed = 44;
float const kWifiCellHeightExtended = 64;

CGPoint const kiPhoneImageDistanceViewTopLeftToCenter = {20,30};


float const kLilypadPinRadius = 21;

CGPoint const kLilypadDefaultPosition = {400,500};

NSString * const kPaletteNameClothes = @"clothes";
NSString * const kPaletteNameSoftware = @"software";
NSString * const kPaletteNameHardware = @"hardware";
NSString * const kPaletteNameTriggers = @"triggers";

NSInteger const kNumPinsPerElement[kNumHardwareTypes] = {2,2,2,2,3,3,4,4,2};

CGPoint const kPinPositions[kNumHardwareTypes][kMaxNumPinsPerElement] = {
    {{-25,0},{25,0}},//led
    {{-24,14},{24,-14}},//buzzer
    {{-21,-18},{22,-18},{0,18}},//button
    {{-25,-18},{25,-18},{0,18}},//switch
    {{-25,-10},{0,20},{25,-10}},//potentiometer
    {{-22,-8},{0,23},{25,-8}},//light sensor
    {{-20,20},{20,20},{20,-20},{-20,-20}},//compass
    {{0,20},{-22,-7},{0,-25},{22,-7}},//three color led
    {{-22,15},{22,15}}//vibeBoard
};


float const kUiViewOpacityEditor = 0.5f;


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

ccColor3B const kWireDefaultColor = {150,50,150};
ccColor3B const kWireDefaultHighlightColor = {150,150,200};

float const kWireNodeRadius = 30.0f;

ccColor3B const kWireNodeColor = {30,30,150};

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
    {70,65},//tricolor
    {70,65}//vibeBoard
};


float const kLayerMinScale = 0.5f;
float const kLayerMaxScale = 2.5f;

