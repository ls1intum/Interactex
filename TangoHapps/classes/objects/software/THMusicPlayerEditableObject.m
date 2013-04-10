//
//  THMusicPlayerEditableObject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/23/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THMusicPlayerEditableObject.h"
#import "THMusicPlayerProperties.h"
#import "THMusicPlayer.h"

@implementation THMusicPlayerEditableObject

@dynamic volume;
@dynamic showPlayButton;
@dynamic showNextButton;
@dynamic showPreviousButton;

-(void) load{
    self.canBeRootView = NO;
    self.minSize = CGSizeMake(250, 100);
}

-(id) init{
    self = [super init];
    if(self){
        
        _visibleDuringSimulation = YES;
        self.simulableObject = [[THMusicPlayer alloc] init];
        [self load];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    [self load];
    
    self.visibleDuringSimulation = [decoder decodeBoolForKey:@"visibleDuringSimulation"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeBool:_visibleDuringSimulation forKey:@"visibleDuringSimulation"];
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THMusicPlayerProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(void) updateBoudingBox{
    if(self.showPlayButton || self.showNextButton || self.showPreviousButton){
        if(self.height < 100){
            self.height = 100;
            self.minSize = CGSizeMake(self.minSize.width,100);
        }
    } else{
        if(self.height > 60){
            self.height = 60;
            self.minSize = CGSizeMake(self.minSize.width,60);
        }
    }
}

-(void) setShowPlayButton:(BOOL)showPlayButton{
    
    THMusicPlayer * player = (THMusicPlayer*) self.simulableObject;
    player.showPlayButton = showPlayButton;
    
    [self updateBoudingBox];
}

-(BOOL) showPlayButton{
    THMusicPlayer * player = (THMusicPlayer*) self.simulableObject;
    return player.showPlayButton;
}

-(void) setShowNextButton:(BOOL)showNextButton{
    
    THMusicPlayer * player = (THMusicPlayer*) self.simulableObject;
    player.showNextButton = showNextButton;
    
    [self updateBoudingBox];
}

-(BOOL) showNextButton{
    THMusicPlayer * player = (THMusicPlayer*) self.simulableObject;
    return player.showNextButton;
}

-(void) setShowPreviousButton:(BOOL)showPreviousButton{
    
    THMusicPlayer * player = (THMusicPlayer*) self.simulableObject;
    player.showPreviousButton = showPreviousButton;
    
    [self updateBoudingBox];
}

-(BOOL) showPreviousButton{
    THMusicPlayer * player = (THMusicPlayer*) self.simulableObject;
    return player.showPreviousButton;
}

-(void) setVolume:(float)volume{
    
    THMusicPlayer * player = (THMusicPlayer*) self.simulableObject;
    player.volume = volume;
}

-(float) volume{
    THMusicPlayer * player = (THMusicPlayer*) self.simulableObject;
    return player.volume;
}

-(void) play{
    
    THMusicPlayer * player = (THMusicPlayer*) self.simulableObject;
    [player play];
}
-(void) stop{
    
    THMusicPlayer * player = (THMusicPlayer*) self.simulableObject;
    [player stop];
}

-(void) next{
    
    THMusicPlayer * player = (THMusicPlayer*) self.simulableObject;
    [player next];
}

-(void) setVisibleDuringSimulation:(BOOL)visible{
    if(_visibleDuringSimulation != visible){
        _visibleDuringSimulation = visible;
    }
    self.opacity = (_visibleDuringSimulation ? 1.0f : 0.5f);
}

-(void) willStartSimulation{
    self.simulableObject.visible = self.visibleDuringSimulation;
    
    [super willStartSimulation];
}

-(NSString*) description{
    return @"Music Player";
}

@end
