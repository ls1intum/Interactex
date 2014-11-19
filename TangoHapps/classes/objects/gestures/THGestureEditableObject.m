//
//  THGestures.m
//  TangoHapps
//
//  Created by Timm Beckmann on 03/04/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THInvocationConnectionLine.h"
#import "TFEventActionPair.h"
#import "THGestureEditableObject.h"
#import "THGesturePaletteItem.h"
#import "THCustomPaletteItem.h"
#import "THGestureProperties.h"

@implementation THGestureEditableObject

-(void) load{
    
    if (_isOpen) {
        self.sprite = [CCSprite spriteWithFile:@"whiteBox.png"];
    }
    else {
        self.sprite = [CCSprite spriteWithFile:@"gesture.png"];
    }
    [self addChild:self.sprite];
        
    self.canBeAddedToPalette = YES;
    self.canBeAddedToGesture = YES;
    self.acceptsConnections = NO;
    
    /*_layer = [CCLayerColor node];
    _layer.color = ccc3(200, 200, 200);
    _layer.opacity = 255;
    _layer.contentSize = self.sprite.boundingBox.size;
    [self addChild:_layer];*/
    
    if(_isOpen) {
        [self visibleCont];
    }
    else {
        [self invisibleCont];
    }
    
    self.z = kGestureZ;
    
    _outputs = [NSMutableArray array];
    _inputs = [NSMutableArray array];
    _connections = [NSMutableArray array];
    _attachments = [NSMutableArray array];

}

-(id) initWithName:(NSString*) name{
    self = [super init];
    if(self){
        self.name = name;
        self.inCount = 0;
        self.outCount= 0;
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
        
        self.scale = [decoder decodeFloatForKey:@"scaling"];

        NSArray * attachments = [decoder decodeObjectForKey:@"attachments"];
        for (TFEditableObject * attachment in attachments) {
            [self attachGestureObject:attachment];
        }
        
        NSArray * outputs = [decoder decodeObjectForKey:@"outputs"];
        for (THOutputEditable * obj in outputs) {
            _outCount++;
            [self attachOutput:obj];
        }
        
        NSArray * inputs = [decoder decodeObjectForKey:@"inputs"];
        for (THOutputEditable * obj in inputs) {
            _inCount++;
            [self attachInput:obj];
        }
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.name forKey:@"name"];
    
    [coder encodeObject:self.saveName forKey:@"saveName"];
    
    [coder encodeBool:self.isOpen forKey:@"isOpen"];
    
    [coder encodeFloat:self.scale forKey:@"scaling"];
    
    [coder encodeObject:self.attachments forKey:@"attachments"];
    
    [coder encodeObject:_outputs forKey:@"outputs"];
    
    [coder encodeObject:_inputs forKey:@"inputs"];

}

-(id)copyWithZone:(NSZone *)zone {
    THGestureEditableObject * copy = [super copyWithZone:zone];
    
    copy.name = self.name;
    copy.saveName = self.saveName;
    copy.inCount = self.inCount;
    copy.outCount = self.outCount;

    [copy load];
    
    copy.scale = self.scale;
    
    THProject * project = [THDirector sharedDirector].currentProject;
    
    
    for (TFEditableObject * obj1 in self.attachments) {
        for (TFEditableObject * obj2 in self.attachments) {
            NSArray * arr = [project invocationConnectionsFrom:obj1 to:obj2];
            for (THInvocationConnectionLine * line in arr) {
                [_connections addObject:[line copy]];
            }
        }
        for (TFEditableObject * obj2 in _inputs) {
            NSArray * arr = [project invocationConnectionsFrom:obj1 to:obj2];
            for (THInvocationConnectionLine * line in arr) {
                [_connections addObject:[line copy]];
            }
        }
        for (TFEditableObject * obj2 in _outputs) {
            NSArray * arr = [project invocationConnectionsFrom:obj1 to:obj2];
            for (THInvocationConnectionLine * line in arr) {
                [_connections addObject:[line copy]];
            }
        }
    }
    
    
    for (TFEditableObject * attachment in self.attachments) {
        TFEditableObject* cop = [attachment copy];
        [copy attachGestureObject:cop];
        //THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
        //[project addGesture:cop];
        for (THInvocationConnectionLine * line in _connections) {
            if (attachment == line.obj1) {
                line.obj1 = cop;
                line.action.source = cop;
                line.action.firstParam.target = cop;
            }
            else if (attachment == line.obj2) {
                line.obj2 = cop;
                line.action.target = cop;
            }
        }
    }
    
    
    for (THOutputEditable * obj in _outputs) {
        THOutputEditable* cop = [obj copy];
        [copy attachOutput:cop];
        //THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
        //[project addGesture:cop];
        for (THInvocationConnectionLine * line in _connections) {
            if (obj == line.obj1) {
                line.obj1 = cop;
                line.action.source = cop;
                line.action.firstParam.target = cop;
            }
            else if (obj == line.obj2) {
                line.obj2 = cop;
                line.action.target = cop;
            }
        }
    }
    
    for (THOutputEditable * obj in _inputs) {
        THOutputEditable* cop = [obj copy];
        [copy attachInput:cop];
        for (THInvocationConnectionLine * line in _connections) {
            if (obj == line.obj1) {
                line.obj1 = cop;
                line.action.source = cop;
                line.action.firstParam.target = cop;
            }
            else if (obj == line.obj2) {
                line.obj2 = cop;
                line.action.target = cop;
            }
        }
    }
    
    for (THInvocationConnectionLine * line in _connections) {

        [project addInvocationConnection:line animated:YES];
        
        TFEvent* event;
        for (TFEvent * ev in line.obj1.events) {
            if (line.event.name == ev.name)
                event = ev;
        }

        [project registerAction:(TFAction*)line.action forEvent:event];
    }
    
    [_connections removeAllObjects];
    
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
    
    for (TFEditableObject * attachment in self.attachments) {
        [attachment addToWorld];
    }
    
    for (THOutputEditable * output in _outputs) {
        [output addToWorld];
    }
    
    for (THOutputEditable * input in _inputs) {
        [input addToWorld];
    }
}

