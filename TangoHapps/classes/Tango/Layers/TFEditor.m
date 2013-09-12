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


#import "TFEditor.h"
#import "TFPaletteItem.h"
#import "TFEditableObject.h"
#import "TFConnectionLine.h"
#import "TFDragView.h"
#import "TFEventActionPair.h"
#import "TFMethodInvokeAction.h"

@implementation TFEditor

-(id) init{
    self = [super init];
    if(self){
        _connectionLines = [NSMutableArray array];
        self.shouldRecognizePanGestures = YES;
    }
    return self;
}

-(void) addObservers {
    id c = [NSNotificationCenter defaultCenter];
    [c addObserver:self selector:@selector(handleEditableObjectAdded:) name:kNotificationObjectAdded object:nil];
    [c addObserver:self selector:@selector(handleEditableObjectRemoved:) name:kNotificationObjectRemoved object:nil];
    [c addObserver:self selector:@selector(handleNewConnectionMade:) name:kNotificationConnectionMade object:nil];
    [c addObserver:self selector:@selector(startRemovingConnections) name:kNotificationStartRemovingConnections object:nil];
    [c addObserver:self selector:@selector(stopRemovingConnections) name:kNotificationStopRemovingConnections object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSelectionLost) name:kNotificationPaletteItemSelected object:nil];
}

#pragma mark - Event handling

-(void) startRemovingConnections{
    self.removeConnections = YES;
}

-(void) stopRemovingConnections{
    self.removeConnections = NO;
}

-(void) handleConnectionEffectFinished:(TFConnectionLine*) connection{
    [_connectionLines removeObject:connection];
}

-(void) handleNewConnectionMade:(NSNotification*) notification{
    TFConnectionLine * connection = notification.object;
    
    if(connection.shouldAnimate){
        [connection startShining];
        [_connectionLines addObject:connection];
        
        //NSBundle * bundle = [TFHelper frameworkBundle];
        //NSString * soundPath = [bundle pathForResource:kConnectionMadeEffect ofType:@""];

        [[SimpleAudioEngine sharedEngine] playEffect:kConnectionMadeEffect];
        
        [self performSelector:@selector(handleConnectionEffectFinished:) withObject:connection afterDelay:kLineAcceptedShinningTime];
    }
}

-(void) handleEditableObjectAdded:(NSNotification*) notification{
    TFEditableObject * object = notification.object;
    [object addToLayer:self];
    [self selectObject:object];
}

-(void)handleEditableObjectRemoved:(NSNotification *)notification{
    TFEditableObject * object = notification.object;
    [object removeFromLayer:self];
    
    if(object == self.currentObject){
        [self unselectCurrentObject];
    }
}

#pragma mark - Drawing

-(void) drawBoundingBoxes{
    TFProject * project = [THDirector sharedDirector].currentProject;
    
    for(TFEditableObject * object in project.allObjects){
        [TFHelper drawRect:object.boundingBox];
    }
}

-(void)drawTemporaryLine{
    
    if(_currentConnection != nil && _currentConnection.state == kConnectionStateDrawing){
        //glEnable(GL_LINE_SMOOTH);
        
        //glColor4ub(kConnectionLineDefaultColor.r,kConnectionLineDefaultColor.g,kConnectionLineDefaultColor.b,255);
        
        glLineWidth(2.0f);
        
        ccDrawLine(_currentConnection.p1, _currentConnection.p2);
        
        ccDrawCircle(_currentConnection.p1, 3, 0, 5, NO);
        ccDrawCircle(_currentConnection.p2, 3, 0, 5, NO);
        
        glLineWidth(1.0f);
        //glDisable(GL_LINE_SMOOTH);
        //glPointSize(1);
        //glColor4ub(255,255,255,255);
    }
}

-(void) drawConnectionLines{
    [TFHelper drawLines:_connectionLines];
}

-(void) draw{
    
    //ccDrawColor4F(0, 1, 0, 1);
    //ccDrawCircle(ccp(0,0), 20, 0, 10, NO);
    //ccDrawCircle(ccp(self.contentSize.width,self.contentSize.height), 20, 0, 10, NO);
    
    [self drawTemporaryLine];
    //[self drawConnectionLines];
    
    //[self drawBoundingBoxes];
}

#pragma mark - Lines

-(void) addConnectionLine:(TFConnectionLine*) connection{
    [_connectionLines addObject:connection];
}

-(void) removeConnectionLine:(TFConnectionLine*) connection{
    [_connectionLines removeObject:connection];
}

#pragma mark - Object Selection

-(void) selectObject:(TFEditableObject*) editableObject{
}

-(TFEditableObject*) objectAtPosition:(CGPoint) position{
    return nil;
}

-(void) selectObjectAtPosition:(CGPoint) position{
    
    [self unselectCurrentObject];
    
    TFEditableObject * object = [self objectAtPosition:position];
    
    if(object){
        [self selectObject:object];
    }
}

