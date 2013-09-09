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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString * const kNotificationActionAdded;
extern NSString * const kNotificationActionRemoved;

extern float const kTabWidth;

extern float const kPaletteSectionPadding;
extern float const kPaletteSectionWidth;

extern float const kGridItemWidth;
extern float const kGridItemHeight;
extern float const kLineAcceptedTiltingTime;

extern NSString * const kNotificationObjectAdded;
extern NSString * const kNotificationObjectRemoved;

extern NSString * const kNotificationObjectSelected;
extern NSString * const kNotificationObjectDeselected;

extern NSString * const kNotificationPaletteItemSelected;
extern NSString * const kNotificationPaletteItemDeselected;

extern NSString * const kNotificationConnectionMade;

extern NSString * const kConnectionMadeEffect;

extern float kPaletteItemsPadding;
extern float kPaletteItemSize;
extern CGSize const kPaletteItemImageSize;
extern CGSize const kPaletteItemLabelSize;

extern float const kPaletteLabelHeight;

extern float const kPaletteItemImagePadding;

extern float const kPaletteContainerTitleHeight;

extern ccColor3B const kConnectionLineDefaultColor;
extern ccColor4B const kDefaultObjectHighlightColor;
extern ccColor4B const kDefaultObjectSelectionColor;

enum TFZOrders{
    kTFDefaultZ = -20
};

extern float const kLineAcceptedShinningTime;
extern float const kLineWidthNormal;
extern float const kLineWidthSelected;

extern float const kDragViewDefaultOpacity;

extern float const kNavigationBarHeight;


extern float const kMethodSelectionPopupRowHeight;
extern float const kMethodSelectionPopupCharacterWidth;

extern float const kMethodSelectionMinWidth;
extern float const kMethodSelectionMaxWidth;

extern float const kPopupHeaderHeight;


extern NSInteger const kEditableObjectTableRowHeight;
extern NSString * const kEditableObjectTableFont;
extern float const kEditableObjectTableFontSize;


typedef enum {
    kAppStateEditor,
    kAppStateSimulator
} TFAppState;

extern NSString * const kNotificationStartRemovingConnections;
extern NSString * const kNotificationStopRemovingConnections;