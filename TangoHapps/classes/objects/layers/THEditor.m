//
//  THCustomEditor.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/28/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

#import "THEditor.h"
#import "THPinEditable.h"
#import "THHardwareComponentEditableObject.h"
#import "THLilypadEditable.h"
#import "THElementPinEditable.h"
#import "THBoardPinEditable.h"
#import "THClothe.h"
#import "THViewEditableObject.h"
#import "THiPhoneEditableObject.h"
#import "THiPhone.h"
#import "THConditionEditableObject.h"
#import "THLilypadEditable.h"
#import "THNumberValueEditable.h"
#import "THTimerEditable.h"
#import "THActionEditable.h"
#import "THWire.h"
#import "THTabbarViewController.h"
#import "THProjectViewController.h"
#import "THPaletteViewController.h"
#import "THInvocationConnectionLine.h"
#import "THPropertySelectionPopup.h"
#import "TFEventActionPair.h"
#import "THDraggedPaletteItem.h"

@implementation THEditor

-(id) init{
    
    self = [super init];
    if(self){
        self.shouldRecognizePanGestures = YES;
        _zoomableLayer = [CCLayer node];
        [self addChild:_zoomableLayer z:-10];
        
        [self showAllPaletteSections];
    }
    return self;
}

-(void) addObservers {
    id c = [NSNotificationCenter defaultCenter];
    [c addObserver:self selector:@selector(handleEditableObjectAdded:) name:kNotificationObjectAdded object:nil];
    [c addObserver:self selector:@selector(handleEditableObjectRemoved:) name:kNotificationObjectRemoved object:nil];
    //[c addObserver:self selector:@selector(handleNewConnectionMade:) name:kNotificationConnectionMade object:nil];
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

-(void) drawObjectsConnections {
    
    [TFHelper drawLines:self.currentObject.connections];
    
    THProject * project = [THDirector sharedDirector].currentProject;
    
    if(self.state == kEditorStateConnect){
        [TFHelper drawLinesForObjects:project.allObjects];
    }
}

-(void) drawBoundingBoxes{
    THProject * project = [THDirector sharedDirector].currentProject;
    
    for(TFEditableObject * object in project.allObjects){
        [TFHelper drawRect:object.boundingBox];
    }
}

-(void)drawTemporaryLine{
    
    if(_currentConnection != nil && _currentConnection.state == kConnectionStateDrawing){
        
        ccDrawColor4B(kConnectionLineDefaultColor.r,kConnectionLineDefaultColor.g,kConnectionLineDefaultColor.b,255);
        
        glLineWidth(2.0f);
        
        ccDrawLine(_currentConnection.p1, _currentConnection.p2);
        
        ccDrawCircle(_currentConnection.p1, 3, 0, 5, NO);
        ccDrawCircle(_currentConnection.p2, 3, 0, 5, NO);
        
        glLineWidth(1.0f);
        ccDrawColor4B(255,255,255,255);
    }
}

-(void) draw{
    /*
    if(!self.isLilypadMode){
        
        [self drawObjectsConnections];
    }*/
    
    [self drawTemporaryLine];
}

#pragma mark - Methods

//iphone object
-(void) addIphoneObject:(THViewEditableObject*) object{
    
    [object willStartEdition];
    [self addChild:object z:object.z];
}

-(void) removeiPhoneObject:(THViewEditableObject*) object{
    
    [object removeFromParentAndCleanup:YES];
}

-(THWireNode*) wireNodeAtPosition:(CGPoint) position{
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    for (THWire * wire in project.wires) {
        THWireNode * node = [wire nodeAtPosition:position];
        if(node){
            return node;
        }
    }
    
    return nil;
}

-(TFEditableObject*) objectAtPosition:(CGPoint) position{
    
    THProject * project = [THDirector sharedDirector].currentProject;
    
    TFEditableObject * object;
    
    if(self.isLilypadMode){
        object = [self wireNodeAtPosition:position];
    }
    
    if(!object){
        object = [project objectAtLocation:position];
    }
    
    return object;
}

#pragma mark - Pin highlighting

-(void) highlightPin:(THPinEditable*) pin{
    
    if(_currentHighlightedPin != nil){
        _currentHighlightedPin.highlighted = NO;
    }
    _currentHighlightedPin = pin;
    _currentHighlightedPin.highlighted = YES;
}

-(void) dehighlightCurrentPin{
    
    _currentHighlightedPin.highlighted = NO;
    _currentHighlightedPin = nil;
}

#pragma mark - Object Selection

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
        
        if(self.state != kEditorStateConnect){
            [self hideConnectionsForCurrentObject];
        }
        
        _currentObject = nil;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationObjectDeselected object:_currentObject];
    }
}

