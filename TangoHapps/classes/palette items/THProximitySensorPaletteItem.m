//
//  THProximitySensorPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 20/06/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THProximitySensorPaletteItem.h"
#import "THProximitySensorEditableObject.h"

@implementation THProximitySensorPaletteItem

- (void)dropAt:(CGPoint)location {
    THProximitySensorEditableObject * proximitySensor = [[THProximitySensorEditableObject alloc] init];
    [self addHardwareComponentToProject:proximitySensor atLocation:location];
}

@end
