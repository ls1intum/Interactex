//
//  THButtonPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/14/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THButtonPaletteItem.h"
#import "THButtonEditableObject.h"

@implementation THButtonPaletteItem

- (void)dropAt:(CGPoint)location
{
    THButtonEditableObject * clotheButton = [[THButtonEditableObject alloc] init];
    clotheButton.position = location;
    
    THCustomProject * project = (THCustomProject*) [TFDirector sharedDirector].currentProject;
    [project addClotheObject:clotheButton];
}

@end
