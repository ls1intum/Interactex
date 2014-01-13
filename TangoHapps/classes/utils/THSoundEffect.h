//
//  THSoundEffect.h
//  TangoHapps
//
//  Created by Juan Haladjian on 13/01/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import <AudioToolbox/AudioServices.h>

@interface THSoundEffect : NSObject
{
    SystemSoundID soundID;
}

-(id) initWithSoundNamed:(NSString *)filename;
-(void) play;

@end
