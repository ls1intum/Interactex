//
//  THSoundEffect.m
//  TangoHapps
//
//  Created by Juan Haladjian on 13/01/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THSoundEffect.h"

@implementation THSoundEffect

- (id)initWithSoundNamed:(NSString *)filename {
    self = [super init];
    
    if (self) {
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];

        if (fileURL != nil) {
            SystemSoundID theSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
            if (error == kAudioServicesNoError)
                soundID = theSoundID;
        }
    }
    return self;
}

- (void)dealloc {
    //AudioServicesDisposeSystemSoundID(soundID);
}

- (void)play {
    AudioServicesPlaySystemSound(soundID);
}

@end