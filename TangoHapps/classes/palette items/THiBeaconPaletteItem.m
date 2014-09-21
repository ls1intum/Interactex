//
//  THiBeaconPaletteItem.m
//  TangoHapps
//
//  Created by Guven Candogan on 12/08/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THiBeaconPaletteItem.h"
#import "THiBeaconEditable.h"

@implementation THiBeaconPaletteItem


- (void)dropAt:(CGPoint)location {
    
    THiBeaconEditable* iBeacon = [[THiBeaconEditable alloc] init];
    iBeacon.position = location;
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addOtherHardwareComponent:iBeacon];
}

@end
