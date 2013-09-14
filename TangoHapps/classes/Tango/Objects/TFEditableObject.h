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
#import "TFEditable.h"

@class TFSimulableObject;
@class THTriggerableProperties;
@class THViewableProperties;
@class THInvokableProperties;
@class TFEditor;
@class TFEvent;
@class TFMethod;
@class THPaletteItem;
@class TFLayer;
@class TFAction;

@interface TFEditableObject : CCNode <NSCoding, NSCopying, TFEditable> {
    CCLabelTTF * _selectionLabel;
}

@property (nonatomic) BOOL active;
@property (nonatomic) BOOL canBeDuplicated;
@property (nonatomic) BOOL canBeAddedToPalette;

@property (nonatomic) float rotation;
@property (nonatomic) float scale;
@property (nonatomic) CGPoint position;
@property (nonatomic, readonly) CGPoint absolutePosition;
@property (nonatomic, readonly) CGPoint center;

@property (nonatomic) CGSize size;
@property (nonatomic) float width;
@property (nonatomic) float height;

@property (nonatomic) NSInteger z;
@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL acceptsConnections;
@property (nonatomic,retain) CCSprite * sprite;
@property (nonatomic, readonly) NSMutableArray * connections;

@property (nonatomic, readonly) NSString * shortDescription;
@property (nonatomic, strong) TFSimulableObject * simulableObject;

@property (nonatomic) BOOL highlighted;
@property (nonatomic) ccColor4B highlightColor;

@property (nonatomic) BOOL isAccelerometerEnabled;

@property (nonatomic, readonly) THPaletteItem * paletteItem;

@property (nonatomic) BOOL zoomable;

@property (nonatomic) THTriggerableProperties * triggerableProperties;
@property (nonatomic) THViewableProperties * viewableEditableProperties;
@property (nonatomic) THInvokableProperties * invokableEditableProperties;

//transformation
-(void) displaceBy: (CGPoint) displacement;
-(void) scaleBy:(float) scaleDx;
-(void) rotateBy: (float) rotation;

//ui
-(void) handleAccelerated:(UIAcceleration*) acceleration;
-(void) handleRotation:(float) degree;
-(void) handleTap;
-(BOOL) testPoint:(CGPoint)point;
-(void) handleTouchBegan;
-(void) handleTouchEnded;

//hierarchy
-(void) addToWorld;
-(void) removeFromWorld;

-(void) addToLayer:(TFLayer*) layer;
-(void) removeFromLayer:(TFLayer*) layer;

//lifecycle
-(void) willStartSimulation;
-(void) didStartSimulation;
-(void) willStartEdition;
-(void) prepareToDie;

//connections
-(BOOL) acceptsConnectionsTo:(TFEditableObject*) object;
-(void) addConnectionTo:(TFEditableObject*) object animated:(BOOL) animated;
-(NSArray*) connectionsToObject:(TFEditableObject*) target;
-(void) removeConnectionTo:(TFEditableObject*) object;
-(void) removeAllConnectionsTo:(TFEditableObject*) object;
-(void) registerNotificationsFor:(TFEditableObject*) object;
-(void) handleEditableObjectRemoved:(NSNotification*) notification;

//actions
-(void) handleRegisteredAsSourceForAction:(TFAction*) action;
-(void) handleRegisteredAsTargetForAction:(TFAction*) action;

//methods
-(TFMethod*) methodNamed:(NSString*) methodName;
-(TFEvent*) eventNamed:(NSString*) eventName;

-(void) reloadProperties;

//boxes
-(void) update;

@property (nonatomic) NSMutableArray* viewableProperties;
@property (nonatomic) NSMutableArray* events;
@property(nonatomic) NSMutableArray * methods;


@end
