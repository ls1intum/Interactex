//
//  THValuePaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/16/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THValuePaletteItem.h"
#import "THValueEditable.h"

@implementation THValuePaletteItem

- (void)dropAt:(CGPoint)location {
    THValueEditable * value = [[THValueEditable alloc] init];
    value.position = location;
    
    THCustomProject * project = (THCustomProject*) [TFDirector sharedDirector].currentProject;
    [project addValue:value];
}

@end
