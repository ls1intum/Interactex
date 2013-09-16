//
//  THLabelPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/14/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THLabelPaletteItem.h"
#import "THLabelEditableObject.h"
#import "THiPhoneEditableObject.h"

@implementation THLabelPaletteItem

- (BOOL)canBeDroppedAt:(CGPoint)location {
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    
    if([project.iPhone testPoint:location]){
        return YES;
    }
    return NO;
}

- (void)dropAt:(CGPoint)location {
    THLabelEditableObject * ilabel = [[THLabelEditableObject alloc] init];
    
    CGPoint locationTransformed = [TFHelper ConvertToCocos2dView:location];
    ilabel.position = locationTransformed;
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addiPhoneObject:ilabel];
}

@end
