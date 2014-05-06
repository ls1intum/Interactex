//
//  THFlexSensorPaletteItem.m
//  TangoHapps
//
//  Created by Timm Beckmann on 02/04/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THFlexSensorPaletteItem.h"
#import "THFlexSensorEditable.h"

@implementation THFlexSensorPaletteItem


- (void)dropAt:(CGPoint)location {
    THFlexSensorEditable * flexSensor = [[THFlexSensorEditable alloc] init];
    flexSensor.position = location;
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addGestureComponent:flexSensor];
}

@end