-(void) selectObject:(TFEditableObject*) editableObject{
    
    [self unselectCurrentObject];
    
    editableObject.selected = YES;
    self.currentObject = editableObject;
    
    [self showConnectionsForCurrentObject];
    
    if([editableObject isKindOfClass:[THWireNode class]]){
        
        THWireNode * node = (THWireNode*) editableObject;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationObjectSelected object:node.wire];
        
    } else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationObjectSelected object:editableObject];
    }
}

#pragma mark - Connection

-(void) connectElementPinToLilypad:(THElementPinEditable*) objectPin at:(CGPoint) position{
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    THLilyPadEditable * lilypad = project.lilypad;
    THBoardPinEditable * lilypadPin = [lilypad pinAtPosition:position];
    
    if([objectPin acceptsConnectionsTo:lilypadPin]){
        [lilypadPin attachPin:objectPin];
        [objectPin attachToPin:lilypadPin animated:YES];
        [project addWireFrom:objectPin to:lilypadPin];
    }
}

-(void) moveCurrentConnection:(CGPoint)position {
    
    self.currentConnection.p2 = position;
    if(self.isLilypadMode){
        
        THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
        
        if([project.lilypad testPoint:position]){
            
            THBoardPinEditable * pin = [project.lilypad pinAtPosition:position];
            if(pin != nil && [self.currentConnection.obj1 acceptsConnectionsTo:pin]){
                [self highlightPin:pin];
            } else {
                [self dehighlightCurrentPin];
            }
            
        } else {
            
            THHardwareComponentEditableObject * clotheObject = [project clotheObjectAtLocation:position];
            
            if(clotheObject){
                THElementPinEditable * pin = [clotheObject pinAtPosition:position];
                if(pin != nil && [self.currentConnection.obj1 acceptsConnectionsTo:pin]){
                    [self highlightPin:pin];
                } else {
                    [self dehighlightCurrentPin];
                }
            } else {
                [self dehighlightCurrentPin];
            }
        }
    }
}

#pragma mark - Property Selection Popup

-(void) propertySelectionPopup:(THPropertySelectionPopup*) popup didSelectProperty:(TFProperty*) property{
    
    popup.connection.state = THInvocationConnectionLineStateComplete;
    popup.connection.action.firstParam = [TFPropertyInvocation invocationWithProperty:property target:popup.object];
    [popup.connection reloadSprite];
}

-(void) attachObject:(TFEditableObject*) object toInvocationParameter:(THInvocationConnectionLine*) connectionLine{
    if(object != nil){
        
        _propertySelectionPopup = [[THPropertySelectionPopup alloc] init];
        _propertySelectionPopup.delegate = self;
        _propertySelectionPopup.object = object;
        _propertySelectionPopup.connection = connectionLine;
        [_propertySelectionPopup present];
    }
}


#pragma mark - Method Selection Popup

-(void) methodSelectionPopup:(TFMethodSelectionPopup*) popup didSelectAction:(TFMethodInvokeAction*) action forEvent:(TFEvent*) event{
    
    [[SimpleAudioEngine sharedEngine] playEffect:kConnectionMadeEffect];
    
    THProject * project = [THDirector sharedDirector].currentProject;
    [project registerAction:(TFAction*)action forEvent:event];
    
    THInvocationConnectionLine * invocationConnection = [[THInvocationConnectionLine alloc] initWithObj1:popup.object1  obj2:popup.object2];
    invocationConnection.action = action;
    invocationConnection.numParameters = action.method.numParams;
    
    if(action.method.numParams > 0){
        
        if(event.param1 && [action.method acceptsParemeterOfType:event.param1.property.type]){
            
            invocationConnection.state = THInvocationConnectionLineStateComplete;
            invocationConnection.action.firstParam = event.param1;
        }
        
        invocationConnection.parameterType = action.method.firstParamType;
        [invocationConnection reloadSprite];
    }
    
    [project addInvocationConnection:invocationConnection animated:YES];
    
}

-(void)startNewConnectionForObject:(TFEditableObject*) object {
    self.currentConnection = [[TFConnectionLine alloc] init];
    self.currentConnection.obj1 = object;
    [self moveCurrentConnection:object.center];
    self.currentConnection.state = kConnectionStateDrawing;
}

