//
//  THSound.h
//  TangoHapps
//
//  Created by Juan Haladjian on 4/23/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface THSound : TFAction
{
}

@property (nonatomic,readonly) NSString * currentSong;
@property (nonatomic, copy) NSString * fileName;

-(void) play;

@end
