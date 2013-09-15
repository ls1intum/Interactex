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

#import "TFEditableObject.h"
#import "TFConnectionLine.h"
#import "THEditableObjectProperties.h"
#import "TFSimulableObject.h"
#import "TFMethod.h"
#import "TFEvent.h"
#import "TFProperty.h"
#import "TFEditor.h"

#import "THViewableProperties.h"
#import "THInvokableProperties.h"
#import "THTriggerableProperties.h"
#import "THPaletteItem.h"

@implementation TFEditableObject

@dynamic paletteItem;

-(void) loadEditableObject{
    
    self.zoomable = YES;
    self.anchorPoint = ccp(0.5,0.5);
    self.visible = YES;
    self.highlightColor = kDefaultObjectHighlightColor;
    self.canBeDuplicated = YES;
    self.canBeAddedToPalette = NO;
}

-(id) init{
    if((self=[super init])) {
        self.scale = 1.0f;
        self.rotation = 0.0f;
        self.active = YES;
        
        self.z = kDefaultZ;
        _connections = [NSMutableArray array];
        [self loadEditableObject];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    [self loadEditableObject];
    
    self.active = [decoder decodeBoolForKey:@"active"];
    self.scale = [decoder decodeFloatForKey:@"scale"];
    self.rotation = [decoder decodeFloatForKey:@"rotation"];
    self.position = [decoder decodeCGPointForKey:@"position"];
    self.size = [decoder decodeCGSizeForKey:@"size"];
    self.z = [decoder decodeIntForKey:@"z"];
    self.simulableObject = [decoder decodeObjectForKey:@"object"];
    self.acceptsConnections = [decoder decodeBoolForKey:@"acceptsConnections"];
    _connections = [decoder decodeObjectForKey:@"connections"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeBool:self.active forKey:@"active"];
    [coder encodeFloat:self.scale forKey:@"scale"];
    [coder encodeFloat:self.rotation forKey:@"rotation"];
    [coder encodeCGPoint:self.position forKey:@"position"];
    [coder encodeCGSize:self.size forKey:@"size"];
    [coder encodeInt:self.z forKey:@"z"];
    [coder encodeObject:self.simulableObject forKey:@"object"];
    [coder encodeBool:self.acceptsConnections forKey:@"acceptsConnections"];
    [coder encodeObject:self.connections forKey:@"connections"];
}

-(id)copyWithZone:(NSZone *)zone {
    
    TFEditableObject * copy = [[[self class] alloc] init];
    
    copy.active = self.active;
    copy.scale = self.scale;
    copy.rotation = self.rotation;
    copy.position = self.position;
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers {
    
    NSMutableArray * array = [NSMutableArray array];
    if(self.viewableProperties.count > 0){
        _viewableEditableProperties = [THViewableProperties properties];
        [array addObject:_viewableEditableProperties];
    }
    if(self.methods.count > 0){
        _invokableEditableProperties = [THInvokableProperties properties];
        [array addObject:_invokableEditableProperties];
    }
    if(self.events.count > 0){
        _triggerableProperties = [THTriggerableProperties properties];
        [array addObject:_triggerableProperties];
    }
    
    return array;
}

#pragma mark - Methods

-(void) update{
    
}

-(TFMethod*) methodNamed:(NSString*) methodName{
    return [self.simulableObject methodNamed:methodName];
}

-(TFEvent*) eventNamed:(NSString*) eventName{
    return [self.simulableObject eventNamed:eventName];
}

#pragma mark - Connections

-(void) handleConnectionsRemoved{
    [_triggerableProperties reloadState];
}

-(void) removeConnectionTo:(TFEditableObject*) object{
    
    TFConnectionLine * toRemove = nil;
    for (TFConnectionLine * connection in _connections) {
        if(connection.obj2 == object){
            toRemove = connection;
        }
    }
    
    if(toRemove){
        [_connections removeObject:toRemove];
    }
    
    [self handleConnectionsRemoved];
}

-(void) removeAllConnectionsTo:(TFEditableObject*) object{
    NSMutableArray * toRemove = [NSMutableArray array];
    for (TFConnectionLine * connection in _connections) {
        if(connection.obj2 == object){
            [toRemove addObject:connection];
        }
    }
    
    for (id object in toRemove) {
        [_connections removeObject:object];
    }
    
    [self handleConnectionsRemoved];
}

-(BOOL) acceptsConnectionsTo:(TFEditableObject*)object{
    
    for (TFEvent * event in self.events) {
        for (TFMethod * method in object.methods) {
            if([event canTriggerMethod:method]){
                return YES;
            }
        }
    }
    
    for (TFProperty * property in self.viewableProperties) {
        if([object acceptsPropertiesOfType:property.type]){
            return YES;
        }
    }
    
    return NO;
}

/*
-(NSArray*) allConnections{
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.connections];
    for (THExtension * extension in self.extensions) {
        [array addObjectsFromArray:extension.allConnections];
    }
    return array;
}*/

-(NSArray*) connectionsWithTarget:(TFEditableObject*) target{
    NSMutableArray * connections = [NSMutableArray array];
    
    for (TFConnectionLine * connection in self.connections) {
        if(connection.obj2 == target){
            [connections addObject:connection];
        }
    }
    return connections;
}

-(void) handleEditableObjectRemoved:(NSNotification*) notification{
    
    TFEditableObject * object = notification.object;
    [self removeAllConnectionsTo:object];
}

-(void) registerNotificationsForConnections{
    for (TFConnectionLine * connection in _connections) {
        TFEditableObject * editable = connection.obj2;
        [self registerNotificationsFor:editable];
    }
}

-(void) registerNotificationsFor:(TFEditableObject*) object{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEditableObjectRemoved:) name:kNotificationObjectRemoved object:object];
}

