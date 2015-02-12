//
//  THRecorderPaletteItem.m
//  TangoHapps
//
//  Created by Guven Candogan on 27/01/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THRecorderPaletteItem.h"
#import "THRecorderEditableObject.h"
#import "THiPhoneEditableObject.h"

@implementation THRecorderPaletteItem

- (BOOL)canBeDroppedAt:(CGPoint)location
{
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    //if([project.iPhone testPoint:location]){ //nazmus commented
    if([project.iPhone.currentView testPoint:location]){ //nazmus added
        return YES;
    }
    return NO;
}

- (void)dropAt:(CGPoint)location {
    THRecorderEditableObject * recorder = [[THRecorderEditableObject alloc] init];
    
    CGPoint locationTransformed = [TFHelper ConvertToCocos2dView:location];
    recorder.position = locationTransformed;
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addiPhoneObject:recorder];
}

@end
