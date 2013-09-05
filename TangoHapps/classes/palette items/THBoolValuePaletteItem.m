//
//  THBoolValuePaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/5/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THBoolValuePaletteItem.h"
#import "THBoolValueEditable.h"

@implementation THBoolValuePaletteItem

- (void)dropAt:(CGPoint)location {
    THBoolValueEditable * value = [[THBoolValueEditable alloc] init];
    value.position = location;
    
    THCustomProject * project = (THCustomProject*) [TFDirector sharedDirector].currentProject;
    [project addValue:value];
}


@end
