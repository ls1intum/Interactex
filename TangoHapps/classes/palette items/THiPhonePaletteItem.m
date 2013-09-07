//
//  THiPhonePaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/9/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THiPhonePaletteItem.h"
#import "THiPhoneEditableObject.h"

@implementation THiPhonePaletteItem

- (void)dropAt:(CGPoint)location {
    THCustomProject * project = (THCustomProject*) [THDirector sharedDirector].currentProject;
    if(project.iPhone == nil){
        THiPhoneEditableObject * iPhone = [THiPhoneEditableObject iPhoneWithDefaultView];
        iPhone.position = location;
        [project addiPhone:iPhone];
    }
}

@end
