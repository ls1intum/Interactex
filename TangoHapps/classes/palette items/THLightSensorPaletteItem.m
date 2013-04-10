//
//  THLightSensorPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/12/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THLightSensorPaletteItem.h"
#import "THLightSensorEditableObject.h"

@implementation THLightSensorPaletteItem

- (void)dropAt:(CGPoint)location {
    THLightSensorEditableObject * lightSensor = [[THLightSensorEditableObject alloc] init];
    lightSensor.position = location;
    
    THCustomProject * project = (THCustomProject*) [TFDirector sharedDirector].currentProject;
    [project addClotheObject:lightSensor];
}

@end
