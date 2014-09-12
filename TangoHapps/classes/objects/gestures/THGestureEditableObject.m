//
//  THGestures.m
//  TangoHapps
//
//  Created by Timm Beckmann on 03/04/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THGestureEditableObject.h"
#import "THGesturePaletteItem.h"
#import "THCustomPaletteItem.h"
#import "THGestureProperties.h"
#import "THGesture.h"

@implementation THGestureEditableObject

-(void) load{
    
    self.simulableObject = [[THGesture alloc] init];
    
    self.sprite = [CCSprite spriteWithFile:@"gesture.png"];
    [self addChild:self.sprite];
        
    self.canBeAddedToPalette = YES;
    self.canBeAddedToGesture = YES;
    self.acceptsConnections = NO;
    
    _layer = [CCLayerColor node];
    _layer.color = ccc3(200, 200, 200);
    _layer.opacity = 255;
    _layer.contentSize = self.sprite.boundingBox.size;
    [self addChild:_layer];
    
    if(_isOpen) {
        [self visibleCont];
    }
    else {
        [self invisibleCont];
    }
    
    _outputs = [NSMutableArray array];

}

-(id) initWithName:(NSString*) name{
    self = [super init];
    if(self){
        self.name = name;
        self.count = 0;
        self.isOpen = false;
        
        [self load];
    }
    return self;
}


#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        
        self.name = [decoder decodeObjectForKey:@"name"];
        self.saveName = [decoder decodeObjectForKey:@"saveName"];
        self.isOpen = [decoder decodeBoolForKey:@"isOpen"];
        
        [self load];

        NSArray * attachments = [decoder decodeObjectForKey:@"attachments"];
        for (TFEditableObject * attachment in attachments) {
            [self attachGestureObject:attachment];
        }
        
        NSArray * outputs = [decoder decodeObjectForKey:@"outputs"];
        for (THOutputEditable * obj in outputs) {
            _count++;
            [self attachOutput:obj];
        }
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.name forKey:@"name"];
    
    [coder encodeObject:self.saveName forKey:@"saveName"];
    
    [coder encodeBool:self.isOpen forKey:@"isOpen"];
    
    [coder encodeObject:[self getAttachments] forKey:@"attachments"];
    
    [coder encodeObject:_outputs forKey:@"outputs"];

}

-(id)copyWithZone:(NSZone *)zone {
    THGestureEditableObject * copy = [super copyWithZone:zone];
    
    copy.name = self.name;
    copy.saveName = self.saveName;
    copy.count = self.count;

    [copy load];
    
    for (TFEditableObject * attachment in [self getAttachments]) {
        [copy attachGestureObject:[attachment copy]];
    }
    
    for (THOutputEditable * obj in _outputs) {
        [copy attachOutput:[obj copy]];
    }
    
    return copy;
}


#pragma mark - Property Controllers

-(NSArray*)propertyControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THGestureProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - World and Layer

-(void) addToWorld{
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addGesture:self];
    
    for (TFEditableObject * attachment in [self getAttachments]) {
        [attachment addToWorld];
    }
    
    for (THOutputEditable * output in _outputs) {
        [output addToWorld];
    }
}

-(void) removeFromWorld{
    NSMutableArray * attachments = [NSMutableArray arrayWithArray:[self getAttachments]];
    for (TFEditableObject * object in attachments) {
        [object removeFromWorld];
    }
    
    for (THOutputEditable * object in _outputs) {
        [object removeFromWorld];
    }
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project removeGesture:self];
    [super removeFromWorld];
}

-(void) addToLayer:(TFLayer*) layer{
    [layer addEditableObject:self];
}

-(void) removeFromLayer:(TFLayer*) layer{
    [layer removeEditableObject:self];
}

#pragma mark - Methods

-(THPaletteItem*) paletteItem{
    THGesturePaletteItem * paletteItem = [THCustomPaletteItem customPaletteItemWithName:self.name object:self];
    paletteItem.saveName = _saveName;
    return paletteItem;
}

-(void) objectRemoved:(NSNotification*) notification{
    TFEditableObject * object = notification.object;
    THGesture* gest = (THGesture *) self.simulableObject;
    [gest deattachGestureObject:object];
}

-(void) attachGestureObject:(TFEditableObject*) object{
    THGesture* gest = (THGesture *) self.simulableObject;
    [gest attachGestureObject:object];
    [self addChild:object z:1];
    if (object.scale ==1) object.scale /= 15;
    if (!_layer.visible) object.visible = false;
    object.attachedToGesture = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(objectRemoved:) name:kNotificationObjectRemoved object:object];
}

-(void) deattachGestureObject:(TFEditableObject*) object{
    THGesture* gest = (THGesture *) self.simulableObject;
    [gest deattachGestureObject:object];
    [object removeFromParentAndCleanup:YES];
    object.scale = 1;
    object.attachedToGesture = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationObjectRemoved object:object];
}

-(void) openClose {
    _isOpen = !_isOpen;
    
    if (_isOpen) {
        [self visibleCont];
    } else {
        [self invisibleCont];
    }
}

-(void) visibleCont {
    THGesture* gest = (THGesture *) self.simulableObject;
    _layer.visible = true;
    self.scale = 10;
    self.z = kGestureZ;
    [gest visible];
}

-(void) invisibleCont {
    THGesture* gest = (THGesture *) self.simulableObject;
    _layer.visible = false;
    self.scale = 1;
    self.z = kGestureObjectZ;
    [gest invisible];
}

-(void) outputAmountChanged:(int)count {
    if (count > _count) {
        [self addOutput];
    }
    else if (count < _count) {
        [self deleteOutput];
    }
}

-(void) attachOutput:(THOutputEditable *)object {
    [self addChild:object z:1];
    if (object.scale ==1) object.scale /= 15;
    object.attachedToGesture = self;
    
    [_outputs addObject:object];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outputRemoved:) name:kNotificationObjectRemoved object:object];
}

-(void) addOutput {
    THOutputEditable * object = [[THOutputEditable alloc] init];
    
    _count++;
    
    [self attachOutput:object];
    
    CGPoint position = ccp(0,0);
    
    position.y -= 5 * 0.6f;
    position.x += _count * 50.0f/(5.f) - 5.0f;
    
    object.position = position;
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addGesture:object];
    
}

-(void) outputRemoved:(NSNotification*) notification{
    TFEditableObject * object = notification.object;
    [self deattachGestureObject:object];
}

-(void) deattachOutput:(THOutputEditable *)object {
    _count--;
    [_outputs removeObject:object];
    [object removeFromParentAndCleanup:YES];
    object.scale = 1;
    object.attachedToGesture = nil;
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project removeGesture:object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationObjectRemoved object:object];
}

-(void) deleteOutput {
    THOutputEditable * object = [_outputs lastObject];
    [self deattachOutput:object];
    
}

-(NSMutableArray*) getAttachments {
    THGesture * gest = (THGesture *) self.simulableObject;
    return gest.attachments;
}

-(NSString*) description{
    return @"Gesture";
}

-(void) prepareToDie{
    THGesture* gest = (THGesture *) self.simulableObject;
    [gest emptyAttachments];
    [super prepareToDie];
}

@end
