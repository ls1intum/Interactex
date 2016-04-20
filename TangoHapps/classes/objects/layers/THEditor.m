/*
THEditor.m
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
#import "THWire.h"
#import "THTabbarViewController.h"
#import "THProjectViewController.h"
#import "THPaletteViewController.h"
#import "THInvocationConnectionLine.h"
#import "THPropertySelectionPopup.h"
#import "TFEventActionPair.h"
#import "THDraggedPaletteItem.h"
#import "THI2CProtocol.h"
#import "THElementPin.h"
#import "THBoard.h"
#import "THHardwareComponent.h"
#import "THiPhoneControlEditableObject.h"


//remove
#import "THLabelEditableObject.h"
#import "THView.h"

@implementation THEditor

-(id) init{
    
    self = [super init];
    if(self){
        
        self.additionalConnections = [NSMutableArray array];
        
        self.shouldRecognizePanGestures = YES;
        
        _zoomableLayer = [CCLayerColor layerWithColor:ccc4(248, 248, 248, 0)];
        _zoomableLayer.contentSize = kDefaultCanvasSize;
        [self resetZoomableLayerPosition];
        [self addChild:_zoomableLayer z:-30];
        
        CCSprite * bg = [CCSprite spriteWithFile:@"editorLayerBg.png"];
        [bg setPosition:ccp(_zoomableLayer.contentSize.width / 2.0f, _zoomableLayer.contentSize.height / 2.0f)];
        [_zoomableLayer addChild:bg z:-99];
        
        [self showAllPaletteSections];
    }
    return self;
}

-(void) addObservers {
    id c = [NSNotificationCenter defaultCenter];
    [c addObserver:self selector:@selector(handleEditableObjectAdded:) name:kNotificationObjectAdded object:nil];
    [c addObserver:self selector:@selector(handleEditableObjectRemoved:) name:kNotificationObjectRemoved object:nil];
    [c addObserver:self selector:@selector(startRemovingConnections) name:kNotificationStartRemovingConnections object:nil];
    [c addObserver:self selector:@selector(stopRemovingConnections) name:kNotificationStopRemovingConnections object:nil];
    
    [c addObserver:self selector:@selector(handlePinDeattached:) name:kNotificationPinDeattached object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSelectionLost) name:kNotificationPaletteItemSelected object:nil];
}

-(void) resetZoomableLayerPosition{
    CGRect iPadRect = [THHelper iPadRect];
    CGPoint diff = ccp((iPadRect.size.width - _zoomableLayer.contentSize.width) / 2.0f, (iPadRect.size.height - _zoomableLayer.contentSize.height) / 2.0f);
    
    _zoomableLayer.position = diff;
}

#pragma mark - Event handling

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
    [super draw];
    
    [TFHelper drawLines:self.additionalConnections];
    [self drawTemporaryLine];
    /*
    CGRect newCanvasRect = self.zoomableLayer.boundingBox;
    [TFHelper drawRect:newCanvasRect];*/
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

