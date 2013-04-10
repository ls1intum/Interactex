//
//  THMusicPlayerPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/23/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THMusicPlayerPaletteItem.h"
#import "THMusicPlayerEditableObject.h"
#import "THiPhoneEditableObject.h"

@implementation THMusicPlayerPaletteItem

- (BOOL)canBeDroppedAt:(CGPoint)location
{
    THCustomProject * project = (THCustomProject*) [TFDirector sharedDirector].currentProject;
    if([project.iPhone testPoint:location]){
        return YES;
    }
    return NO;
}

- (void)dropAt:(CGPoint)location {
    THMusicPlayerEditableObject * musicPlayer = [[THMusicPlayerEditableObject alloc] init];
    
    CGPoint locationTransformed = [TFHelper ConvertToCocos2dView:location];
    musicPlayer.position = locationTransformed;
    
    THCustomProject * project = (THCustomProject*) [TFDirector sharedDirector].currentProject;
    [project addiPhoneObject:musicPlayer];
}

@end
