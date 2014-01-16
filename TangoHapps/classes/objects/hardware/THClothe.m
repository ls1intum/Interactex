/*
THClothe.m
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
    
    self.canBeAddedToPalette = YES;
    
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
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addClothe:self];
    
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

/*
-(void) setPosition:(CGPoint)position{
    
    for (THHardwareComponentEditableObject * object in _attachments) {
        CGPoint diff = ccpSub(object.position, self.position);
        object.position  = ccpAdd(diff, position);
    }
    
    [super setPosition:position];
}*/

-(void) objectRemoved:(NSNotification*) notification{
    TFEditableObject * object = notification.object;
    [_attachments removeObject:object];
}

-(void) attachClotheObject:(THHardwareComponentEditableObject*) object{
    
    [_attachments addObject:object];
    [self addChild:object z:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(objectRemoved:) name:kNotificationObjectRemoved object:object];
    object.attachedToClothe = self;
}

-(void) deattachClotheObject:(THHardwareComponentEditableObject*) object{
    
    [_attachments removeObject:object];
    [object removeFromParentAndCleanup:YES];
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
