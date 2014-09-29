/*
THMusicPlayer.m
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

#import "THMusicPlayer.h"

@implementation THMusicPlayer

@dynamic volume;
@synthesize playing = _playing;

float const kMusicPlayerButtonWidth = 30;
float const kMusicPlayerButtonHeight = 30;
float const kMusicPlayerLabelHeight = 40;
float const kMusicPlayerInnerPadding = 10;

NSString * const kPlayImageName = @"musicPlay.png";
NSString * const kPauseImageName = @"pause.png";

-(id) init{
    self = [super init];
    if(self){
        
        self.width = 260;
        self.height = 100;
        
        _showPlayButton = YES;
        _showNextButton = YES;
        _showPreviousButton = YES;
        
        [self loadMusicPlayer];
        
        self.text = @"";
    }
    return self;
}

-(UIButton*) buttonWithFrame:(CGRect) frame imageName:(NSString*) name{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = frame;
    UIImage * playImage = [UIImage imageNamed:name];
    [button setBackgroundImage:playImage forState:UIControlStateNormal];
    button.enabled = NO;
    
    return button;
}

-(void) checkAddRemovePreviousButton{
    if(self.showPreviousButton){
        [self.view addSubview:_previousButton];
    } else {
        [_previousButton removeFromSuperview];
    }
}

-(void) checkAddRemovePlayButton{
    if(self.showPlayButton){
        [self.view addSubview:_playButton];
    } else {
        [_playButton removeFromSuperview];
    }
}

-(void) checkAddRemoveNextButton{
    if(self.showNextButton){
        [self.view addSubview:_nextButton];
    } else {
        [_nextButton removeFromSuperview];
    }
}


-(void) loadMusicPlayerViews{
    UIView * containerView = [[UIView alloc] init];
    containerView.bounds = CGRectMake(0, 0, self.width, self.height);
    containerView.layer.cornerRadius = 5.0f;
    containerView.layer.borderWidth = 1.0f;
    self.view = containerView;
    
    UIImage * image =  [UIImage imageNamed:@"music"];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame= CGRectMake(5, 5, image.size.width, image.size.height);
    [containerView addSubview:imageView];
        
    _label = [[UILabel alloc] init];
    _label.layer.borderWidth = 1.0f;
    CGRect imageFrame = imageView.frame;
    float x = imageFrame.origin.x + imageFrame.size.width + kMusicPlayerInnerPadding;
    _label.frame = CGRectMake(x, 5, self.width - imageFrame.size.width - 20, kMusicPlayerLabelHeight);
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:12];
    _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    [containerView addSubview:_label];
    
    
    CGRect previousButtonFrame = CGRectMake(60, _label.frame.origin.y + _label.frame.size.height + kMusicPlayerInnerPadding, kMusicPlayerButtonWidth, kMusicPlayerButtonHeight);
    _previousButton = [self buttonWithFrame:previousButtonFrame imageName:@"backwards.png"];
    [_previousButton addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchDown];
    
    CGRect playButtonFrame = CGRectMake(120, _label.frame.origin.y + _label.frame.size.height + kMusicPlayerInnerPadding, kMusicPlayerButtonWidth, kMusicPlayerButtonHeight);
    _playButton = [self buttonWithFrame:playButtonFrame imageName:kPlayImageName];
    [_playButton addTarget:self action:@selector(togglePlay) forControlEvents:UIControlEventTouchDown];
    
    CGRect nextButtonFrame = CGRectMake(180, _label.frame.origin.y + _label.frame.size.height + kMusicPlayerInnerPadding, kMusicPlayerButtonWidth, kMusicPlayerButtonHeight);
    _nextButton = [self buttonWithFrame:nextButtonFrame imageName:@"forward.png"];
    [_nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchDown];
    
    [self checkAddRemovePreviousButton];
    [self checkAddRemovePlayButton];
    [self checkAddRemoveNextButton];
}

-(void) reloadView{
    [self loadMusicPlayerViews];
}

-(void) registerEvents{
#if !(TARGET_IPHONE_SIMULATOR)
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self selector:@selector (handleCurrentSongChanged) name:      MPMusicPlayerControllerNowPlayingItemDidChangeNotification
     object: _musicPlayer];
    
    [notificationCenter addObserver: self selector:@selector (handleCurrentPlayerStateChanged) name:      MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object: _musicPlayer];    
    
    [_musicPlayer beginGeneratingPlaybackNotifications];
#endif
}

-(void) deregisterEvents{
    
}

-(void) loadMusicPlayer{
    [self loadMusicPlayerViews];
    
#if (TARGET_IPHONE_SIMULATOR)
    _songs = [NSMutableArray arrayWithObjects:@"song1",@"song2",@"song3", nil];
#else
    
    _musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    MPMediaQuery * songsQuery = [MPMediaQuery songsQuery];
    [_musicPlayer setQueueWithQuery:songsQuery];
    _songs = songsQuery.items;
#endif

    TFProperty * property1 = [TFProperty propertyWithName:@"volume" andType:kDataTypeFloat];
    self.properties = [NSMutableArray arrayWithObject:property1];
    
    TFMethod * method1 = [TFMethod methodWithName:@"play"];
    TFMethod * method2 = [TFMethod methodWithName:@"stop"];
    TFMethod * method3 = [TFMethod methodWithName:@"next"];
    TFMethod * method4 = [TFMethod methodWithName:@"previous"];
    TFMethod * method5 = [TFMethod methodWithName:@"setVolume"];
    method5.firstParamType = kDataTypeFloat;
    method5.numParams = 1;
    self.methods = [NSMutableArray arrayWithObjects:method1, method2, method3, method4, method5, nil];
    
    [self registerEvents];
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    _showPlayButton = [decoder decodeBoolForKey:@"showPlayButton"];
    _showNextButton = [decoder decodeBoolForKey:@"showNextButton"];
    _showPreviousButton = [decoder decodeBoolForKey:@"showPreviousButton"];
    
    [self loadMusicPlayer];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeBool:_showPlayButton forKey:@"showPlayButton"];
    [coder encodeBool:_showNextButton forKey:@"showNextButton"];
    [coder encodeBool:_showPreviousButton forKey:@"showPreviousButton"];
}

#pragma mark - Music player events

-(void) handleCurrentSongChanged{
    [self updateLabel];
}

-(void) handleCurrentPlayerStateChanged{
    if(_musicPlayer.playbackState == MPMusicPlaybackStatePlaying){
        NSLog(@"playing");
        
        _playing = YES;
    } else {
        
        _playing = NO;
        NSLog(@"stopped");
    }
}

#pragma mark - Methods

-(void) setShowPlayButton:(BOOL)showPlayButton{
    if(showPlayButton != self.showPlayButton){
        _showPlayButton = showPlayButton;
        
        [self checkAddRemovePlayButton];
    }
}

-(void) setShowNextButton:(BOOL)showNextButton{
    if(showNextButton != self.showNextButton){
        _showNextButton = showNextButton;
        [self checkAddRemoveNextButton];
    }
}

-(void) setShowPreviousButton:(BOOL)showPreviousButton{
    if(showPreviousButton != self.showPreviousButton){
        _showPreviousButton = showPreviousButton;
        [self checkAddRemovePreviousButton];
    }
}

//TODO fix volume since iOS 7 needs volumeView
-(void) setVolume:(float)volume{
    /*
#if !(TARGET_IPHONE_SIMULATOR)
    _musicPlayer.
    _musicPlayer.volume = volume;
    #else
    
#endif*/
}

