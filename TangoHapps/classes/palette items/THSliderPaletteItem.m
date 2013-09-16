//
//  THSliderPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 1/7/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THSliderPaletteItem.h"
#import "THProject.h"
#import "THiPhoneEditableObject.h"
#import "THSliderEditableObject.h"

@implementation THSliderPaletteItem

- (BOOL)canBeDroppedAt:(CGPoint)location {
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    if([project.iPhone testPoint:location]){
        return YES;
    }
    return NO;
}

- (void)dropAt:(CGPoint)location {
    THSliderEditableObject * slider = [[THSliderEditableObject alloc] init];
    slider.position = location;
    
    CGPoint locationTransformed = [TFHelper ConvertToCocos2dView:location];
    slider.position = locationTransformed;
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addiPhoneObject:slider];
}

@end
