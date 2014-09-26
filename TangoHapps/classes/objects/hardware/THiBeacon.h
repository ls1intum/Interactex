//
//  THiBeacon.h
//  TangoHapps
//
//  Created by Guven Candogan on 12/08/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THHardwareComponent.h"
#import <CoreLocation/CoreLocation.h>

@interface THiBeacon : THHardwareComponent
<CLLocationManagerDelegate> {
    CLLocationManager * _locationManager;
}

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSUUID *uuid;
@property (assign, nonatomic) CLBeaconMajorValue *majorValue;
@property (assign, nonatomic) CLBeaconMinorValue *minorValue;
@property (nonatomic) NSString * status;

//@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;


-(void) turnOn;
-(void) turnOff;

@end