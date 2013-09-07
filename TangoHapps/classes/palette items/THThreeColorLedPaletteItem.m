//
//  THThreeColorLedPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 1/7/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THThreeColorLedPaletteItem.h"
#import "THThreeColorLedEditable.h"

@implementation THThreeColorLedPaletteItem

- (void)dropAt:(CGPoint)location {
    THThreeColorLedEditable * led = [[THThreeColorLedEditable alloc] init];
    led.position = location;
    
    THCustomProject * project = (THCustomProject*) [THDirector sharedDirector].currentProject;
    [project addClotheObject:led];
}

@end