-(void) handleSelectionLost{
    
    self.currentObject.selected = NO;
    _currentObject = nil;
}

-(void) unselectCurrentObject{
    if(_currentObject){
        self.currentObject.selected = NO;
        _currentObject = nil;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationObjectDeselected object:_currentObject];
    }
}

#pragma mark - Object Connection

-(void) methodSelectionPopup:(TFMethodSelectionPopup*) popup didSelectAction:(TFMethodInvokeAction*) action forEvent:(TFEvent*) event{
    
    TFProject * project = [THDirector sharedDirector].currentProject;
    [project registerAction:(TFAction*)action forEvent:event];
    
    TFEditableObject * source = (TFEditableObject*) popup.object1;
    [source addConnectionTo:popup.object2 animated:YES];
}

-(void)startNewConnectionForObject:(TFEditableObject*) object {
    _currentConnection = [[TFConnectionLine alloc] init];
    _currentConnection.obj1 = object;
    [self moveCurrentConnection:object.center];
    _currentConnection.state = kConnectionStateDrawing;
}

-(void) showMethodSelectionPopupFor:(TFEditableObject*) object1 and:(TFEditableObject*) object2{
    if(object2 != nil && [object1 acceptsConnectionsTo:object2]){
        
        _methodSelectionPopup = [[TFMethodSelectionPopup alloc] init];
        _methodSelectionPopup.delegate = self;
        _methodSelectionPopup.object1 = (TFEditableObject*) object1;
        _methodSelectionPopup.object2 = (TFEditableObject*) object2;
        [_methodSelectionPopup present];
    }
}

#pragma mark - Input handling

-(void) moveCurrentObject:(CGPoint) d{
    
    d = ccpMult(d, 1.0f/self.scale);
    [_currentObject displaceBy:d];
}

-(void) moveLayer:(CGPoint) d{
}

-(void) checkCurrentObjectInsideOutsidePalette:(CGPoint) location{

    if(location.x < kPaletteSectionWidth){
        if(!_currentPaletteItem){
            [self handleItemEnteredPaletteAt:location];
        }
    } else {
        if(_currentPaletteItem){
            [self handleItemExitPalette];
        }
    }
}

-(void) handleMoveFinishedAt:(CGPoint) location{
    if(location.x < kPaletteSectionWidth){
        [self handleItemDroppedInPaletteAt:location];
    }
}

-(void)moveCurrentConnection:(CGPoint)position {
    _currentConnection.p2 = position;
}

-(void) handleConnectionStartedAt:(CGPoint) location{

}

-(void) handleConnectionEndedAt:(CGPoint) location{
    
    _currentConnection = nil;
}

-(TFEditableObject*) duplicateObjectAtLocation:(CGPoint) location{
    
    TFProject * project = [THDirector sharedDirector].currentProject;
    TFEditableObject * object = [project objectAtLocation:location];
    
    TFEditableObject * copy;
    if(object.canBeDuplicated){
        copy = [object copy];
        [copy addToWorld];
    }
    return copy;
}

-(void) handleSingleTouchMove:(UIPanGestureRecognizer*) sender{

    CGPoint location = [sender locationInView:sender.view];
    location = [self toLayerCoords:location];
    
    if(_state == kEditorStateConnect){
        
        if(sender.state == UIGestureRecognizerStateBegan){
            
            [self handleConnectionStartedAt:location];
            
        } else if(_currentConnection.state == kConnectionStateDrawing) {
            
            [self moveCurrentConnection:location];
            
        }
        
    } else if(_state == kEditorStateDuplicate) {
        
        if(sender.state == UIGestureRecognizerStateBegan){

            TFEditableObject * copy = [self duplicateObjectAtLocation:location];
            [self selectObject:copy];
            
        } else if(sender.state == UIGestureRecognizerStateChanged){
            
            CGPoint d = [sender translationInView:sender.view];
            d.y = - d.y;
            [self moveCurrentObject:d];
            [sender setTranslation:ccp(0,0) inView:sender.view];
        }
    } else {
        
        if (sender.state == UIGestureRecognizerStateBegan) {
            
            [self selectObjectAtPosition:location];
            _draggedObjectPreviousPosition = location;
            
        } else if(sender.state == UIGestureRecognizerStateChanged){
            
            CGPoint d = [sender translationInView:sender.view];
            d.y = - d.y;
            
            if(self.currentObject){
                
                [self moveCurrentObject:d];
                [self checkCurrentObjectInsideOutsidePalette:location];
                
            } else if(_currentPaletteItem){
                
                [self handleItemInPaletteMovedTo:location];
                
            } else {
                
                [self moveLayer:d];
            }
            
            [sender setTranslation:ccp(0,0) inView:sender.view];
        }
    }
}

