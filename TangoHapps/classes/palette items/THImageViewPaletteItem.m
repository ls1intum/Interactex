//
//  THImageViewPaletteItem.m
//  TangoHapps3
//
//  Created by Juan Haladjian on 12/17/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

#import "THImageViewPaletteItem.h"
#import "THImageViewEditable.h"
#import "THiPhoneEditableObject.h"

@implementation THImageViewPaletteItem

- (BOOL)canBeDroppedAt:(CGPoint)location
{
    THCustomProject * project = (THCustomProject*) [TFDirector sharedDirector].currentProject;
    if([project.iPhone testPoint:location]){
        return YES;
    }
    return NO;
}

- (void)dropAt:(CGPoint)location {
    THImageViewEditable * imageView = [[THImageViewEditable alloc] init];
    imageView.position = location;
    
    CGPoint locationTransformed = [TFHelper ConvertToCocos2dView:location];
    imageView.position = locationTransformed;
    
    THCustomProject * project = (THCustomProject*) [TFDirector sharedDirector].currentProject;
    [project addiPhoneObject:imageView];
}

@end