-(void) unselectAndDeleteEditableObject:(TFEditableObject*) editableObject{
    if(editableObject.canBeDeleted){
        if(self.currentObject == editableObject){
            [self unselectCurrentObject];
            THProjectViewController *projectController = [THDirector sharedDirector].projectController;
            [[projectController tabController] showTab:0];
        }
        [editableObject removeFromWorld];
    }
    
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

-(THWireNode*) wireNodeFromObject:(THHardwareComponentEditableObject*) hardwareObject atPosition:(CGPoint) position{
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    NSArray * wires = [project wiresForHardwareElement:hardwareObject];
    
    for (THWire * wire in wires) {
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
    
    if(!object){
        object = [project objectAtLocation:position];
    }
    
    return object;
}

#pragma mark - Pin highlighting

-(void) highlightPin:(THPinEditable*) pin{
    if(pin != self.currentHighlightedPin){
        if(self.currentHighlightedPin != nil){
            self.currentHighlightedPin.highlighted = NO;
        }
        self.currentHighlightedPin = pin;
        self.currentHighlightedPin.highlighted = YES;
    }
}

-(void) dehighlightCurrentPin{
    
    self.currentHighlightedPin.highlighted = NO;
    self.currentHighlightedPin = nil;
}

#pragma mark - Object Selection

-(void) selectObjectAtPosition:(CGPoint) position{
    
    TFEditableObject * previousObject = self.currentObject;
    
    TFEditableObject * newObject = nil;
    if(self.isLilypadMode) {
        if ([previousObject isKindOfClass:[THHardwareComponentEditableObject class]]){
            newObject = [self wireNodeFromObject:(THHardwareComponentEditableObject*) previousObject atPosition:position];
        } else if([previousObject isKindOfClass:[THWireNode class]]){
            THWireNode * wireNode = (THWireNode*) previousObject;
            newObject = [wireNode.wire nodeAtPosition:position];
        }
    }
    
    [self unselectCurrentObject];

    if(!newObject){
        newObject = [self objectAtPosition:position];
    }
    
    if(newObject){
        [self selectObject:newObject];
    } else {
        THProjectViewController *projectController = [THDirector sharedDirector].projectController;
        [[projectController tabController] showTab:0];
    }
}

-(void) handleSelectionLost{
    
    self.currentObject.selected = NO;
    _currentObject = nil;
}

-(void) unselectCurrentObject{
    if(_currentObject){
        
        if([self.currentObject isKindOfClass:[THHardwareComponentEditableObject class]]){
            [self setShowWiresForObject:(THHardwareComponentEditableObject*) self.currentObject showsWires:NO];
        }
        
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
    
    //nazmus added 21 Jan - to bring the selected object in front (not working for iPhone controls)
    if ([self.currentObject isKindOfClass:[THHardwareComponentEditableObject class]] && [(THHardwareComponentEditableObject*) self.currentObject attachedToClothe]) {
        [(THClothe*)[(THHardwareComponentEditableObject*) self.currentObject attachedToClothe] reorderChild:self.currentObject z:1];
    } else {
        [self.zoomableLayer reorderChild:self.currentObject z:self.currentObject.z];
    }
    
    if(self.isLilypadMode){
        
        if([self.currentObject isKindOfClass:[THHardwareComponentEditableObject class]]){
            [self setShowWiresForObject:(THHardwareComponentEditableObject*) self.currentObject showsWires:YES];
        }
    } else {
        
        [self reLayoutConnectionLinesForObject:self.currentObject];
        [self showConnectionsForCurrentObject];
    }
    
    if([editableObject isKindOfClass:[THWireNode class]]){
        
        THWireNode * node = (THWireNode*) editableObject;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationObjectSelected object:node];
        
    } else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationObjectSelected object:editableObject];
    }
    
    THProjectViewController *projectController = [THDirector sharedDirector].projectController;
    [[projectController tabController] showTab:1];
}

#pragma mark - Connection

-(void) addConnectionLine:(TFConnectionLine*) connection{
    [self.additionalConnections addObject:connection];
}

-(void) removeConnectionLine:(TFConnectionLine*) connection{
    [self.additionalConnections removeObject:connection];
}

-(void) handlePinDeattached:(NSNotification*) notification{
    THElementPinEditable * elementPin = notification.object;
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project removeAllWiresFromElementPin:elementPin notify:YES];
}

-(void) connectElementPin:(THElementPinEditable*) elementPinEditable toBoardAtPosition:(CGPoint) position{
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    THBoardEditable * board = [project boardAtLocation:position];
    THBoardPinEditable * lilypadPin = [board pinAtPosition:position];
    
    if([elementPinEditable acceptsConnectionsTo:lilypadPin]){
        [lilypadPin attachPin:elementPinEditable];
        [elementPinEditable attachToPin:lilypadPin animated:YES];
        [project addWireFrom:elementPinEditable to:lilypadPin];
        
        if(elementPinEditable.hardware.isI2CComponent && (lilypadPin.supportsSCL || lilypadPin.supportsSDA)){
            
            THBoardPinEditable * sdaPin = board.sdaPin;
            THBoardPinEditable * sclPin = board.sclPin;
            
            if((lilypadPin.supportsSCL && [sdaPin isClotheObjectAttached:elementPinEditable.hardware]) ||
               (lilypadPin.supportsSDA && [sclPin isClotheObjectAttached:elementPinEditable.hardware])) {
                [board addI2CComponent:elementPinEditable.hardware];
            }
        }
    }
}