-(void) addConnectionTo:(TFEditableObject*) object animated:(BOOL) animated{

    TFConnectionLine * connection = [[TFConnectionLine alloc] init];
    connection.obj1 = self;
    connection.obj2 = object;
    connection.shouldAnimate = animated;
    [_connections addObject:connection];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConnectionMade object:connection];
    
    [self.triggerableProperties reloadState];
    
    [self registerNotificationsFor:object];
}

-(NSArray*) connectionsToObject:(TFEditableObject*) target{
    NSMutableArray * connections = [NSMutableArray array];
    
    for (TFConnectionLine * connection in self.connections) {
        if(connection.obj2 == target){
            [connections addObject:connection];
        }
    }
    return connections;
}

#pragma mark - Actions

-(void) handleRegisteredAsSourceForAction:(TFAction*) action{
}

-(void) handleRegisteredAsTargetForAction:(TFAction*) action{
}

#pragma mark - Properties

-(NSMutableArray*) viewableProperties{
    return self.simulableObject.viewableProperties;
}

-(BOOL) acceptsPropertiesOfType:(TFDataType)type{
    return [self.simulableObject acceptsPropertiesOfType:type];
}

-(NSMutableArray*) events{
    return self.simulableObject.events;
}

-(NSArray*) methods{
    return self.simulableObject.methods;
}

#pragma mark - Methods

-(void) setVisible:(BOOL)visible{
    TFSimulableObject * simulable = (TFSimulableObject*) self.simulableObject;
    simulable.visible = visible;
    [super setVisible:visible];
}
/*
-(BOOL) visible{
    return super 
    TFSimulableObject * simulable = (TFSimulableObject*) self.simulableObject;
    return simulable.visible;
}*/

-(THPaletteItem*) paletteItem{
    THPaletteItem * paletteItem = [[THPaletteItem alloc] initWithName:@"customPaletteItem"];
    return paletteItem;
}

-(void) updateContentSize{

    self.contentSize = self.sprite.contentSize;
}

-(void) setSprite:(CCSprite *)sprite{
    if(_sprite != sprite){
        _sprite = sprite;
        _sprite.anchorPoint = ccp(0,0);
        [self updateContentSize];
    }
}

-(void) addToLayer:(TFLayer*) layer{
}

-(void) removeFromLayer:(TFLayer*) layer{
}

-(void) addToWorld{
}

-(void) removeFromWorld {
    [self prepareToDie];
}

-(void) setWidth:(float) width{
    _size.width = width;
}

-(float) width{
    return _size.width;
}

-(void) setHeight:(float) height{
    _size.height = height;
}

