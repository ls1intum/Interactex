//
//  THMapperPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 12/11/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THMapperPaletteItem.h"
#import "THMapperEditable.h"

@implementation THMapperPaletteItem

- (void)dropAt:(CGPoint)location {
    THMapperEditable * mapper = [[THMapperEditable alloc] init];
    mapper.position = location;
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addValue:mapper];
}

@end