-(void) moveCurrentConnection:(CGPoint)position {
    
    self.currentConnection.p2 = position;
    if(self.isLilypadMode){
        
        THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
        THBoardEditable * board = [project boardAtLocation:position];
        
        if([board testPoint:position]){
            
            THBoardPinEditable * pin = [board pinAtPosition:position];
            
            if(pin != nil){
                [self.currentConnection.obj1 acceptsConnectionsTo:pin];
            }
            
            if(pin != nil && [self.currentConnection.obj1 acceptsConnectionsTo:pin]){
                [self highlightPin:pin];
            } else {
                [self dehighlightCurrentPin];
            }
            
        } else {
            
            THHardwareComponentEditableObject * clotheObject = [project hardwareComponentAtLocation:position];
            
            if(clotheObject){
                THElementPinEditable * pin = [clotheObject pinAtPosition:position];
                if(pin != nil && [self.currentConnection.obj1 acceptsConnectionsTo:pin]){
                    [self highlightPin:pin];
                }else {
                    [self dehighlightCurrentPin];
                }
            }else {
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationInvocationCompleted object:popup.connection.action.firstParam];
}

-(void) showPropertySelectionPopupFor:(TFEditableObject*) object invocationParameter:(THInvocationConnectionLine*) connectionLine{
    if(object != nil){
        
        _propertySelectionPopup = [[THPropertySelectionPopup alloc] init];
        _propertySelectionPopup.delegate = self;
        _propertySelectionPopup.object = object;
        _propertySelectionPopup.connection = connectionLine;
        [_propertySelectionPopup present];
    }
}

#pragma mark - Method Selection Popup

-(void) checkDistributeInvocationConnectionsBetweenObj1:(TFEditableObject*) object1 obj2:(TFEditableObject*) object2{
    
    THProject * project = [THDirector sharedDirector].currentProject;

    NSArray * invocationConnections1 = [project invocationConnectionsFrom:object1 to:object2];
    NSArray * invocationConnections2 = [project invocationConnectionsFrom:object2 to:object1];
    NSArray * invocationConnections = [invocationConnections1 arrayByAddingObjectsFromArray:invocationConnections2];
    
    CGPoint p1 = object1.center;
    CGPoint p2 = object2.center;
    CGPoint diff = ccpSub(p1,p2);
    CGPoint orthog = ccpNormalize(ccpRPerp(diff));
    float const kEditorInvocationLinesDistance = 26;
    float multiplier = - (float)(invocationConnections.count+1) * kEditorInvocationLinesDistance / 2.0f;
    CGPoint offset = ccpMult(orthog, multiplier);
    CGPoint currentPos = ccpAdd(ccpMult(ccpAdd(p1, p2),0.5f),offset);
    CGPoint addition = ccpMult(orthog,kEditorInvocationLinesDistance);
    
    for (THInvocationConnectionLine * connectionLine in invocationConnections) {
        currentPos = ccpAdd(currentPos, addition);
        connectionLine.lineCenter = currentPos;
    }
}

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
        
    } else {
        invocationConnection.action.firstParam = nil;
    }
    
    [project addInvocationConnection:invocationConnection animated:YES];
    
    [self checkDistributeInvocationConnectionsBetweenObj1:popup.object1 obj2:popup.object2];
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
            if([object2 isKindOfClass:[THBoardEditable class]]){
                [self connectElementPin:objectPin toBoardAtPosition:location];
            }
        }
        
        [self dehighlightCurrentPin];
        
    } else if([object2 isKindOfClass:[THInvocationConnectionLine class]]){
        
        [self showPropertySelectionPopupFor:object1 invocationParameter:(THInvocationConnectionLine*) object2];
        
    } else {
        [self showMethodSelectionPopupFor:object1 and:object2];
    }
    
    _currentConnection = nil;
}

