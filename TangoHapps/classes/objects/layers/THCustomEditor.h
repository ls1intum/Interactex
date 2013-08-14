//
//  THCustomEditor.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/28/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

@class THPinEditable;

@interface THCustomEditor : TFEditor {
    THPinEditable * _currentHighlightedPin;
    CCLayer * _zoomableLayer;
}

@property (nonatomic) BOOL isLilypadMode;

//lilypad mode
-(void) startLilypadMode;
-(void) stopLilypadMode;
-(void) checkPinClotheObject:(THHardwareComponentEditableObject*) clotheObject;

@end
