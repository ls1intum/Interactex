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
#import "TFMethodSelectionPopup.h"

#import "TFLayer.h"
#import "TFPaletteViewControllerDelegate.h"

@class THEditorToolsViewController;
@class TFConnectionLine;
@class TFEditableObject;
@class THPaletteItem;
@class THDraggedPaletteItem;
@class THPaletteItem;

typedef enum {
    kEditorStateNormal,
    kEditorStateConnect,
    kEditorStateDelete,
    kEditorStateDuplicate
} TFEditorState;

typedef enum {
    kEditorGestureNone,
    kEditorGestureDoublePan,
    kEditorGestureScaling,
} TFGestureState;

@protocol THEditorDragDelegate <NSObject>

-(void) paletteItem:(THPaletteItem*) paletteItem didEnterPaletteAtLocation:(CGPoint) location;
-(void) paletteItemDidExitPalette:(THPaletteItem*) paletteItem;
-(void) paletteItem:(THPaletteItem*) paletteItem didMoveToLocation:(CGPoint) location;
-(void) paletteItem:(THPaletteItem*) paletteItem didDropAtLocation:(CGPoint) location;
@end

@interface THEditor : TFLayer <TFPaletteViewControllerDelegate,TFMethodSelectionPopupDelegate, THPropertySelectionPopupDelegate>{
    
    THPinEditable * _currentHighlightedPin;
    THPropertySelectionPopup * _propertySelectionPopup;
    TFMethodSelectionPopup * _methodSelectionPopup;
    
    CCSprite * dragSprite;
    
    TFGestureState gestureState;
    
    THEditorToolsViewController * _editorToolsController;
    
    THPaletteItem * _currentPaletteItem;
    CGPoint _draggedObjectPreviousPosition;
    
}

@property (nonatomic, readonly) BOOL isLilypadMode;

@property (nonatomic) float zoomLevel;
@property (nonatomic) CGPoint displacement;
@property (nonatomic) CCLayer * zoomableLayer;

@property(nonatomic) TFConnectionLine * currentConnection;
@property(nonatomic) TFEditableObject * currentObject;
@property(nonatomic) TFEditorState state;
@property(nonatomic, weak) id<THEditorDragDelegate> dragDelegate;
@property(nonatomic) BOOL removeConnections;

//lilypad mode
-(void) startLilypadMode;
-(void) stopLilypadMode;
-(void) checkPinClotheObject:(THHardwareComponentEditableObject*) clotheObject;

//object selection
-(void) unselectCurrentObject;
-(void) selectObject:(TFEditableObject*) editableObject;

-(void) handleConnectionEndedAt:(CGPoint) location;

-(void) handleIphoneVisibilityChangedTo:(BOOL) visible;

@end
