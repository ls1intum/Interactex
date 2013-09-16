//
//  THiPhoneButtonPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/9/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THiPhoneButtonPaletteItem.h"
#import "THiPhoneEditableObject.h"
#import "THiPhoneButtonEditableObject.h"

@implementation THiPhoneButtonPaletteItem

- (BOOL)canBeDroppedAt:(CGPoint)location
{
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    if([project.iPhone testPoint:location]){
        return YES;
    }
    return NO;
}

- (void)dropAt:(CGPoint)location {
    THiPhoneButtonEditableObject * iPhoneButton = [[THiPhoneButtonEditableObject alloc] init];

    CGPoint locationTransformed = [TFHelper ConvertToCocos2dView:location];
    iPhoneButton.position = locationTransformed;
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addiPhoneObject:iPhoneButton];
}

@end