-(void) showMethodSelectionPopupFor:(TFEditableObject*) object1 and:(TFEditableObject*) object2{
    if(object2 != nil){
        
        _methodSelectionPopup = [[TFMethodSelectionPopup alloc] init];
        _methodSelectionPopup.delegate = self;
        _methodSelectionPopup.object1 = (TFEditableObject*) object1;
        _methodSelectionPopup.object2 = (TFEditableObject*) object2;
        [_methodSelectionPopup present];
    }
}


#pragma mark - Connecting

-(void) handleConnectionEndedAt:(CGPoint) location{
    
    THProject * project = [THDirector sharedDirector].currentProject;
    TFEditableObject * object2 = [project objectAtLocation:location];
    TFEditableObject * object1 = self.currentConnection.obj1;

    if(self.isLilypadMode){
        if([object1 isKindOfClass:[THElementPinEditable class]]){
            THElementPinEditable * objectPin = (THElementPinEditable*) object1;
            if([object2 isKindOfClass:[THLilyPadEditable class]]){
                [self connectElementPinToLilypad:objectPin at:location];
            }
        } /*else if([object1 isKindOfClass:[THResistorExtension class]]){
            THResistorExtension * extension = (THResistorExtension*) object1;
            if([object2 isKindOfClass:[THLilyPadEditable class]]){
                THElementPinEditable * objectPin = extension.pin;
                [self connectElementPinToLilypad:objectPin at:location];
            }
        }*/
        
        [self dehighlightCurrentPin];
        
    } else if([object2 isKindOfClass:[THInvocationConnectionLine class]]){
        
        [self attachObject:object1 toInvocationParameter:(THInvocationConnectionLine*) object2];
        
    } else {
        [self showMethodSelectionPopupFor:object1 and:object2];
    }
    
    _currentConnection = nil;
}

-(void) handleConnectionStartedAt:(CGPoint) location{
    THProject * project = [THDirector sharedDirector].currentProject;
    TFEditableObject * object = [project objectAtLocation:location];
    if(self.isLilypadMode){
        THHardwareComponentEditableObject * obj = (THHardwareComponentEditableObject*) object;
        
        if([obj isKindOfClass:[THHardwareComponentEditableObject class]]){
            THElementPinEditable * object1 = [obj pinAtPosition:location];
            
            if(object1 != nil){
                [self startNewConnectionForObject:object1];
            }
        }
    } else {
        if(object != nil && object.acceptsConnections){
            [self startNewConnectionForObject:object];
        }
    }
}

#pragma mark - Copying

-(TFEditableObject*) duplicateObjectAtLocation:(CGPoint) location{
    
    THProject * project = [THDirector sharedDirector].currentProject;
    TFEditableObject * object = [project objectAtLocation:location];
    
    TFEditableObject * copy;
    if(object.canBeDuplicated){
        copy = [object copy];
        [copy addToWorld];
    }
    return copy;
}

#pragma mark - Moving

-(void) moveCurrentObject:(CGPoint) d{
    if(self.currentObject.canBeMoved){
        if((self.currentObject.parent == self.zoomableLayer) || (self.currentObject.parent.parent == self.zoomableLayer)){
            d = ccpMult(d, 1.0f/_zoomableLayer.scale);
        }
        
        [self.currentObject displaceBy:d];
    }
}

