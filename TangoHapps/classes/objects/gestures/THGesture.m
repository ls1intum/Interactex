//
//  THGestures.m
//  TangoHapps
//
//  Created by Timm Beckmann on 03/04/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THGesture.h"
#import "THHardwareComponentEditableObject.h"
#import "THGesturePaletteItem.h"
#import "THCustomPaletteItem.h"
#import "THGestureLayer.h"

@implementation THGesture

-(void) load{
    
    self.sprite = [CCSprite spriteWithFile:@"gesture.png"];
    [self addChild:self.sprite];
    
    self.z = kClotheZ;
    
    self.canBeAddedToPalette = YES;
    
    _attachments = [NSMutableArray array];
    
    _layer = [[THGestureLayer alloc] init];

}

-(id) initWithName:(NSString*) name{
    self = [super init];
    if(self){
        self.name = name;
        [self load];
    }
    return self;
}


#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        self.name = [decoder decodeObjectForKey:@"name"];
        
        [self load];
        
        NSArray * attachments = [decoder decodeObjectForKey:@"attachments"];
        for (THHardwareComponentEditableObject * attachment in attachments) {
            [self attachGestureObject:attachment];
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:_attachments forKey:@"attachments"];
}

-(id)copyWithZone:(NSZone *)zone {
    THGesture * copy = [super copyWithZone:zone];
    copy.name = self.name;

    [copy load];
    
    for (TFEditableObject * attachment in _attachments) {
        [copy attachGestureObject:[attachment copy]];
    }
    
    return copy;
}


#pragma mark - Property Controllers

/*-(NSArray*)propertyControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THClotheProperties properties]];
    return controllers;
}*/

#pragma mark - World and Layer

-(void) addToWorld{
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addGesture:self];
    
    for (TFEditableObject * attachment in _attachments) {
        [attachment addToWorld];
    }
}

-(void) removeFromWorld{
    NSMutableArray * attachments = [NSMutableArray arrayWithArray:_attachments];
    for (TFEditableObject * object in attachments) {
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
    return paletteItem;
}

-(void) objectRemoved:(NSNotification*) notification{
    TFEditableObject * object = notification.object;
    [_attachments removeObject:object];
}

-(void) attachGestureObject:(THHardwareComponentEditableObject*) object{
    
    [_attachments addObject:object];
    [self addChild:object z:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(objectRemoved:) name:kNotificationObjectRemoved object:object];
}

-(void) deattachGestureObject:(THHardwareComponentEditableObject*) object{
    
    [_attachments removeObject:object];
    [object removeFromParentAndCleanup:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationObjectRemoved object:object];
}

-(void) open {
    NSLog(@"Opened Layer");
    [_layer show];
}

-(NSString*) description{
    return @"Gesture";
}

-(void) prepareToDie{
    
    _attachments = nil;
    [super prepareToDie];
}

@end
