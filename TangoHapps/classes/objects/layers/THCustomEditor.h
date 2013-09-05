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


@interface THCustomEditor : TFEditor {
    THPinEditable * _currentHighlightedPin;
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
