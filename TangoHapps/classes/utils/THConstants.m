/*
THConstants.m
Interactex Designer

Created by Juan Haladjian on 05/10/2013.

Interactex Designer is a configuration tool to easily setup, simulate and connect e-Textile hardware with smartphone functionality. Interactex Client is an app to store and replay projects made with Interactex Designer.

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
The first version of the software was designed and implemented as part of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was founded by Telekom Innovation Laboratories Berlin. It has been extended with funding from EIT ICT, as part of the activity "Connected Textiles".

Interactex is built using the Tango framework developed by TU Munich.

In the Interactex software, we use the GHUnit (a test framework for iOS developed by Gabriel Handford) and cocos2D libraries (a framework for building 2D games and graphical applications developed by Zynga Inc.). 
www.cocos2d-iphone.org
github.com/gabriel/gh-unit

Interactex also implements the Firmata protocol. Its software serial library is based on the original Arduino Firmata library.
www.firmata.org

All hardware part graphics in Interactex Designer are reproduced with kind permission from Fritzing. Fritzing is an open-source hardware initiative to support designers, artists, researchers and hobbyists to work creatively with interactive electronics.
www.frizting.org

Martijn ten Bhömer from TU Eindhoven contributed PureData support. Contact: m.t.bhomer@tue.nl.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

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

NSInteger const kNumPinsPerElement[kNumHardwareTypes] = {
    2,//led
    2,//buzzer
    2,//button
    2,//switch
    3,//5 - potentiometer
    3,//light sensor
    4,//lsm compass
    4,//3-color-led
    2,//vibeBoard
    3,//10 - temperature sensor
    5,//accelerometer
    4,//mpu compass
    3,//textile sensor
    4,//textile speaker
    2//proximity sensor
};

CGPoint const kPinPositions[kNumHardwareTypes][kMaxNumPinsPerElement] = {
    {{-25,0},{25,0}},//led
    {{-24,14},{24,-14}},//buzzer
    {{-43,0},{-7,0},{49,0}},//button
    {{-50,0},{-3,0},{57,0}},//switch
    
    {{-47,-72},{-1,-86},{43,-74}},//5 - potentiometer
    
    {{-23,-12},{0,26},{25,-12}},//light sensor
    {{32,-4},{32,-13},{-32,13},{-32,4}},//lsm compass
    {{0,26},{-26,-12},{26,-12},{0,-26}},//three color led
    {{-24,15},{24,15}},//vibeBoard
    {{-23,-12},{0,26},{25,-12}},//10 - temperature sensor
    {{1,-29},{-24,10},{1,25},{25,11},{25,-15}},//accelerometer
    {{-24,24},{-24,32},{-24,15},{-24,6}},//mpu compass
    {{-1,-29},{0,28},{0,0}},//textile sensor
    {{0,30},{0,0},{-15,-30},{15,-30}},//textile speaker
    {{-37,7},{37,7}},//proximity sensor
};

float const kUiViewOpacityEditor = 0.5f;

NSInteger const kCompassMin = 1000;
NSInteger const kAnalogInMin = 1000;

NSString * kNotifyBehaviorsText[kMaxNumNotifyBehaviors] = {@"the potentiometer's value will be notified always when it changes", @"the potentiometer's value will be notified always when it changes whithin the range you specify below", @"the potentiometer's value will be notified once after it enters the range you specify below"};

NSString * kSimulatorDefaultBoldFont = @"Arial Rounded MT Bold";
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
ccColor3B const kWireNodeSelectedColor = {150,30,30};

CGSize const kDefaultPinSize = {30,30};

CGSize const kiPhoneButtonDefaultSize = {100,50};

CGPoint const kDefaultiPhonePosition = {858, 340}; // nazmus added: 1024-(iphone5 width/2)- 6 padding, 768-(iphone5 height/2)- 6 padding - 44 navigation bar height - 64 menubar height - 24 statusbar
float const kiPhoneBgPadding = 6.0f; // nazmus added

CGPoint const kSewedPositions[kNumHardwareTypes] = {{65,30},//led
    {60,80},//buzzer
    {65,30},//button
    {65,30},//switch
    {70,65},//potentio
    {70,65},//light
    {70,75},//compass
    {70,65},//tricolor
    {70,65},//vibeBoard
    {70,65},//temperature sensor
    {70,65},//accelerometer
    {70,65},//proximity sensor
};

NSString * const kHardwareSpriteNames[kNumHardwareTypes] = {
    @"led.png",
    @"buzzer.png",
    @"button.png",
    @"switch.png",
    @"potentiometer.png",
    @"lightSensor.png",
    @"LSMCompass.png",
    @"threeColorLed.png",
    @"vibeBoard.png",
    @"temperatureSensor.png",
    @"accelerometer.png",
    @"MPU-6050.png",
    @"textileSensor.png",
    @"textileSpeaker.png",
    @"proximitySensor.png"
};

NSString * const kProgrammingElementSpriteNames[kNumProgrammingElementTypes] = {
    @"mapper.png",
    @"value.png",
    @"value.png",
    @"value.png",
    @"sound.png",
    @"timer.png",
    @"comparator.png",
    @"grouper.png",
    @"mean.png",
    @"deviation.png",
    @"activityClassifier.png",
    @"postureClassifier.png",
    @"peakDetector.png",
    @"customComponent.png",
    @"recorder.png",
    @"addition.png",
    @"subtraction.png",
    @"multiplication.png",
    @"division.png",
    @"modulo.png",//20
    @"window.png",
    @"lowPassFilter.png",
    @"highPassFilter.png",
    @"bigger.png",
    @"smaller.png",//25
    @"biggerEqual.png",
    @"smallerEqual.png",
    @"equal.png",
    @"notEqual.png",
    @"and.png",//30
    @"or.png"
};

float const kLayerMinScale = 0.5f;
float const kLayerMaxScale = 2.5f;

float const kDefaultAnalogSimulationIncrease = 5.0f;

ccColor3B const kDefaultSimulationLabelColor = {0,0,0};//black

NSString * const kNotificationEditorZoomReset = @"notificationEditorZoomReset";

NSString * const kCustomComponentPaletteName = @"palette_customComponent.png";

CGSize const kDefaultCanvasSize = {3072, 2304};

