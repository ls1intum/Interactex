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

CGSize const kMusicPlayerButtonSize = {42, 21};
CGSize const kMusicPlayerPlayButtonSize = {20, 21};
CGSize const kMusicPlayerVolumeViewSize = {180, 30};
CGSize const kMusicPlayerDurationLabelSize = {50, 20};

float const kMusicPlayerLabelHeight = 30;
float const kMusicPlayerInnerPadding = 10;
float const kMusicPlayerButtonsMargin = 30;
float const kVolumeViewDefaultAlpha = 0.5;

NSString * const kPlayImageName = @"musicPlay.png";
NSString * const kPauseImageName = @"pause.png";

-(id) init{
    self = [super init];
    if(self){
        
        self.width = KDefaultMusicPlayerSize.width;
        self.height = KDefaultMusicPlayerSize.height;
        
        _showPlayButton = YES;
        _showNextButton = YES;
        _showPreviousButton = YES;
        _showVolumeView = YES;
        
        [self loadMusicPlayer];
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

-(void) checkAddRemoveVolumeView{
    if(self.showVolumeView){
        [self.view addSubview:_volumeView];
    } else {
        [_volumeView removeFromSuperview];
    }
}

-(void) loadView{
    
    UIView * containerView = [[UIView alloc] init];
    containerView.bounds = CGRectMake(0, 0, self.width, self.height);
    containerView.layer.cornerRadius = 5.0f;
    containerView.layer.borderWidth = 1.0f;
    containerView.layer.borderColor = [super defaultBorderColor];
    self.view = containerView;
    
    //slider
    _progressSlider = [[UISlider alloc] init];
    _progressSlider.frame = CGRectMake(2 + kMusicPlayerDurationLabelSize.width + kMusicPlayerInnerPadding, kMusicPlayerInnerPadding, self.width - 2 * kMusicPlayerInnerPadding - 2 - 2 * kMusicPlayerDurationLabelSize.width, _progressSlider.frame.size.height);
    _progressSlider.value = 0.0f;
    _progressSlider.minimumValue = 0.0f;
    _progressSlider.maximumValue = 1.0f;
    UIImage * trackImage = [[UIImage imageNamed:@"musicPlayerTrackImage.png"] stretchableImageWithLeftCapWidth: 9 topCapHeight: 0];
    [_progressSlider setMinimumTrackImage:trackImage forState:UIControlStateNormal];
    [_progressSlider setMaximumTrackImage:trackImage forState:UIControlStateNormal];
    
    UIImage * thumbImage = [UIImage imageNamed:@"musicPlayerThumbImage.png"];
    [_progressSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    [_progressSlider addTarget:self action:@selector(progressSliderChanged) forControlEvents:UIControlEventValueChanged];
    [_progressSlider addTarget:self action:@selector(progressSliderBeganChanging) forControlEvents:UIControlEventTouchDown];
    [_progressSlider addTarget:self action:@selector(progressSliderEndedChanging) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    _progressSlider.continuous = NO;
    [containerView addSubview:_progressSlider];
    
    //elapsed time label
    _elapsedTimeLabel = [[UILabel alloc] init];
    //_elapsedTimeLabel.layer.borderWidth = 1.0f;
    _elapsedTimeLabel.frame = CGRectMake(kMusicPlayerInnerPadding, kMusicPlayerInnerPadding - kMusicPlayerDurationLabelSize.height/2 + _progressSlider.frame.size.height/2, kMusicPlayerDurationLabelSize.width, kMusicPlayerDurationLabelSize.height);
    _elapsedTimeLabel.textAlignment = NSTextAlignmentCenter;
    _elapsedTimeLabel.font = [UIFont boldSystemFontOfSize:10];
    [containerView addSubview:_elapsedTimeLabel];
    
    //duration label
    _totalDurationLabel = [[UILabel alloc] init];
    //_totalDurationLabel.layer.borderWidth = 1.0f;
    _totalDurationLabel.frame = CGRectMake(self.width - kMusicPlayerDurationLabelSize.width - kMusicPlayerInnerPadding, _elapsedTimeLabel.frame.origin.y, kMusicPlayerDurationLabelSize.width, kMusicPlayerDurationLabelSize.height);
    _totalDurationLabel.textAlignment = NSTextAlignmentCenter;
    _totalDurationLabel.font = [UIFont boldSystemFontOfSize:10];
    [containerView addSubview:_totalDurationLabel];
    
    //title label
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(kMusicPlayerInnerPadding, _progressSlider.frame.origin.y + _progressSlider.frame.size.height + kMusicPlayerInnerPadding, self.width - 2 * kMusicPlayerInnerPadding, kMusicPlayerLabelHeight);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    [containerView addSubview:_titleLabel];
    
    //album label
    _albumLabel = [[UILabel alloc] init];
    _albumLabel.frame = CGRectMake(kMusicPlayerInnerPadding, _titleLabel.frame.origin.y + _titleLabel.frame.size.height, self.width - 2 * kMusicPlayerInnerPadding, kMusicPlayerLabelHeight);
    _albumLabel.textAlignment = NSTextAlignmentCenter;
    _albumLabel.font = [UIFont systemFontOfSize:16];
    _albumLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    [containerView addSubview:_albumLabel];
    
    
    CGRect previousButtonFrame = CGRectMake(kMusicPlayerButtonsMargin, _albumLabel.frame.origin.y + _albumLabel.frame.size.height + kMusicPlayerInnerPadding, kMusicPlayerButtonSize.width, kMusicPlayerButtonSize.height);
    _previousButton = [self buttonWithFrame:previousButtonFrame imageName:@"backwards.png"];
    [_previousButton addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchDown];
    
    CGRect playButtonFrame = CGRectMake(self.width/2 - kMusicPlayerPlayButtonSize.width/2, _albumLabel.frame.origin.y + _albumLabel.frame.size.height + kMusicPlayerInnerPadding, kMusicPlayerPlayButtonSize.width, kMusicPlayerPlayButtonSize.height);
    _playButton = [self buttonWithFrame:playButtonFrame imageName:kPlayImageName];
    [_playButton addTarget:self action:@selector(togglePlay) forControlEvents:UIControlEventTouchDown];
    
    CGRect nextButtonFrame = CGRectMake(self.width - kMusicPlayerButtonsMargin - kMusicPlayerButtonSize.width, _albumLabel.frame.origin.y + _albumLabel.frame.size.height + kMusicPlayerInnerPadding, kMusicPlayerButtonSize.width, kMusicPlayerButtonSize.height);
    _nextButton = [self buttonWithFrame:nextButtonFrame imageName:@"forward.png"];
    [_nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchDown];
    
    
    //left volume image
    UIImage * leftVolumeImage = [UIImage imageNamed:@"musicPlayerLeftVolume.png"];
    CGRect leftVolumeImageFrame = CGRectMake(kMusicPlayerInnerPadding, _playButton.frame.origin.y + _playButton.frame.size.height + 2 * kMusicPlayerInnerPadding + 4, leftVolumeImage.size.width, leftVolumeImage.size.height);
    _leftVolumeView = [[UIImageView alloc] initWithFrame:leftVolumeImageFrame];
    _leftVolumeView.image = leftVolumeImage;
    [containerView addSubview:_leftVolumeView];
    
    //volume
    CGRect volumeViewFrame = CGRectMake(leftVolumeImageFrame.origin.x + leftVolumeImageFrame.size.width + kMusicPlayerInnerPadding, _playButton.frame.origin.y + _playButton.frame.size.height + 2 * kMusicPlayerInnerPadding, kMusicPlayerVolumeViewSize.width, kMusicPlayerVolumeViewSize.height);
    _volumeView = [[MPVolumeView alloc] initWithFrame:volumeViewFrame];
    _volumeView.showsRouteButton = NO;
    _volumeView.alpha = kVolumeViewDefaultAlpha;
    _volumeView.userInteractionEnabled = NO;
    
    //right volume image
    UIImage * rightVolumeImage = [UIImage imageNamed:@"musicPlayerRightVolume.png"];
    CGRect rightVolumeViewFrame = CGRectMake(self.width - rightVolumeImage.size.width - kMusicPlayerInnerPadding, volumeViewFrame.origin.y, rightVolumeImage.size.width, rightVolumeImage.size.height);
    _rightVolumeView = [[UIImageView alloc] initWithFrame:rightVolumeViewFrame];
    _rightVolumeView.image = rightVolumeImage;
    [containerView addSubview:_rightVolumeView];
    
    self.height =  volumeViewFrame.size.height + volumeViewFrame.origin.y - _progressSlider.frame.origin.y + 2 * kMusicPlayerInnerPadding;
        
    [self checkAddRemovePreviousButton];
    [self checkAddRemovePlayButton];
    [self checkAddRemoveNextButton];
    [self checkAddRemoveVolumeView];
        
    if(isSimulating){
        [self updateStateToEnabled:YES];
    }
}

-(void) loadMusicPlayerEventAndMethods{
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
    
    TFEvent * event1 = [TFEvent eventNamed:@"started"];
    TFEvent * event2 = [TFEvent eventNamed:@"stopped"];
    self.events = [NSMutableArray arrayWithObjects:event1, event2, nil];
    
    [self registerEvents];
}

-(void) loadSongs{/*
#if (TARGET_IPHONE_SIMULATOR)
    self.songs = [NSMutableArray arrayWithObjects:@"song1",@"song2",@"song3", nil];
#else
    
    self.musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    
    self.songsQuery = [MPMediaQuery songsQuery];
    [self.songsQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithBool:NO] forProperty:MPMediaItemPropertyIsCloudItem]];
    

    [self.musicPlayer setQueueWithQuery:self.songsQuery];
    [self.musicPlayer setRepeatMode:MPMusicRepeatModeAll];
    self.songs = self.songsQuery.items;
    
#endif
                   */
}

-(void) loadMusicPlayer{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [self loadSongs];
    [self loadMusicPlayerEventAndMethods];
}

-(void) registerEvents{
    
#if !(TARGET_IPHONE_SIMULATOR)
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self selector:@selector(handleCurrentSongChanged) name:      MPMusicPlayerControllerNowPlayingItemDidChangeNotification
     object:nil];
    
    [notificationCenter addObserver: self selector:@selector(handleCurrentPlayerStateChanged) name:      MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object:nil];
    
    [self.musicPlayer beginGeneratingPlaybackNotifications];
#endif
}

-(void) deregisterEvents{
    
#if !(TARGET_IPHONE_SIMULATOR)
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
    [notificationCenter removeObserver:self.musicPlayer];
    
    [self.musicPlayer endGeneratingPlaybackNotifications];
    
#endif
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if(self){
        _showPlayButton = [decoder decodeBoolForKey:@"showPlayButton"];
        _showNextButton = [decoder decodeBoolForKey:@"showNextButton"];
        _showPreviousButton = [decoder decodeBoolForKey:@"showPreviousButton"];
        _showVolumeView = [decoder decodeBoolForKey:@"showVolumeView"];
        
        [self loadMusicPlayer];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeBool:_showPlayButton forKey:@"showPlayButton"];
    [coder encodeBool:_showNextButton forKey:@"showNextButton"];
    [coder encodeBool:_showPreviousButton forKey:@"showPreviousButton"];
    [coder encodeBool:_showVolumeView forKey:@"showVolumeView"];
}

#pragma mark - Notification handling

-(void) applicationWillResignActive:(NSNotification*) notification{
    if(self.playing){
        [self stop];
    }
}

#pragma mark - Music player events

-(void) progressSliderChanged{
    
    self.musicPlayer.currentPlaybackTime = _progressSlider.value * [self currentSongDuration];
}

-(void) progressSliderBeganChanging{
    if(self.playing){
        [self stopUpdatingSongProgress];
    }
}

-(void) progressSliderEndedChanging{
    if(self.playing){
        [self startUpdatingSongProgress];
    }
}

-(void) handleCurrentSongChanged{
    [self updateLabels];
    _progressSlider.value = 0.0f;
}

-(void) handleCurrentPlayerStateChanged{
    
}

#pragma mark - UI

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

-(void) setShowVolumeView:(BOOL)showVolumeView{
    if(showVolumeView != self.showVolumeView){
        _showVolumeView = showVolumeView;
        [self checkAddRemoveVolumeView];
    }
}


#pragma mark updating song progress

-(void) stopUpdatingSongProgress{
    [_musicProgressTimer invalidate];
    _musicProgressTimer = nil;
}

-(void) startUpdatingSongProgress{
    _musicProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(audioProgressUpdate) userInfo:nil repeats:YES];
}

-(void) audioProgressUpdate {
    
    if (self.musicPlayer != nil && self.musicPlayer.currentPlaybackTime > 0.0){
        _progressSlider.value = (self.musicPlayer.currentPlaybackTime / [self currentSongDuration]);
        
        [self updateElapsedTimeLabel];
        [self updateTotalDurationLabel];
    }
}

#pragma mark Methods

-(NSTimeInterval) currentSongDuration{
    NSNumber * duration = [self.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
    return [duration doubleValue];
}

-(NSString*) currentSong{
    
#if (TARGET_IPHONE_SIMULATOR)
    return [self.songs objectAtIndex:_currentSongIdx];
#else
    
    NSUInteger index = self.musicPlayer.indexOfNowPlayingItem;
    if(index == NSNotFound){
        index = 0;
    }
    MPMediaItem * song = [self.songs objectAtIndex:index];
    
    if(song){
        return [song valueForProperty: MPMediaItemPropertyTitle];
    } else {
        return nil;
    }
#endif
}

-(NSString*) currentSongArtist{
    MPMediaItem * song = self.musicPlayer.nowPlayingItem;
    if(song){
        return [song valueForProperty: MPMediaItemPropertyArtist];
    } else {
        return nil;
    }
}

-(NSString*) currentSongAlbum{
    MPMediaItem * song = self.musicPlayer.nowPlayingItem;
    if(song){
        return [song valueForProperty: MPMediaItemPropertyAlbumTitle];
    } else {
        return nil;
    }
}

-(BOOL) playing{
    
    return _playing;
}

#pragma mark Methods

-(void) setVolume:(float)volume{
    
    for (UIView *view in [_volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            [(UISlider*)view setValue:volume];
            break;
        }
    }
}

-(float) volume{
    
    for (UIView *view in [_volumeView subviews]){
        
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            self.volume = [(UISlider*)view value];
            break;
        }
    }
    return self.volume;
}

-(void) togglePlay{
    
    if(self.playing){
        [self pause];
    } else {
        [self play];
    }
}

-(void) setPlaying:(BOOL)playing{
    if(_playing != playing){
        _playing = playing;
        
        if(playing){
            [self startUpdatingSongProgress];
            [self updateProgressSliderState];
            [self updateLabels];
            [self updatePlayButtonImage];
            
            [self triggerEventNamed:@"started"];
            
        } else {
            
            [self stopUpdatingSongProgress];
            [self updateProgressSliderState];
            
            [self updateLabels];
            [self updatePlayButtonImage];
            
            [self triggerEventNamed:@"stopped"];
        }
    }
}

-(void) play{
    
#if (TARGET_IPHONE_SIMULATOR)
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/song1.mp3", [[NSBundle mainBundle] resourcePath]]];
    
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.audioPlayer.numberOfLoops = -1;
    [self.audioPlayer play];//this line crashes in simulator
    
    [self updatePlayButtonImage];
#else

    [self.musicPlayer play];
    
#endif
    
    
    self.playing = YES;
    
}

-(void) pause{
#if (TARGET_IPHONE_SIMULATOR)
    //[[CDAudioManager sharedManager] stopBackgroundMusic];
    [self updatePlayButtonImage];
#else
    [self.musicPlayer pause];
    
#endif
    
    self.playing = NO;
}

-(void) stop{
    
#if (TARGET_IPHONE_SIMULATOR)
    [self pause];
    [self updatePlayButtonImage];
#else
    [self.musicPlayer stop];
#endif
    
    self.playing = NO;
}

-(void) next{
#if (TARGET_IPHONE_SIMULATOR)
    //in simulator, iterate to next song and play it
    _currentSongIdx ++;
    if(_currentSongIdx >= self.songs.count){
        _currentSongIdx = 0;
    }
    [self play];
#else
    [self.musicPlayer skipToNextItem];
#endif
}

-(void) previous{
#if (TARGET_IPHONE_SIMULATOR)
    _currentSongIdx --;
    if(_currentSongIdx < 0){
        _currentSongIdx = self.songs.count - 1;
    }
    [self play];
#else
    [self.musicPlayer skipToPreviousItem];
#endif
    
}

#pragma mark - UI updating

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    if(hours == 0){
        return [NSString stringWithFormat:@"%2ld:%02ld", (long)minutes, (long)seconds];
    } else {
        return [NSString stringWithFormat:@"%2ld:%2ld:%02ld", (long)hours, (long)minutes, (long)seconds];
    }
}

-(void) updateElapsedTimeLabel{
    NSInteger elapsedTime = (NSInteger) self.musicPlayer.currentPlaybackTime;
    
    _elapsedTimeLabel.text = [self stringFromTimeInterval:elapsedTime];
}

-(void) updateTotalDurationLabel{
    
    NSInteger elapsedTime = (NSInteger) self.musicPlayer.currentPlaybackTime;
    NSInteger countDown = (NSInteger) [self currentSongDuration] - elapsedTime;
    
    NSString * timeString = [self stringFromTimeInterval:countDown];
    
    _totalDurationLabel.text = [@"-" stringByAppendingString:timeString];
}

-(void) updateAlbumLabel{
    
    NSString * artist = self.currentSongArtist;
    NSString * album = self.currentSongAlbum;
    NSString * albumLabelText = @"";
    
    if(artist && ![artist isEqualToString:@""]){
        albumLabelText = [albumLabelText stringByAppendingString:artist];
    }
    
    if(album && ![album isEqualToString:@""]){
        if(artist){
            albumLabelText = [albumLabelText stringByAppendingString:@" - "];
        }
        albumLabelText = [albumLabelText stringByAppendingString:album];
    }
    
    _albumLabel.text = albumLabelText;
}

-(void) updateLabels{
    
    NSString * currentSong  = self.currentSong;
    
    if(currentSong){
        
        _titleLabel.text = self.currentSong;
        
        [self updateAlbumLabel];
        [self updateElapsedTimeLabel];
        [self updateTotalDurationLabel];
        
    } else {
        
        _titleLabel.text = @"Not playing";
    }
}

-(void) updatePlayButtonImage{
    
    UIImage * playImage;
    
    if(self.playing){
        playImage = [UIImage imageNamed:kPauseImageName];
    } else {
        playImage = [UIImage imageNamed:kPlayImageName];
    }
    
    [_playButton setBackgroundImage:playImage forState:UIControlStateNormal];
}

-(void) updateProgressSliderState{
    
    if(self.playing){
        _progressSlider.enabled = YES;
    } else {
        _progressSlider.enabled = NO;
    }
}

-(void) updateStateToEnabled:(BOOL) enabled{

    _playButton.enabled = enabled;
    _nextButton.enabled = enabled;
    _previousButton.enabled = enabled;
    _volumeView.userInteractionEnabled = enabled;
    _volumeView.alpha = (enabled ? 1.0f : kVolumeViewDefaultAlpha);
    
    [self updateLabels];
    
    [self updateProgressSliderState];
}

#pragma mark - Lifecycle Methods

-(void) willStartSimulating{
    if(self.songs.count > 0){
        isSimulating = YES;
        [self updateStateToEnabled:YES];
    }
    
    [super willStartSimulating];
}

-(void) stopSimulating{
    [self stop];
    [super stopSimulating];
    
    [self updateStateToEnabled:NO];
    isSimulating = NO;
    
    [super stopSimulating];
}

#pragma mark - Other methods

-(NSString*) description{
    return @"music player";
}

-(void) prepareToDie{
    
    [self deregisterEvents];
    
#if !(TARGET_IPHONE_SIMULATOR)
    [self.musicPlayer stop];
    self.musicPlayer = nil;
#endif
    
    [super prepareToDie];
}

@end