-(void) move:(UIPanGestureRecognizer*)sender{
    if(!self.shouldRecognizePanGestures) return;
    
    if(sender.numberOfTouches == 1){
        if(gestureState == kEditorGestureNone){
            [self handleSingleTouchMove:sender];
        }
    } else if(sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled){
        gestureState = kEditorGestureNone;
        if(self.state == kEditorStateConnect){
            if(_currentConnection != nil && _currentConnection.state == kConnectionStateDrawing){
                CGPoint location = [sender locationInView:sender.view];
                location = [self toLayerCoords:location];
                [self handleConnectionEndedAt:location];
            }
        } else if(self.state == kEditorStateNormal) {
            
            CGPoint location = [sender locationInView:sender.view];
            location = [self toLayerCoords:location];
            [self handleMoveFinishedAt:location];
        }
    }
}

-(void)tapped:(UITapGestureRecognizer*)sender {
    
    CGPoint location = [sender locationInView:sender.view];
    location = [self toLayerCoords:location];
    
    if(self.removeConnections){
        
        TFProject * project = [THDirector sharedDirector].currentProject;
        
        TFEditableObject * object = [project objectAtLocation:location];
        NSArray * actions = [project actionsForTarget:object];
        NSMutableArray * toRemove = [NSMutableArray array];
        
        for (TFEventActionPair * pair in actions) {
            TFMethodInvokeAction * action = (TFMethodInvokeAction*) pair.action;
            if(action.source == self.currentObject){
                [toRemove addObject:action];
            }
        }
        
        for (TFAction * action in toRemove) {
            [project deregisterAction:action];
        }
        
        [self.currentObject removeAllConnectionsTo:object];
        object.highlighted = NO;
        
        
    } else if(_state == kEditorStateDelete){
        
        TFProject * project = [THDirector sharedDirector].currentProject;
        TFEditableObject * object = [project objectAtLocation:location];
        if(object){
            if(self.currentObject == object){
                [self unselectCurrentObject];
            }
            [object removeFromWorld];
        }
    } else {
        [self selectObjectAtPosition:location];
    }
}

#pragma mark - Layer lifecycle

-(void) addTools{
    
    //[[[CCDirector sharedDirector] openGLView] addSubview:_editorToolsController.view];
}

-(void) removeTools{
    //[_editorToolsController.view removeFromSuperview];
}

-(void) prepareObjectsForEdition{
    
    TFProject * project = [THDirector sharedDirector].currentProject;
    [project prepareForEdition];
}

-(void) willAppear{
    
    [super willAppear];
    
    [self prepareObjectsForEdition];
    [self addTools];
    [self addObservers];
}

-(void) willDisappear{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self unselectCurrentObject];
    [self removeTools];

    [super willDisappear];
}

#pragma mark - Drags from palette

-(void)paletteItem:(TFDragView*)item beganDragAt:(CGPoint) location {
    item.center = location;
    [item addToView:[CCDirector sharedDirector].view];
}

-(void)paletteItem:(TFDragView*)item movedTo:(CGPoint)location {
    item.center = location;
    
    if(item.state != kPaletteItemStateDroppable && [item canBeDroppedAt:location]){
        item.state = kPaletteItemStateDroppable;
    } else if(item.state != kPaletteItemStateNormal && ![item canBeDroppedAt:location]){
        item.state = kPaletteItemStateNormal;
    }
}

-(void)paletteItem:(TFDragView*)item endedAt:(CGPoint) location{
    [dragSprite removeFromParentAndCleanup:YES];
    dragSprite = nil;
}

#pragma mark - Drags into palette

-(void) handleItemEnteredPaletteAt:(CGPoint) location{
        
    _currentPaletteItem = [self.currentObject paletteItem];
    [self.dragDelegate paletteItem:_currentPaletteItem didEnterPaletteAtLocation:location];
    
    self.currentObject.position = _draggedObjectPreviousPosition;
    [self unselectCurrentObject];
}

-(void) handleItemDroppedInPaletteAt:(CGPoint) location{
    if(_currentPaletteItem){
        [self.dragDelegate paletteItem:_currentPaletteItem didDropAtLocation:location];
        _currentPaletteItem = nil;
        self.currentObject.position = _draggedObjectPreviousPosition;
    }
}

-(void) handleItemInPaletteMovedTo:(CGPoint) location{
    [self.dragDelegate paletteItem:_currentPaletteItem didMoveToLocation:location];
}

-(void) handleItemExitPalette{
    
    [self.dragDelegate paletteItemDidExitPalette:_currentPaletteItem];
    _currentPaletteItem = nil;
}

#pragma mark - Dealloc

-(NSString*) description{
    return @"CustomEditor";
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([@"YES" isEqualToString: [[[NSProcessInfo processInfo] environment] objectForKey:@"printUIDeallocs"]]) {
        NSLog(@"deallocing %@",self);
    }
}

@end
