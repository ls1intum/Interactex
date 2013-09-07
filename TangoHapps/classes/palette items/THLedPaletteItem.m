//
//  LedPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "THLedPaletteItem.h"
#import "THLedEditableObject.h"

@implementation THLedPaletteItem

- (void)dropAt:(CGPoint)location {
    THLedEditableObject * myObject = [[THLedEditableObject alloc] init];
    myObject.position = location;
    
    THCustomProject * project = (THCustomProject*) [THDirector sharedDirector].currentProject;
    [project addClotheObject:myObject];
}

@end
