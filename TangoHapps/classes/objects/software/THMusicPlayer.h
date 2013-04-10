//
//  THMusicPlayer.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/22/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface THMusicPlayer : THView {
    NSArray * _songs;
    NSInteger _currentSongIdx;
    
    UILabel * _label;
    MPMusicPlayerController * _musicPlayer;
    
    UIButton * _playButton;
    UIButton * _nextButton;
    UIButton * _previousButton;
}

-(void) play;
-(void) pause;
-(void) stop;
-(void) next;
-(void) previous;

@property (nonatomic,readonly) NSString * currentSong;
@property (nonatomic) float volume;


@property (nonatomic, readonly) BOOL playing;
@property (nonatomic) BOOL showPlayButton;
@property (nonatomic) BOOL showNextButton;
@property (nonatomic) BOOL showPreviousButton;

@end