-(float) height{
    return _size.height;
}

-(void) setSize:(CGSize)size{
    _size = size;
}

-(void)scaleBy:(float)scaleDx {
    self.scale *= scaleDx;
}

-(void)rotateBy:(float)aFloat {
    self.rotation += aFloat;
}

-(void)displaceBy:(CGPoint)displacement {
    self.position = ccpAdd(self.position, displacement);
}

-(void) setPosition:(CGPoint)position{
    [super setPosition:position];
    //NSLog(@"%f %f",position.x,position.y);
}

-(void) reloadProperties{
    [self.triggerableProperties reloadState];
    [self.viewableEditableProperties reloadState];
    [self.invokableEditableProperties reloadState];
}

-(CGRect) boundingBox{
        
    if(_sprite){
        CGPoint spriteLoc = [_sprite convertToWorldSpace:CGPointZero];
        return CGRectMake(spriteLoc.x, spriteLoc.y, _sprite.contentSize.width * self.scale * self.parent.scale, _sprite.contentSize.height * self.scale * self.parent.scale);
    } else {
        CGPoint spriteLoc = [self convertToWorldSpace:CGPointZero];
        
        CGSize size = CGSizeMake(self.contentSize.width * self.scale * self.parent.scale, self.contentSize.height * self.scale * self.parent.scale);
        return CGRectMake(spriteLoc.x - size.width / 2, spriteLoc.y - size.height / 2, size.width, size.height);
    }
    
    
    CGPoint pos = self.position;
    pos = ccpAdd(pos, self.parent.position);
    
    CGSize spriteSize;
    if(_sprite){
        //NSLog(@"%f - %f ",_sprite.contentSize.width,_sprite.contentSizeInPixels.width);
        
        spriteSize = CGSizeMake(_sprite.contentSize.width * _sprite.scaleX,_sprite.contentSize.height * _sprite.scaleY);
    } else {
        spriteSize = CGSizeMake(_size.width,_size.height);
    }
    
    CGPoint halfSize = ccp(spriteSize.width/2,spriteSize.height/2);
    pos = ccpSub(pos, halfSize);
    CGRect spriteRect = CGRectMake(pos.x, pos.y, spriteSize.width, spriteSize.height);
    return spriteRect;
    
    /*
    float maxX = box.origin.x + box.size.width;
    float maxY = box.origin.y + box.size.height;
    
    for (TFExtension * extension in self.extensions) {
        CGRect rect = extension.boundingBox;
        if(rect.origin.x < box.origin.x){
            box.origin.x = rect.origin.x;
        }
        if(rect.origin.y < box.origin.y){
            box.origin.y = rect.origin.y;
        }
        if(rect.origin.x + rect.size.width > maxX){
            maxX = rect.origin.x + rect.size.width;
        }
        if(rect.origin.y + rect.size.height > maxY){
            maxY = rect.origin.y + rect.size.height;
        }
    }
    return CGRectMake(box.origin.x, box.origin.y, maxX - box.origin.x, maxY - box.origin.y);*/
}

-(CGPoint) absolutePosition{
    return [self convertToWorldSpace:ccp(0,0)];
}

-(CGPoint) center{
    CGRect box = self.boundingBox;
    return ccp(box.origin.x + box.size.width/2, box.origin.y + box.size.height/2);
}

#pragma mark - UI

-(void) handleAccelerated:(UIAcceleration*) acceleration{
}

-(BOOL)testPoint:(CGPoint)point {
    return (self.visible && CGRectContainsPoint(self.boundingBox, point));
}

-(void) handleTouchBegan{
}

-(void) handleTouchEnded{
}