-(float) volume{
    return 1.0f;
    /*
    
#if (TARGET_IPHONE_SIMULATOR)
    return 1;
#else
    return _musicPlayer.volume;
#endif
                 */
}

-(void) setText:(NSString *)text{
    
    _label.text = text;
}

-(NSString*) text{
    return _label.text;
}

-(NSString*) description{
    return @"music player";
}

-(NSString*) currentSong{
#if (TARGET_IPHONE_SIMULATOR)
    
    return [_songs objectAtIndex:_currentSongIdx];
#else
    
    //MPMediaQuery * songsQuery = [MPMediaQuery songsQuery];
    //MPMediaItem * song = [songsQuery.items objectAtIndex:_currentSongIdx];
    MPMediaItem * song = _musicPlayer.nowPlayingItem;
    if(song){
        return [song valueForProperty: MPMediaItemPropertyTitle];
    } else {
        return nil;
    }
    
#endif
}

-(BOOL) playing{
#if (TARGET_IPHONE_SIMULATOR)
    return _playing;
#else
    NSLog(@"state: %d",_musicPlayer.playbackState);
    
    return _musicPlayer.playbackState == MPMusicPlaybackStatePlaying;
#endif
}
           
-(void) togglePlay{
    
    if(self.playing){
        [self pause];
    } else {
        [self play];
    }
}

-(void) play{
#if (TARGET_IPHONE_SIMULATOR)
    //NSString * fileName = [self.currentSong stringByAppendingFormat:@".mp3"];
    //[[CDAudioManager sharedManager] playBackgroundMusic:fileName loop:NO];
    _playing = YES;

#else
    [_musicPlayer play];
#endif
    
    [self updateLabel];
    
    if(_playButton != nil){
        UIImage * playImage = [UIImage imageNamed:kPauseImageName];
        [_playButton setBackgroundImage:playImage forState:UIControlStateNormal];
    }
}

-(void) pause{
#if (TARGET_IPHONE_SIMULATOR)
    //[[CDAudioManager sharedManager] stopBackgroundMusic];
    _playing = NO;
#else
    [_musicPlayer pause];
#endif
    
    if(_playButton != nil){
        UIImage * playImage = [UIImage imageNamed:kPlayImageName];
        [_playButton setBackgroundImage:playImage forState:UIControlStateNormal];
    }
}

-(void) stop{
    
#if (TARGET_IPHONE_SIMULATOR)
    //[self pause];
#else
    [_musicPlayer stop];
#endif
    
    [self updateLabel];
}

-(void) next{
#if (TARGET_IPHONE_SIMULATOR)
    _currentSongIdx ++;
    if(_currentSongIdx >= _songs.count){
        _currentSongIdx = 0;
    }
    //[self play];
#else
    [_musicPlayer skipToNextItem];
#endif
}

-(void) previous{
#if (TARGET_IPHONE_SIMULATOR)
    _currentSongIdx --;
    if(_currentSongIdx < 0){
        _currentSongIdx = _songs.count - 1;
    }
    [self play];
#else
    [_musicPlayer skipToPreviousItem];
#endif
    
}

-(void) updateLabel{
    NSString * currentSong  = self.currentSong;
    if(currentSong){
        [self setText:self.currentSong];
    } else {
        [self setText:@"Not playing"];
    }
}

-(void) willStartSimulating{
    if(_songs.count > 0){
        _playButton.enabled = YES;
        _nextButton.enabled = YES;
        _previousButton.enabled = YES;
        [self updateLabel];
    }
}

-(void) stopSimulating{
    [self stop];
    [super stopSimulating];
}

-(void) prepareToDie{
    
#if !(TARGET_IPHONE_SIMULATOR)
    [_musicPlayer stop];
    _musicPlayer = nil;
#endif
    [super prepareToDie];
}
-(void) dealloc{
    [self stop];
}

@end
