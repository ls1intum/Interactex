//
//  THPressureSensorPaletteItem.m
//  TangoHapps
//
//  Created by Guven Candogan on 20/01/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THPressureSensorPaletteItem.h"
#import "THPressureSensorEditableObject.h"

@implementation THPressureSensorPaletteItem

- (void)dropAt:(CGPoint)location {
    THPressureSensorEditableObject * pressureSensor = [[THPressureSensorEditableObject alloc] init];
    [self addHardwareComponentToProject:pressureSensor atLocation:location];
}

@end
