//
//  THSoundPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 4/23/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THSoundPaletteItem.h"
#import "THProject.h"
#import "THSoundEditable.h"

@implementation THSoundPaletteItem

- (void)dropAt:(CGPoint)location {
    THSoundEditable * sound = [[THSoundEditable alloc] init];
    sound.position = location;
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addAction:sound];
}

@end