-(void) moveLayer:(CGPoint) d{
    self.zoomableLayer.position = ccpAdd(self.zoomableLayer.position, d);
    //self.position = ccpAdd(self.position, d);
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
        
        THProject * project = [THDirector sharedDirector].currentProject;
        
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
        
        [project removeAllConnectionsFrom:self.currentObject to:object];
        //[self.currentObject removeAllConnectionsTo:object];
        
        object.highlighted = NO;
        
        
    } else if(_state == kEditorStateDelete){
        
        THProject * project = [THDirector sharedDirector].currentProject;
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


-(void) setZoomLevel:(float)zoomLevel{
    self.zoomableLayer.scale = zoomLevel;
}

-(float) zoomLevel{
    return self.zoomableLayer.scale;
}

-(void) setDisplacement:(CGPoint)displacement{
    self.zoomableLayer.position = displacement;
}

-(CGPoint) displacement{
    return self.zoomableLayer.position;
}

-(void)scale:(UIPinchGestureRecognizer*)sender{
    
    CGPoint location = [sender locationInView:sender.view];
    location = [self toLayerCoords:location];
    
    THProject * project = [THDirector sharedDirector].currentProject;
    TFEditableObject * object = [project objectAtLocation:location];
    
    if(object && [object isKindOfClass:[THClothe class]]){
        [object scaleBy:sender.scale];
    } else {
        float newScale = self.zoomableLayer.scale * sender.scale;
        if(newScale > kLayerMinScale && newScale < kLayerMaxScale){
            self.zoomableLayer.scale = newScale;
        }
    }
    sender.scale = 1.0f;
}

-(void) checkPinClotheObject:(THHardwareComponentEditableObject*) clotheObject{
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    THClothe * clothe = [project clotheAtLocation:clotheObject.position];
    if(clothe != nil){
        [project pinClotheObject:clotheObject toClothe:clothe];
        [[SimpleAudioEngine sharedEngine] playEffect:@"sewed.mp3"];
    }
}

-(void) checkUnPinClotheObject:(THHardwareComponentEditableObject*) clotheObject{
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    THClothe * clothe = [project clotheAtLocation:clotheObject.position];
    if(clothe != nil){
        [project unpinClotheObject:clotheObject];
        [[SimpleAudioEngine sharedEngine] playEffect:@"sewed.mp3"];
    }
}

-(void) doubleTapped:(UITapGestureRecognizer*)sender{
    
    CGPoint location = [sender locationInView:sender.view];
    location = [self toLayerCoords:location];
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    THHardwareComponentEditableObject * clotheObject = [project clotheObjectAtLocation:location];
    if(clotheObject){
        if(clotheObject.attachedToClothe){
            [self checkUnPinClotheObject:clotheObject];
        } else {
            [self checkPinClotheObject:clotheObject];
        }
    } else {
        _zoomableLayer.scale = 1.0f;
        //self.position = ccp(0,0);
        _zoomableLayer.position = ccp(0,0);
    }
    
    [super doubleTapped:sender];
}


#pragma mark - Drags from palette

-(void)paletteItem:(THDraggedPaletteItem*)item beganDragAt:(CGPoint) location {
    item.center = location;
    [item addToView:[CCDirector sharedDirector].view];
}

-(void)paletteItem:(THDraggedPaletteItem*)item movedTo:(CGPoint)location {
    item.center = location;
    
    if(item.state != kPaletteItemStateDroppable && [item canBeDroppedAt:location]){
        item.state = kPaletteItemStateDroppable;
    } else if(item.state != kPaletteItemStateNormal && ![item canBeDroppedAt:location]){
        item.state = kPaletteItemStateNormal;
    }
}

-(void)paletteItem:(THDraggedPaletteItem*)item endedAt:(CGPoint) location{
    [dragSprite removeFromParentAndCleanup:YES];
    dragSprite = nil;
}

#pragma mark - Drags into palette

-(void) checkCurrentObjectInsideOutsidePalette:(CGPoint) location{
    
    CGRect paletteFrame = [THHelper paletteFrame];
    float paletteRightX = paletteFrame.origin.x + paletteFrame.size.width;
    
    if(self.currentObject.canBeAddedToPalette){
        if(location.x < paletteRightX){
            if(!_currentPaletteItem){
                [self handleItemEnteredPaletteAt:location];
            }
        } else {
            if(_currentPaletteItem){
                [self handleItemExitPalette];
            }
        }
    }
}

-(void) handleMoveFinishedAt:(CGPoint) location{
    CGRect paletteFrame = [THHelper paletteFrame];
    float paletteRightX = paletteFrame.origin.x + paletteFrame.size.width;
    
    if(location.x < paletteRightX){
        [self handleItemDroppedInPaletteAt:location];
    }
}

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

#pragma mark - Showing / Hiding Connections

-(void) handleIphoneVisibilityChangedTo:(BOOL) visible{
    THProject * project = [THDirector sharedDirector].currentProject;
    
    //unselect iphone object
    if(!visible){
        if([THHelper isUIObject:self.currentObject]){
            [self unselectCurrentObject];
        }
    }
    
    for (THInvocationConnectionLine * connection in project.invocationConnections) {
        if([THHelper isUIObject:connection.obj1] || [THHelper isUIObject:connection.obj2]){
            connection.visible = visible;
        }
    }
}

-(void) showConnectionsForCurrentObject{
    THProject * project = [THDirector sharedDirector].currentProject;
    NSArray * connections = [project invocationConnectionsForObject:self.currentObject];
    
    for (THInvocationConnectionLine * connection in connections) {
        connection.visible = YES;
    }
}

-(void) hideConnectionsForCurrentObject{
    THProject * project = [THDirector sharedDirector].currentProject;
    NSArray * connections = [project invocationConnectionsForObject:self.currentObject];
    
    for (THInvocationConnectionLine * connection in connections) {
        connection.visible = NO;
    }
}

-(void) showConnectionsForAllObjects{
    THProject * project = [THDirector sharedDirector].currentProject;
    for (THInvocationConnectionLine * connection in project.invocationConnections) {
        connection.visible = YES;
    }
}

-(void) hideConnectionsForAllObjectsButCurrent{
    THProject * project = [THDirector sharedDirector].currentProject;
    for (THInvocationConnectionLine * connection in project.invocationConnections) {
        if(connection.obj1 != self.currentObject){
            connection.visible = NO;
        }
    }
}

-(void) hideConnectionsForAllObjects{
    THProject * project = [THDirector sharedDirector].currentProject;
    for (THInvocationConnectionLine * connection in project.invocationConnections) {
        connection.visible = NO;
    }
}

-(void) setState:(TFEditorState)state{
    if(_state != state){
        if(_state == kEditorStateConnect){
            [self hideConnectionsForAllObjectsButCurrent];
        }
        
        _state = state;
        
        if(self.state == kEditorStateConnect){
            [self showConnectionsForAllObjects];
        }
    }
}

#pragma mark - Adding, Removing, Showing, Hiding

-(void) addEditableObject:(TFEditableObject*) editableObject{
    if(editableObject.canBeScaled){
        [self.zoomableLayer addChild:editableObject z:editableObject.z];
    } else{
        [super addEditableObject:editableObject];
    }
}

-(void) addConditions{
    THProject * project = [THDirector sharedDirector].currentProject;
    for (THConditionEditableObject * object in project.conditions) {
        [object addToLayer:self];
    }
}

-(void) removeConditions{
    THProject * project = [THDirector sharedDirector].currentProject;
    for (THConditionEditableObject * object in project.conditions) {
        [object removeFromLayer:self];
    }
}

-(void) showConditions{
    THProject * project = [THDirector sharedDirector].currentProject;
    for (THConditionEditableObject * object in project.conditions) {
        object.visible = YES;
    }
}

-(void) hideConditions{
    THProject * project = [THDirector sharedDirector].currentProject;
    for (THConditionEditableObject * object in project.conditions) {
        object.visible = NO;
    }
}

-(void) showValues{
    THProject * project =  [THDirector sharedDirector].currentProject;
    for (THNumberValueEditable * object in project.values) {
        object.visible = YES;
    }
}

-(void) hideValues{
    THProject * project =  [THDirector sharedDirector].currentProject;
    for (THNumberValueEditable * object in project.values) {
        object.visible = NO;
    }
}

-(void) showTriggers{
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    for (THTriggerEditable * object in project.triggers) {
        object.visible = YES;
    }
}

-(void) hideTriggers{
    THProject * project = [THDirector sharedDirector].currentProject;
    for (THTriggerEditable * object in project.triggers) {
        object.visible = NO;
    }
}

-(void) showActions{
    THProject * project = [THDirector sharedDirector].currentProject;
    for (THActionEditable * object in project.actions) {
        object.visible = YES;
    }
}

-(void) hideActions{
    THProject * project = [THDirector sharedDirector].currentProject;
    for (THActionEditable * object in project.actions) {
        object.visible = NO;
    }
}

-(void) hideiPhone{
    
    THProject * project = [THDirector sharedDirector].currentProject;
    project.iPhone.visible = NO;
}

-(void) showiPhone{
    
    THProject * project = [THDirector sharedDirector].currentProject;
    project.iPhone.visible = YES;
}

-(void) addClothes{
    THProject * project = [THDirector sharedDirector].currentProject;
    for (TFEditableObject * object in project.clothes) {
        [object addToLayer:self];
    }
}

-(void) removeClothes{
    THProject * project = [THDirector sharedDirector].currentProject;
    for (TFEditableObject * object in project.clothes) {
        [object removeFromLayer:self];
    }
}

-(void) showClothes{
    THProject * project = [THDirector sharedDirector].currentProject;
    for (TFEditableObject * object in project.clothes) {
        object.visible = YES;
    }
}


-(void) hideClothes{
    THProject * project = [THDirector sharedDirector].currentProject;
    for (TFEditableObject * object in project.clothes) {
        object.visible = NO;
    }
}

-(void) addEditableObjects{
    
    THProject * project = [THDirector sharedDirector].currentProject;
    for (THHardwareComponentEditableObject * object in project.allObjects) {
        [object addToLayer:self];
    }
}

-(void) removeEditableObjects{;
    
    THProject * project = [THDirector sharedDirector].currentProject;
    for (THHardwareComponentEditableObject * object in project.allObjects) {
        [object removeFromLayer:self];
    }
}


#pragma mark - Lilypad Mode

-(void) addLilypadObjects{
    THProject * project = [THDirector sharedDirector].currentProject;
    
    [self addEditableObject:project.lilypad];
}

-(void) removeLilypadObjects{
    THProject * project = [THDirector sharedDirector].currentProject;
    
    if(project.lilypad != nil){
        [project.lilypad removeFromParentAndCleanup:YES];
    }
}

-(void) hideNonLilypadObjects{
    [self hideClothes];
    [self hideConditions];
    [self hideValues];
    [self hideTriggers];
    [self hideActions];
    [self hideiPhone];
}

-(void) showNonLilypadObjects{
    [self showClothes];
    [self showConditions];
    [self showValues];
    [self showTriggers];
    [self showActions];
    [self showiPhone];
}

-(void) hideAllLilypadWires{
    
    THProject * project = [THDirector sharedDirector].currentProject;
    
    for (THWire * wire in project.wires) {
        wire.visible = NO;
    }
}

-(void) showAllLilypadWires{
    
    THProject * project = [THDirector sharedDirector].currentProject;
    
    for (THWire * wire in project.wires) {
        wire.visible = YES;
    }
}

-(void) showAllPaletteSections{
        
    THPaletteViewController * paletteController = [THDirector sharedDirector].projectController.tabController.paletteController;
    [paletteController useDefaultPaletteSections];
    [paletteController reloadPalettes];
}

-(void) hideNonLilypadPaletteSections{
    
    THPaletteViewController * paletteController = [THDirector sharedDirector].projectController.tabController.paletteController;
    
    paletteController.sections = [NSMutableArray arrayWithObjects:paletteController.clothesSectionArray, paletteController.hardwareSectionArray, nil];
    paletteController.sectionNames = [NSMutableArray arrayWithObjects:paletteController.clothesSectionName, paletteController.hardwareSectionName, nil];
    
    [paletteController reloadPalettes];
}

-(void) startLilypadMode{
    
    _isLilypadMode = YES;
    
    [self unselectCurrentObject];
    [self hideConnectionsForAllObjects];
    
    [self hideNonLilypadObjects];
    [self addLilypadObjects];
    [self showAllLilypadWires];
    [self hideNonLilypadPaletteSections];
}

-(void) stopLilypadMode{
    
    _isLilypadMode = NO;
    
    [self removeLilypadObjects];
    [self showNonLilypadObjects];
    [self unselectCurrentObject];
    [self hideAllLilypadWires];
    
    [self showAllPaletteSections];
}

-(void) removeObjects{
    
    THProject * project = [THDirector sharedDirector].currentProject;
    [project.iPhone removeFromLayer:self];
    
    for (THWire * object in project.wires) {
        [object removeFromLayer:self];
    }
    
    for (THInvocationConnectionLine * connection in project.invocationConnections) {
        [connection removeFromLayer:self];
    }
    
    for (TFEditableObject * object in project.allObjects) {
        [object removeFromLayer:self];
    }
}

-(void) addObjects{
    
    THProject * project = [THDirector sharedDirector].currentProject;
    if(project.iPhone != nil){
        [project.iPhone addToLayer:self];
    }
    
    for (THWire * wire in project.wires) {
        [wire addToLayer:self];
    }
    
    for (THInvocationConnectionLine * connection in project.invocationConnections) {
        [connection addToLayer:self];
    }
    
    for (TFEditableObject * object in project.allObjects) {
        [object addToLayer:self];
    }
}

-(void) prepareObjectsForEdition{
    
    THProject * project = [THDirector sharedDirector].currentProject;
    [project prepareForEdition];
}

#pragma mark - Layer Lifecycle

-(void) willAppear{
    
    [super willAppear];
    
    [self prepareObjectsForEdition];
    [self addObservers];
    [self hideConnectionsForAllObjects];
    [self addObjects];
}

-(void) willDisappear{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self unselectCurrentObject];
    [self removeObjects];
    
    [super willDisappear];
}

-(NSString*) description{
    return @"Custom Editor";
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([@"YES" isEqualToString: [[[NSProcessInfo processInfo] environment] objectForKey:@"printUIDeallocs"]]) {
        NSLog(@"deallocing %@",self);
    }
}

@end
