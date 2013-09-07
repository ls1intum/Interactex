//
//  THCompassPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/20/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THCompassPaletteItem.h"
#import "THCompassEditableObject.h"

@implementation THCompassPaletteItem

- (void)dropAt:(CGPoint)location {
    THCompassEditableObject * compass = [[THCompassEditableObject alloc] init];
    compass.position = location;
    
    THCustomProject * project = (THCustomProject*) [THDirector sharedDirector].currentProject;
    [project addClotheObject:compass];
}

@end
