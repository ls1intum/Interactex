//
//  THClothe.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/7/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THClothe.h"
#import "THHardwareComponentEditableObject.h"
#import "THClothePaletteItem.h"
#import "THClotheProperties.h"
#import "THCustomPaletteItem.h"

@implementation THClothe

-(void) loadSprite{
    if(_imageFromName){
        NSString * fileName = [NSString stringWithFormat:@"%@.png",self.name];
        _image = [UIImage imageNamed:fileName];
        self.sprite = [CCSprite spriteWithFile:fileName];
    } else {
        self.sprite = [CCSprite spriteWithCGImage:_image.CGImage key:nil];
    }
    [self addChild:self.sprite];
}

-(void) load{
    
    [self loadSprite];
    self.z = kClotheZ;
    
    _attachments = [NSMutableArray array];
}

-(id) initWithName:(NSString*) name{
    self = [super init];
    if(self){
        self.name = name;
        _imageFromName = YES;
        [self load];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        self.name = [decoder decodeObjectForKey:@"name"];
        _image = [decoder decodeObjectForKey:@"image"];
        _imageFromName = [decoder decodeBoolForKey:@"imageFromName"];
        
        [self load];
        
        NSArray * attachments = [decoder decodeObjectForKey:@"attachments"];
        for (THHardwareComponentEditableObject * attachment in attachments) {
            [self attachClotheObject:attachment];
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.image forKey:@"image"];
    [coder encodeBool:_imageFromName forKey:@"imageFromName"];
    [coder encodeObject:_attachments forKey:@"attachments"];
}

-(id)copyWithZone:(NSZone *)zone {
    THClothe * copy = [super copyWithZone:zone];
    copy.name = self.name;
    copy.imageFromName = self.imageFromName;
    copy.image = self.image;
    [copy load];
    
    for (TFEditableObject * attachment in _attachments) {
        [copy attachClotheObject:[attachment copy]];
    }
    
    return copy;
}

#pragma mark - Property Controllers

-(NSArray*)propertyControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THClotheProperties properties]];
    return controllers;
}

#pragma mark - World and Layer

-(void) addToWorld{
    THCustomProject * project = (THCustomProject*) [THDirector sharedDirector].currentProject;
    [project addClothe:self];
    
    for (TFEditableObject * attachment in _attachments) {
        [attachment addToWorld];
    }
}

-(void) removeFromWorld{
    NSMutableArray * attachments = [NSArray arrayWithArray:_attachments];
    for (TFEditableObject * object in attachments) {
        [object removeFromWorld];
    }
    
    THCustomProject * project = (THCustomProject*) [THDirector sharedDirector].currentProject;
    [project removeClothe:self];
    [super removeFromWorld];
}

-(void) addToLayer:(TFLayer*) layer{
    [layer addEditableObject:self];
}

-(void) removeFromLayer:(TFLayer*) layer{
    [layer removeEditableObject:self];
}

#pragma mark - Methods

-(void) setImage:(UIImage *)image{
    if(image != _image){
        [self.sprite removeFromParentAndCleanup:YES];
        
        CCSprite * sprite = [CCSprite spriteWithCGImage:image.CGImage key:nil];
        self.sprite = sprite;
        [self addChild:sprite];
        
        _image = image;
        
        _imageFromName = NO;
    }
}

-(void) setName:(NSString *)name{
    _name = name;
}

-(THPaletteItem*) paletteItem{
    THClothePaletteItem * paletteItem = [THCustomPaletteItem customPaletteItemWithName:self.name object:self];
    return paletteItem;
}

-(void) setPosition:(CGPoint)position{
    
    for (THHardwareComponentEditableObject * object in _attachments) {
        CGPoint diff = ccpSub(object.position, self.position);
        object.position  = ccpAdd(diff, position);
    }
    
    [super setPosition:position];
}

-(void) objectRemoved:(NSNotification*) notification{
    TFEditableObject * object = notification.object;
    [_attachments removeObject:object];
}

-(void) attachClotheObject:(THHardwareComponentEditableObject*) object{
    
    [_attachments addObject:object];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(objectRemoved:) name:kNotificationObjectRemoved object:object];
    object.attachedToClothe = self;
}

-(void) deattachClotheObject:(THHardwareComponentEditableObject*) object{
    
    [_attachments removeObject:object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationObjectRemoved object:object];
    
    object.attachedToClothe = nil;
}

-(NSString*) description{
    return @"Clothe";
}

-(void) prepareToDie{
    
    _attachments = nil;
    [super prepareToDie];
}

@end