-(void) handleConnectionStartedAt:(CGPoint) location{
    THProject * project = [THDirector sharedDirector].currentProject;
    TFEditableObject * object = [project objectAtLocation:location];
    
    //[self unselectCurrentObject];
    
    if(object){
        if(self.isLilypadMode){
            
            if([object isKindOfClass:[THHardwareComponentEditableObject class]]){
                THHardwareComponentEditableObject * hardwareComponent = (THHardwareComponentEditableObject*) object;
                THElementPinEditable * elementPin = [hardwareComponent pinAtPosition:location];
                
                if(elementPin){
                    [self startNewConnectionForObject:elementPin];
                }
            }
            
        } else {
            if(object.acceptsConnections){
                [self startNewConnectionForObject:object];
            }
        }
    } else if(self.isLilypadMode){
        THWireNode * wireNode = [self wireNodeAtPosition:location];
        
        if(wireNode){
            [self selectObject:wireNode];
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

-(void) reLayoutConnectionLinesForAllObjects{
    THProject * project = [THDirector sharedDirector].currentProject;
    for (TFEditableObject * object in project.allObjects) {
        
        NSArray * connections = [project invocationConnectionsForObject:object];
        for (THInvocationConnectionLine * line in connections) {
            [self checkDistributeInvocationConnectionsBetweenObj1:object obj2:line.obj2];
        }
    }
}

-(void) reLayoutConnectionLinesForObject:(TFEditableObject*) object{
    THProject * project = [THDirector sharedDirector].currentProject;
    NSArray * connections = [project invocationConnectionsForObject:object];
    for (THInvocationConnectionLine * line in connections) {
        [self checkDistributeInvocationConnectionsBetweenObj1:object obj2:line.obj2];
    }
    
    connections = [project invocationConnectionsToObject:object];
    for (THInvocationConnectionLine * line in connections) {
        [self checkDistributeInvocationConnectionsBetweenObj1:line.obj1 obj2:object];
    }
}

-(void) moveCurrentObject:(CGPoint) d{
    if([self.currentObject canBeMovedBy:d]){
        
        if((self.currentObject.parent == self.zoomableLayer) || (self.currentObject.parent.parent == self.zoomableLayer)){//Juan! recheck this. Leads to bugs when attached to tshirt.
            d = ccpMult(d, 1.0f/_zoomableLayer.scale);
        }
        
        CGRect canvasBox = self.zoomableLayer.boundingBox;
        CGRect oldBoundingBox = self.currentObject.boundingBox;
        CGRect newBoundingBox = oldBoundingBox;
        newBoundingBox.origin = ccpAdd(newBoundingBox.origin, d);
        
        if(CGRectGetMinX(newBoundingBox) < CGRectGetMinX(canvasBox) || CGRectGetMaxX(newBoundingBox) > CGRectGetMaxX(canvasBox)){
            d.x = 0;
        }
        if(CGRectGetMinY(newBoundingBox) < CGRectGetMinY(canvasBox) || CGRectGetMaxY(newBoundingBox) > CGRectGetMaxY(canvasBox)){
            d.y = 0;
        }
                
        [self.currentObject displaceBy:d];
        
        [self reLayoutConnectionLinesForObject:self.currentObject];
    }
}

-(void) moveLayer:(CGPoint) d{
    
    CGRect iPadRect = [THHelper iPadRect];
    
    CGRect oldCanvasRect = self.zoomableLayer.boundingBox;
    
    CGRect newCanvasRect = CGRectMake(oldCanvasRect.origin.x + d.x, oldCanvasRect.origin.y + d.y, oldCanvasRect.size.width, oldCanvasRect.size.height);
    
    //NSLog(@"%f %f %f %f",newCanvasRect.origin.x, newCanvasRect.origin.y, newCanvasRect.size.width,newCanvasRect.size.height);
    
    if(!CGRectIntersectsRect(oldCanvasRect, iPadRect) || CGRectIntersectsRect(newCanvasRect, iPadRect)){
        
        self.zoomableLayer.position = ccpAdd(self.zoomableLayer.position,d);
    }
}

-(BOOL) shouldSnapWireToXPosition:(CGPoint) position{

    const float kSnapDistance = 10;
    
    THWireNode * node = (THWireNode*) self.currentObject;
    
    NSArray * nodes = [node.wire wireNodesNextToNode:node];
    THWireNode * firstNode = nodes[0];
    THWireNode * secondNode = nodes[1];
    
    CGPoint firstNodeGlobalPos = [firstNode convertToWorldSpace:ccp(0,0)];
    CGPoint firstNodeZoomLayerPos = [self.zoomableLayer convertToNodeSpace:firstNodeGlobalPos];
    
    CGPoint secondNodeGlobalPos = [secondNode convertToWorldSpace:ccp(0,0)];
    CGPoint secondNodeZoomLayerPos = [self.zoomableLayer convertToNodeSpace:secondNodeGlobalPos];
    
    CGPoint touchZoomLayerPos = [self.zoomableLayer convertToNodeSpace:position];
    
    float xDiff1 = firstNodeZoomLayerPos.x - touchZoomLayerPos.x;
    float xDiff2 = secondNodeZoomLayerPos.x - touchZoomLayerPos.x;
    
    if(fabs(xDiff1) <= kSnapDistance) {
        currentSnapPosition.x = firstNodeZoomLayerPos.x;
        return YES;
    }
    
    if(fabs(xDiff2) <= kSnapDistance) {
        currentSnapPosition.x = secondNodeZoomLayerPos.x;
        return YES;
    }
    
    return NO;
}

-(BOOL) shouldSnapWireToYPosition:(CGPoint) position {
    
    const float kSnapDistance = 10;
    
    THWireNode * node = (THWireNode*) self.currentObject;
    
    NSArray * nodes = [node.wire wireNodesNextToNode:node];
    THWireNode * firstNode = nodes[0];
    THWireNode * secondNode = nodes[1];
    
    CGPoint firstNodeGlobalPos = [firstNode convertToWorldSpace:ccp(0,0)];
    CGPoint firstNodeZoomLayerPos = [self.zoomableLayer convertToNodeSpace:firstNodeGlobalPos];
    
    CGPoint secondNodeGlobalPos = [secondNode convertToWorldSpace:ccp(0,0)];
    CGPoint secondNodeZoomLayerPos = [self.zoomableLayer convertToNodeSpace:secondNodeGlobalPos];
    
    CGPoint touchGlobalPos = [self.zoomableLayer convertToNodeSpace:position];
    
    float yDiff1 = firstNodeZoomLayerPos.y - touchGlobalPos.y;
    float yDiff2 = secondNodeZoomLayerPos.y - touchGlobalPos.y;
    
    if(fabs(yDiff1) <= kSnapDistance) {
        currentSnapPosition.y = firstNodeZoomLayerPos.y;
        return YES;
    }
    
    if(fabs(yDiff2) <= kSnapDistance) {
        currentSnapPosition.y = secondNodeZoomLayerPos.y;
        return YES;
    }
    
    return NO;
}

-(void) handleSingleTouchMove:(UIPanGestureRecognizer*) sender{
    
    CGPoint location = [sender locationInView:sender.view];
    location = [self toLayerCoords:location];
    
    if(self.state == kEditorStateConnect){
        
        if(sender.state == UIGestureRecognizerStateBegan){
            
            [self handleConnectionStartedAt:location];
            
        } else if(_currentConnection.state == kConnectionStateDrawing) {
            
            //TFEditableObject * object = [self objectAtPosition:location];
            //NSLog(@"on top of: %@",object);
            
            [self moveCurrentConnection:location];
            
        }
        
    } else if(_state == kEditorStateDuplicate) {
        
        if(sender.state == UIGestureRecognizerStateBegan){
            
            TFEditableObject * copy = [self duplicateObjectAtLocation:location];
            
            if(copy){
                [self selectObject:copy];
            }
            
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
                
                BOOL isWireNode = [self.currentObject isKindOfClass:[THWireNode class]];

                if(isWireNode){

                    if([self shouldSnapWireToXPosition:location]){
                        self.currentObject.position = ccp(currentSnapPosition.x,self.currentObject.position.y);
                        d.x = 0;
                    }
                    
                    if([self shouldSnapWireToYPosition:location]){
                        self.currentObject.position = ccp(self.currentObject.position.x, currentSnapPosition.y);
                        d.y = 0;
                    }
                }
                

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
        if(self.gestureState == kEditorGestureNone){
            [self handleSingleTouchMove:sender];
        }
    } else if(sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled){
        self.gestureState = kEditorGestureNone;
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

-(THWireNode*) wireNodeAtLocation:(CGPoint) location wire:(THWire*) wire{
    for (THWireNode * node in wire.nodes) {
        if([node testPoint:location]){
            return node;
        }
    }
    return nil;
}

-(void) handleExtra{//Juan remove!!
    
    THProject * project = [THDirector sharedDirector].currentProject;
    THLabelEditableObject * label1 = [project.iPhoneObjects objectAtIndex:0];
    
    NSLog(@"copyng label... %@",label1);
    
    
    THLabelEditableObject * label2 =  [label1 copy];
    [label2 addToWorld];
    /*
    [self addEditableObject:label2];
    
    THView * view = (THView*) label2.simulableObject;
    [view addToView:[CCDirector sharedDirector].view];*/
}

-(void)tapped:(UITapGestureRecognizer*)sender {
    //[self handleExtra];
    //return;
    
    CGPoint location = [sender locationInView:sender.view];
    location = [self toLayerCoords:location];
    
    if(self.removingConnections){
        
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
        
        object.highlighted = NO;
        
    } else if(_state == kEditorStateDelete){
        
        THProjectViewController *projectController = [THDirector sharedDirector].projectController;
        THProject * project = [THDirector sharedDirector].currentProject;
        
        THWire * wire = (THWire*) [project wireAtLocation:location];
        
        if(wire){
            
            if(wire.nodes.count == 1){
                if (wire.selected) {
                    [self unselectCurrentObject];
                    [[projectController tabController] showTab:0];
                }
                [self removeEditableObject:wire];
                
                [wire.obj2 deattachPin:wire.obj1];
                
                if(wire){
                    [self unselectAndDeleteEditableObject:wire];
                }
            } else {
                THWireNode * node = [self wireNodeAtLocation:location wire:wire];
                [wire removeNode:node];
            }
        } else{
            
            TFEditableObject * object = [project objectAtLocation:location];
            if(object){
                [self unselectAndDeleteEditableObject:object];
            }
        }
        
    } else {
        [self selectObjectAtPosition:location];
    }
}


-(void) setZoomLevel:(float)newZoomLevel{
    
    if(newZoomLevel > kLayerMinScale && newZoomLevel < kLayerMaxScale){
        
        self.zoomableLayer.scale = newZoomLevel;
    }
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
    }
    
    sender.scale = 1.0f;
}

-(void) checkPinClotheObject:(THHardwareComponentEditableObject*) hardwareComponent atLocation:(CGPoint) location{
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    THClothe * clothe = [project clotheAtLocation:location];
    if(clothe != nil){
        CGPoint position = [hardwareComponent convertToWorldSpace:ccp(0,0)];
        position = [clothe convertToNodeSpace:position];
        position = ccpAdd(position, ccp(hardwareComponent.contentSize.width/2,hardwareComponent.contentSize.height/2));
        
        [hardwareComponent removeFromParentAndCleanup:YES];
        [project pinClotheObject:hardwareComponent toClothe:clothe];
        hardwareComponent.position = position;
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"sewed.mp3"];
    }
}

-(void) checkUnPinClotheObject:(THHardwareComponentEditableObject*) hardwareComponent{
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    
    CGPoint position = [hardwareComponent convertToWorldSpace:ccp(0,0)];
    THClothe * clothe = [project clotheAtLocation:position];
    
    if(clothe != nil){
        [project unpinClotheObject:hardwareComponent];
        
        position = [self.zoomableLayer convertToNodeSpace:position];
        position = ccpAdd(position, ccp(hardwareComponent.contentSize.width/2,hardwareComponent.contentSize.height/2));
        hardwareComponent.position = position;
        
        [hardwareComponent addToLayer:self];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"sewed.mp3"];
    }
}

-(void) doubleTapped:(UITapGestureRecognizer*)sender{
    
    CGPoint location = [sender locationInView:sender.view];
    location = [self toLayerCoords:location];
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    THHardwareComponentEditableObject * clotheObject = [project hardwareComponentAtLocation:location];

    if(clotheObject){
        if(clotheObject.attachedToClothe){
            [self checkUnPinClotheObject:clotheObject];
        } else {
            [self checkPinClotheObject:clotheObject atLocation:location];
        }
    } else {

        _zoomableLayer.scale = 1.0f;
        [self resetZoomableLayerPosition];
//        _zoomableLayer.position = ccp(0,0);
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationEditorZoomReset object:nil];
        
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
    
    CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL: location];
    if(item.state != kPaletteItemStateDroppable && [item canBeDroppedAt:convertedLocation]){
        item.state = kPaletteItemStateDroppable;
    } else if(item.state != kPaletteItemStateNormal && ![item canBeDroppedAt:convertedLocation]){
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

                THProjectViewController *projectController = [THDirector sharedDirector].projectController;
                [[projectController tabController] showTab:0];

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

-(void) setShowWiresForObject:(THHardwareComponentEditableObject*) object showsWires:(BOOL) showsWires{
    NSArray * wires = [[THDirector sharedDirector].currentProject wiresForHardwareElement:object];
    
    for (THWire * wire in wires) {
        wire.showsNodes = showsWires;
    }
}

-(void) showConnectionsForCurrentObject{
    THProject * project = [THDirector sharedDirector].currentProject;
    NSArray * connections = [project invocationConnectionsForObject:self.currentObject];
    
    for (THInvocationConnectionLine * connection in connections) {
        if(connection.obj2.visible){
            connection.visible = YES;
        }
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
        if(connection.obj1.visible && connection.obj2.visible){
            connection.visible = YES;
        }
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
            if(!self.isLilypadMode){
                [self hideConnectionsForAllObjectsButCurrent];
            }
        }
        
        _state = state;
        
        if(self.state == kEditorStateConnect){
            
            if(!self.isLilypadMode){
                
                [self reLayoutConnectionLinesForAllObjects];
                [self showConnectionsForAllObjects];
            }
        }
    }
}

#pragma mark - Adding, Removing, Showing, Hiding

-(void) addEditableObject:(TFEditableObject*) editableObject{
    
    if(!editableObject.parent){
        if(editableObject.canBeScaled){
            
            [self.zoomableLayer addChild:editableObject z:editableObject.z];
            
        } else{
            [super addEditableObject:editableObject];
        }
    }
}

-(void) showVisualProgrammingObjects{
    THProject * project =  [THDirector sharedDirector].currentProject;
    for (THNumberValueEditable * object in project.visualProgrammingObjects) {
        object.visible = YES;
    }
}

-(void) hideVisualProgrammingObjects{
    THProject * project =  [THDirector sharedDirector].currentProject;
    for (THNumberValueEditable * object in project.visualProgrammingObjects) {
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

-(void) showBoards{
    
    THProject * project = [THDirector sharedDirector].currentProject;
    for (THBoardEditable * board in project.boards) {
        board.visible = YES;
    }
}

-(void) hideBoards{
    
    THProject * project = [THDirector sharedDirector].currentProject;
    for (THBoardEditable * board in project.boards) {
        board.visible = NO;
    }
}

-(void) showOtherHardware{
    
    THProject * project = [THDirector sharedDirector].currentProject;
    for (THHardwareComponentEditableObject * board in project.otherHardwareComponents) {
        board.visible = YES;
    }
}

-(void) hideOtherHardware{
    
    THProject * project = [THDirector sharedDirector].currentProject;
    for (THHardwareComponentEditableObject * board in project.otherHardwareComponents) {
        board.visible = NO;
    }
}

#pragma mark - Lilypad Mode

-(void) hideNonLilypadObjects{
    //[self hideClothes];
    [self hideVisualProgrammingObjects];
    [self hideiPhone];
}

-(void) showNonLilypadObjects{
    //[self showClothes];
    [self showVisualProgrammingObjects];
    [self showiPhone];
}

-(void) updateWiresVisibility{
    if(self.isLilypadMode){
        THProject * project = [THDirector sharedDirector].currentProject;
        for (THBoardEditable * board in project.boards) {
            
            for (THWire * wire in project.wires) {
                THBoardPinEditable * boardPin = wire.obj2;
                if([board.pins containsObject:boardPin]){
                    THElementPinEditable * elementPin = wire.obj1;
                    if(elementPin.selected){
                        
                        wire.visible = YES;
                    } else if(board.showsWires){
                        wire.visible = YES;
                        wire.showsNodes = NO;
                    } else {
                        
                        wire.visible = NO;
                    }
                }
            }
        }
    } else {
        [self hideAllLilypadWires];
    }
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
    
    paletteController.sections = [NSMutableArray arrayWithObjects:paletteController.clothesSectionArray, paletteController.boardsSectionArray, paletteController.hardwareSectionArray, nil];
    paletteController.sectionNames = [NSMutableArray arrayWithObjects:paletteController.clothesSectionName, paletteController.boardsSectionName, paletteController.hardwareSectionName, nil];
    
    [paletteController reloadPalettes];
}

-(void) deAttachClotheItems{
    
    THProject * project = [THDirector sharedDirector].currentProject;
    attachedClotheObjects = [NSMutableArray arrayWithCapacity:project.clothes.count];
    attachedClotheObjectsPositions = [NSMutableArray arrayWithCapacity:project.clothes.count];
    
    for (THClothe * clothe in project.clothes) {
        NSMutableArray * positionsArray = [NSMutableArray arrayWithCapacity:clothe.attachments.count];
        for (THHardwareComponentEditableObject * hardwareComponent in clothe.attachments) {
            
            NSValue * value = [NSValue valueWithCGPoint:hardwareComponent.position];
            [positionsArray addObject:value];
            
            CGPoint position = [hardwareComponent convertToWorldSpace:ccp(0,0)];
            position = ccpAdd(position, ccp(hardwareComponent.contentSize.width/2 * self.zoomableLayer.scale,hardwareComponent.contentSize.height/2 * self.zoomableLayer.scale));
            position = [self.zoomableLayer convertToNodeSpace:position];
            
            [hardwareComponent removeFromParentAndCleanup:YES];
            hardwareComponent.attachedToClothe = nil;
            
            hardwareComponent.position = position;
            [hardwareComponent addToLayer:self];
        }
        [attachedClotheObjects addObject:clothe.attachments];
        [attachedClotheObjectsPositions addObject:positionsArray];
    }
}

-(void) reAttachClotheItems{
    
    THProject * project = [THDirector sharedDirector].currentProject;
    NSInteger count = 0;
    for (NSArray * array in attachedClotheObjects) {
        THClothe * clothe = [project.clothes objectAtIndex:count];
        NSArray * positionsArray = [attachedClotheObjectsPositions objectAtIndex:count++];
        NSInteger count2 = 0;
        for (THHardwareComponentEditableObject * hardwareComponent in array) {
            [hardwareComponent removeFromLayer:self];
            NSValue * value = [positionsArray objectAtIndex:count2++];
            [clothe addChild:hardwareComponent z:1];
            
            CGPoint position = value.CGPointValue;
            hardwareComponent.position = position;
            hardwareComponent.attachedToClothe = clothe;
        }
    }
    
    attachedClotheObjects = nil;
    attachedClotheObjectsPositions = nil;
}

-(void) startLilypadMode{
    
    _isLilypadMode = YES;
    
    [self unselectCurrentObject];
    [self deAttachClotheItems];
    
    [self hideConnectionsForAllObjects];
    [self hideNonLilypadObjects];
    [self showBoards];
    [self showOtherHardware];
    [self updateWiresVisibility];
    [self hideNonLilypadPaletteSections];
}

-(void) stopLilypadMode{
    
    _isLilypadMode = NO;
    //[self hideBoards];
    [self hideOtherHardware];
    [self showNonLilypadObjects];
    [self unselectCurrentObject];
    [self updateWiresVisibility];
    [self showAllPaletteSections];
    [self reAttachClotheItems];
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

        if([object isKindOfClass:[THHardwareComponentEditableObject class]]){
            THHardwareComponentEditableObject * hardwareComponent = (THHardwareComponentEditableObject*) object;
            if(!hardwareComponent.attachedToClothe){
                [object removeFromLayer:self];
            }
        } else {
            [object removeFromLayer:self];
        }
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
        
        if([object isKindOfClass:[THHardwareComponentEditableObject class]]){
            THHardwareComponentEditableObject * hardwareComponent = (THHardwareComponentEditableObject*) object;
            if(!hardwareComponent.attachedToClothe){
                [object addToLayer:self];
            }
        } else {
            [object addToLayer:self];
        }
    }
}

-(void) prepareObjectsForEdition{
    
    THProject * project = [THDirector sharedDirector].currentProject;
    [project prepareForEdition];
}

#pragma mark - Layer Lifecycle

-(void) willAppear{
    
    [super willAppear];
    
    //[self hideBoards];
    
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
