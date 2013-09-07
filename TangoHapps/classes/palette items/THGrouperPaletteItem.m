//
//  THGrouperPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THGrouperPaletteItem.h"
#import "THGrouperConditionEditable.h"

@implementation THGrouperPaletteItem

- (void)dropAt:(CGPoint)location {
    THGrouperConditionEditable * condition = [[THGrouperConditionEditable alloc] init];
    condition.position = location;
    
    THCustomProject * project = (THCustomProject*) [THDirector sharedDirector].currentProject;
    [project addCondition:condition];
}

@end
