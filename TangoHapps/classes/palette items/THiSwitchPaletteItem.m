//
//  THiSwitchPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/4/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THiSwitchPaletteItem.h"
#import "THiSwitchEditableObject.h"
#import "THiPhoneEditableObject.h"

@implementation THiSwitchPaletteItem

- (BOOL)canBeDroppedAt:(CGPoint)location {
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    if([project.iPhone testPoint:location]){
        return YES;
    }
    return NO;
}

- (void)dropAt:(CGPoint)location {
    THiSwitchEditableObject * iswitch = [[THiSwitchEditableObject alloc] init];
    
    CGPoint locationTransformed = [TFHelper ConvertToCocos2dView:location];
    iswitch.position = locationTransformed;
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addiPhoneObject:iswitch];
}

@end
