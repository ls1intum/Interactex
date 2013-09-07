//
//  THSwitchPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/11/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THSwitchPaletteItem.h"
#import "THSlideSwitchEditableObject.h"

@implementation THSwitchPaletteItem

- (void)dropAt:(CGPoint)location
{
    THSlideSwitchEditableObject * clotheSwitch = [[THSlideSwitchEditableObject alloc] init];
    clotheSwitch.position = location;
    
    THCustomProject * project = (THCustomProject*) [THDirector sharedDirector].currentProject;
    [project addClotheObject:clotheSwitch];
}

@end