-(void) draw {
    
    if(self.selected){
        float kSelectionPadding = 5;
        
        CGRect box = self.boundingBox;
        CGSize rectSize = CGSizeMake(self.contentSize.width + kSelectionPadding * 2, self.contentSize.height + kSelectionPadding * 2);
        
        CGPoint point = box.origin;
        point = [self convertToNodeSpace:point];
        point = ccpSub(point, ccp(kSelectionPadding, kSelectionPadding));
        
        //ccDrawSolidRect(point, ccp(point.x + rectSize.width, point.y + rectSize.height), ccc4FFromccc4B( kDefaultObjectSelectionColor));
        
        ccDrawRect(point, ccp(point.x + rectSize.width, point.y + rectSize.height));
    }
}
/*
-(void) addHighlightRect{
    _highlightNode = [[RoundedRectNode alloc] init];
    _highlightNode.borderWidth = 2;
    
    _highlightNode.fillColor = self.highlightColor;
    _highlightNode.borderColor = self.highlightColor;
    NSInteger alpha = _highlightNode.borderColor.a + 50;
    if(alpha > 255) alpha = 255;
    _highlightNode.borderColor = ccc4(self.highlightColor.r,self.highlightColor.g,self.highlightColor.b, alpha);
    _highlightNode.radius = 10;
    _highlightNode.cornerSegments = 12;
    [self updateBoxes];
    
    [self addChild:_highlightNode z: -2];
}

-(void) addSelectionRect{
    
    _selectionNode = [[RoundedRectNode alloc] init];
    _selectionNode.borderWidth = 2;
    _selectionNode.fillColor = ccc4(100, 100, 100, 100);
    _selectionNode.borderColor = ccc4(200, 200, 200, 200);
    _selectionNode.radius = 10;
    _selectionNode.cornerSegments = 12;
    [self updateBoxes];
    
    [self addChild:_selectionNode z: -1];
}*/

-(void) addSelectionLabel{
    _selectionLabel = [CCLabelTTF labelWithString:self.shortDescription dimensions:CGSizeMake(70, 20) hAlignment:NSTextAlignmentCenter vAlignment:NSTextAlignmentCenter fontName:kSimulatorDefaultFont fontSize:9];
    
    _selectionLabel.position = ccp(0,_sprite.contentSize.height/2 + 15);
    [self addChild:_selectionLabel z: 1];
}
/*
-(void) updateBoxes{
    
    float kSelectionPadding = 10;
    
    CGRect box = self.boundingBox;
     CGSize rectSize = CGSizeMake(self.contentSize.width + kSelectionPadding * 2, self.contentSize.height + kSelectionPadding * 2);
    
    CGPoint point = ccpAdd(box.origin,ccp(0,box.size.height));
    point = [self convertToNodeSpace:point];
    point = ccpAdd(point, ccp(-kSelectionPadding,kSelectionPadding));

    _selectionNode.position = point;
    _selectionNode.size = rectSize;
    
    _highlightNode.position = point;
    _highlightNode.size = rectSize;
}

-(void) setSelected:(BOOL)selected{
    if(self.selected != selected){
        _selected = selected;
        if(_selected){
            [self addSelectionRect];
            [self addSelectionLabel];
        } else {
            [_selectionNode removeFromParentAndCleanup:YES];
            _selectionNode = nil;
            [_selectionLabel removeFromParentAndCleanup:YES];
            _selectionLabel = nil;
        }
    }
}

-(void) setHighlighted:(BOOL)highlighted{
    if(self.highlighted != highlighted){
        _highlighted = highlighted;
        if(_highlighted){
            [self addHighlightRect];
        } else {
            [_highlightNode removeFromParentAndCleanup:YES];
            _highlightNode = nil;
        }
    }
}
*/
-(void) willStartSimulation {
    self.selected = NO;
        
    [self.simulableObject willStartSimulating];
}

-(void) didStartSimulation {
    [self.simulableObject didStartSimulating];
}

-(void) willStartEdition {
    
}

-(void) handleTap{}

-(void) handleRotation:(float) degree{}

-(void) prepareToDie{
        
    _triggerableProperties = nil;
    _viewableEditableProperties = nil;
    _invokableEditableProperties = nil;
    
    _connections = nil;
    
    [self.simulableObject prepareToDie];
    _simulableObject = nil;
    
    [self removeAllChildrenWithCleanup:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(NSString*) shortDescription{
    return @"";
}


-(NSString*) description{
    return @"Editable Object";
}

-(void) dealloc{
    if ([@"YES" isEqualToString: [[[NSProcessInfo processInfo] environment] objectForKey:@"printDeallocsEditableObjects"]]) {
        NSLog(@"deallocing %@",self);
    }
}

@end
