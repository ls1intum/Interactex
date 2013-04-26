//
//  THSoundEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 4/23/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THSoundEditable.h"
#import "THSound.h"
#import "THSoundProperties.h"

@implementation THSoundEditable

@dynamic fileName;

-(void) loadTimer{
    self.sprite = [CCSprite spriteWithFile:@"sound.png"];
    [self addChild:self.sprite];
    
    self.acceptsConnections = YES;
}

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THSound alloc] init];
        
        [self loadTimer];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        [self loadTimer];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THSoundEditable * copy = [super copyWithZone:zone];
    
    return copy;
}


#pragma mark - Property Controller

-(NSArray*)propertyControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THSoundProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(void) setFileName:(NSString *)fileName{
    
    THSound * sound = (THSound*) self.simulableObject;
    sound.fileName = fileName;
}

-(NSString*) fileName{
    
    THSound * sound = (THSound*) self.simulableObject;
    return sound.fileName;
}

-(void) play{
    THSound * sound = (THSound*) self.simulableObject;
    [sound play];
}

-(void) update{
    
}

-(NSString*) description{
    return @"Sound";
}

@end
