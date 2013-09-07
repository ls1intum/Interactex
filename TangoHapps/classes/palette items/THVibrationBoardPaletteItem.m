//
//  THVibrationBoardPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 4/12/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THVibrationBoardPaletteItem.h"
#import "THVibrationBoardEditable.h"

@implementation THVibrationBoardPaletteItem

- (void)dropAt:(CGPoint)location {
    THVibrationBoardEditable * myObject = [[THVibrationBoardEditable alloc] init];
    myObject.position = location;
    
    THCustomProject * project = (THCustomProject*) [THDirector sharedDirector].currentProject;
    [project addClotheObject:myObject];
}


@end
