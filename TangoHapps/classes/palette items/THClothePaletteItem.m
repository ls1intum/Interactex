//
//  THClothePaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/7/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THClothePaletteItem.h"
#import "THClothe.h"

@implementation THClothePaletteItem

- (void)dropAt:(CGPoint)location {

    THClothe * clothe = [[THClothe alloc] initWithName:self.name];
    clothe.position = location;
    
    THCustomProject * project = (THCustomProject*) [TFDirector sharedDirector].currentProject;
    [project addClothe:clothe];
}

@end
