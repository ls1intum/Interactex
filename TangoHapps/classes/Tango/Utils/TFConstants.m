/*
 * TangoFramework
 *
 * Copyright (c) 2012 Juan Haladjian
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "TFConstants.h"

float const kTabWidth = 215;

float const kPaletteSectionPadding = 5;
float const kPaletteSectionWidth = 215;

float const kGridItemWidth = 200;
float const kGridItemHeight = 230;

float const kLineAcceptedTiltingTime = 0.35f;


NSString * const kNotificationActionAdded = @"notificationActionAdded";
NSString * const kNotificationActionRemoved = @"notificationActionRemoved";

NSString * const kNotificationObjectAdded = @"notificationEntityAdded";
NSString * const kNotificationObjectRemoved = @"notificationEntityRemoved";

NSString * const kNotificationObjectSelected = @"notificationObjectSelected";
NSString * const kNotificationObjectDeselected = @"notificationObjectDeselected";

NSString * const kNotificationPaletteItemSelected = @"notificationPaletteItemSelected";
NSString * const kNotificationPaletteItemDeselected = @"notificationPaletteItemDeselected";

NSString * const kNotificationConnectionMade = @"notificationConnectionMade";


NSString * const kConnectionMadeEffect = @"connectionMade.mp3";

float kPaletteItemsPadding = 8;
float kPaletteItemSize = 60;
CGSize const kPaletteItemImageSize = {45,45};
//CGSize const kPaletteItemLabelSize = {58,10};
CGSize const kPaletteItemLabelSize = {58,25};

float const kPaletteLabelHeight = 14;
float const kPaletteItemImagePadding = 3;

float const kPaletteContainerTitleHeight = 40;

NSString * const kProjectsDirectory = @"projects";
NSString * const kProjectImagesDirectory = @"projectImages";
NSString * const kPaletteItemsDirectory = @"paletteItems";

ccColor3B const kConnectionLineDefaultColor = {30, 148, 214};
ccColor4B const kDefaultObjectHighlightColor = {200, 150, 150, 100};

float const kLineAcceptedShinningTime = 0.9f;

float const kLineWidthNormal = 1.0f;
float const kLineWidthSelected = 2.0f;

float const kDragViewDefaultOpacity = 0.8f;

float const kNavigationBarHeight = 44;


NSString* const dataTypeStrings[kNumDataTypes] = {@"boolean",@"integer", @"float",@"string", @"*"};


float const kMethodSelectionPopupRowHeight = 30;
float const kMethodSelectionPopupCharacterWidth = 13;

float const kMethodSelectionMinWidth = 110;
float const kMethodSelectionMaxWidth = 200;

float const kPopupHeaderHeight = 25;

NSInteger const kEditableObjectTableRowHeight = 30;
NSString * const kEditableObjectTableFont = @"Arial";
float const kEditableObjectTableFontSize = 13;


NSString * const kNotificationStartRemovingConnections = @"notificationStartRemovingConnections";
NSString * const kNotificationStopRemovingConnections = @"notificationStopRemovingConnections";