-(void) removeFromWorld{
    for (TFEditableObject * object in self.attachments) {
        [object removeFromWorld];
    }
    
    for (THOutputEditable * object in _outputs) {
        [object removeFromWorld];
    }
    
    for (THOutputEditable * object in _inputs) {
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
    [_attachments removeObject:object];
}

-(void) attachGestureObject:(TFEditableObject*) object{
    [self.attachments addObject:object];
    [self addChild:object z:1];
    //if (object.scale ==1)
    if (object.scale >=1) object.scale /= 8;
    if (!_isOpen) object.visible = false;
    object.attachedToGesture = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(objectRemoved:) name:kNotificationObjectRemoved object:object];
}

-(void) deattachGestureObject:(TFEditableObject*) object{
    [_attachments removeObject:object];
    [object removeFromParentAndCleanup:YES];
    object.scale *= 8;
    object.attachedToGesture = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationObjectRemoved object:object];
}

-(void) scale:(float)amount {
    if (!self.attachedToGesture) {
        [self scaleBy:amount];
        self.scale = clampf(self.scale, 2, 15);
    }
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
    [self.sprite removeFromParentAndCleanup:YES];
    self.sprite = [CCSprite spriteWithFile:@"whiteBox.png"];
    [self addChild:self.sprite z:-10];
    self.z = kGestureZ;
    for (TFEditableObject * obj in _attachments) {
        obj.visible = true;
    }
}

-(void) invisibleCont {
    [self.sprite removeFromParentAndCleanup:YES];
    self.sprite = [CCSprite spriteWithFile:@"gesture.png"];
    [self addChild:self.sprite z:-10];
    self.z = kGestureObjectZ;
    //[gest invisible];
}

-(void) outputAmountChanged:(int)count {
    if (count > _outCount) {
        [self addOutput];
    }
    else if (count < _outCount) {
        [self deleteOutput];
    }
}

-(void) inputAmountChanged:(int)count {
    if (count > _inCount) {
        [self addInput];
    }
    else if (count < _inCount) {
        [self deleteInput];
    }
}

-(void) attachOutput:(THOutputEditable *)object {
    [self addChild:object z:1];
    object.scale /= 8;
    object.attachedToGesture = self;
    
    [_outputs addObject:object];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outputRemoved:) name:kNotificationObjectRemoved object:object];
}

-(void) addOutput {
    THOutputEditable * object = [[THOutputEditable alloc] init];
    
    _outCount++;
    
    [self attachOutput:object];
    
    CGPoint position = ccp(0,0);
    
    position.y -= 5 * 1.0f;
    position.x += _outCount * 75.0f/(5.f) - 10.0f;
    
    object.position = position;
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addOutput:object];
    
}

-(void) outputRemoved:(NSNotification*) notification{
    //THOutputEditable * object = notification.object;
    //[self deattachOutput:object];
}

-(void) deattachOutput:(THOutputEditable *)object {
    _outCount--;
    [_outputs removeObject:object];
    [object removeFromParentAndCleanup:YES];
    object.scale *= 8;
    object.attachedToGesture = nil;
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project removeOutput:object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationObjectRemoved object:object];
}

-(void) deleteOutput {
    THOutputEditable * object = [_outputs lastObject];
    [self deattachOutput:object];
    
}

-(void) attachInput:(THOutputEditable *)object {
    [self addChild:object z:1];
    object.scale /= 8;
    object.attachedToGesture = self;
    
    [_inputs addObject:object];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outputRemoved:) name:kNotificationObjectRemoved object:object];
}

-(void) addInput {
    THOutputEditable * object = [[THOutputEditable alloc] init];
    
    _inCount++;
    
    [self attachInput:object];
    
    CGPoint position = ccp(0,0);
    
    position.y += 80.f;
    position.x += _inCount * 75.0f/(5.f) - 8.0f;
    
    object.position = position;
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addOutput:object];
}

-(void) deattachInput:(THOutputEditable *) object {
    _inCount--;
    [_inputs removeObject:object];
    [object removeFromParentAndCleanup:YES];
    object.scale *= 8;
    object.attachedToGesture = nil;
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project removeOutput:object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationObjectRemoved object:object];
}

-(void) deleteInput {
    THOutputEditable * object = [_inputs lastObject];
    [self deattachInput:object];
}

-(NSString*) description{
    return @"Gesture";
}

-(void) prepareToDie{
    [self.attachments removeAllObjects];
    [super prepareToDie];
}

@end
