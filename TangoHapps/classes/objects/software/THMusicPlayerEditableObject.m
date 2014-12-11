/*
THMusicPlayerEditableObject.m
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

#import "THMusicPlayerEditableObject.h"
#import "THMusicPlayerProperties.h"
#import "THMusicPlayer.h"

@implementation THMusicPlayerEditableObject

@dynamic volume;
@dynamic showPlayButton;
@dynamic showNextButton;
@dynamic showPreviousButton;
@dynamic showVolumeView;

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
    if(self.height > 60){
        self.height = 60;
        self.minSize = CGSizeMake(self.minSize.width,60);
    }
    
    if(self.showPlayButton || self.showNextButton || self.showPreviousButton){
        if(self.height < 100){
            self.height = 100;
            self.minSize = CGSizeMake(self.minSize.width,100);
        }
    }
    
    if(self.showVolumeView){
        if(self.height < 140){
            self.height = 140;
            self.minSize = CGSizeMake(self.minSize.width,140);
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

-(void) setShowVolumeView:(BOOL)showVolumeView{
    
    THMusicPlayer * player = (THMusicPlayer*) self.simulableObject;
    player.showVolumeView = showVolumeView;
    
    [self updateBoudingBox];
}

-(BOOL) showVolumeView{
    
    THMusicPlayer * player = (THMusicPlayer*) self.simulableObject;
    return player.showVolumeView;
}

-(void) setVolume:(float)volume{
    
    THMusicPlayer * player = (THMusicPlayer*) self.simulableObject;
    [player setVolume:volume];
}

-(float) volume{
    THMusicPlayer * player = (THMusicPlayer*) self.simulableObject;
    return [player volume];
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
