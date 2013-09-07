//
//  THValuePaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/16/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THValuePaletteItem.h"
#import "THNumberValueEditable.h"

@implementation THValuePaletteItem

- (void)dropAt:(CGPoint)location {
    THNumberValueEditable * value = [[THNumberValueEditable alloc] init];
    value.position = location;
    
    THCustomProject * project = (THCustomProject*) [THDirector sharedDirector].currentProject;
    [project addValue:value];
}

@end
