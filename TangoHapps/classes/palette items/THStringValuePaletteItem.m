//
//  THStringValuePaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/5/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THStringValuePaletteItem.h"
#import "THStringValueEditable.h"

@implementation THStringValuePaletteItem

- (void)dropAt:(CGPoint)location {
    THStringValueEditable * value = [[THStringValueEditable alloc] init];
    value.position = location;
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addValue:value];
}

@end
