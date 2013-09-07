//
//  THTouchpadPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/22/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THTouchpadPaletteItem.h"
#import "THTouchPadEditableObject.h"
#import "THiPhoneEditableObject.h"

@implementation THTouchpadPaletteItem

- (BOOL)canBeDroppedAt:(CGPoint)location
{
    THCustomProject * project = (THCustomProject*) [THDirector sharedDirector].currentProject;
    if([project.iPhone testPoint:location]){
        return YES;
    }
    return NO;
}

- (void)dropAt:(CGPoint)location {
    THTouchPadEditableObject * iPhoneButton = [[THTouchPadEditableObject alloc] init];
    
    CGPoint locationTransformed = [TFHelper ConvertToCocos2dView:location];
    iPhoneButton.position = locationTransformed;
    
    THCustomProject * project = (THCustomProject*) [THDirector sharedDirector].currentProject;
    [project addiPhoneObject:iPhoneButton];
}

@end
