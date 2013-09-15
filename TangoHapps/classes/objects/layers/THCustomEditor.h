//
//  THCustomEditor.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/28/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

@class THPinEditable;
@class THBoardPinEditable;
@class THElementPinEditable;

#import "THPropertySelectionPopup.h"

@interface THCustomEditor : TFEditor <THPropertySelectionPopupDelegate>{
    THPinEditable * _currentHighlightedPin;
    
    THPropertySelectionPopup * _propertySelectionPopup;
}

@property (nonatomic, readonly) BOOL isLilypadMode;

@property (nonatomic) float zoomLevel;
@property (nonatomic) CGPoint displacement;
@property (nonatomic) CCLayer * zoomableLayer;

//lilypad mode
-(void) startLilypadMode;
-(void) stopLilypadMode;
-(void) checkPinClotheObject:(THHardwareComponentEditableObject*) clotheObject;

@end
