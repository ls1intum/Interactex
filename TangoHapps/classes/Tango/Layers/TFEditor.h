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
#import "TFLayer.h"
#import "TFPaletteViewControllerDelegate.h"
#import "TFMethodSelectionPopup.h"

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

@protocol TFEditorDragDelegate <NSObject>

-(void) paletteItem:(THPaletteItem*) paletteItem didEnterPaletteAtLocation:(CGPoint) location;
-(void) paletteItemDidExitPalette:(THPaletteItem*) paletteItem;
-(void) paletteItem:(THPaletteItem*) paletteItem didMoveToLocation:(CGPoint) location;
-(void) paletteItem:(THPaletteItem*) paletteItem didDropAtLocation:(CGPoint) location;
@end

@interface TFEditor : TFLayer <TFPaletteViewControllerDelegate,TFMethodSelectionPopupDelegate>{
    
    CCSprite * dragSprite;
    
    TFGestureState gestureState;
    
    NSMutableArray * _connectionLines;
    
    THEditorToolsViewController * _editorToolsController;
    
    TFMethodSelectionPopup * _methodSelectionPopup;
    
    THPaletteItem * _currentPaletteItem;
    CGPoint _draggedObjectPreviousPosition;
}

@property(nonatomic, readonly) TFConnectionLine * currentConnection;
@property(nonatomic) TFEditableObject * currentObject;
@property(nonatomic) TFEditorState state;
@property(nonatomic, weak) id<TFEditorDragDelegate> dragDelegate;
@property(nonatomic) BOOL removeConnections;

//object selection
-(void) unselectCurrentObject;
-(void) selectObject:(TFEditableObject*) editableObject;

//lines
-(void) addConnectionLine:(TFConnectionLine*) connection;
-(void) removeConnectionLine:(TFConnectionLine*) connection;

-(void) startNewConnectionForObject:(TFEditableObject*) object;
-(void) handleConnectionEndedAt:(CGPoint) location;
-(void) showMethodSelectionPopupFor:(TFEditableObject*) object1 and:(TFEditableObject*) object2;
-(void) handleNewConnectionMade:(NSNotification*) notification;

@end
