//
//  THiBeacon.m
//  TangoHapps
//
//  Created by Guven Candogan on 12/08/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THiBeacon.h"
#import <CoreLocation/CLLocationManager.h>


@implementation THiBeacon

- (instancetype)initWithName:(NSString *)name
                        uuid:(NSUUID *)uuid
                       major:(CLBeaconMajorValue)major
                       minor:(CLBeaconMinorValue)mvinor{
    return self;
}

-(id) init{
    self = [super init];
    if(self){
        
        [self loadLocationManager];
        [self initRegion];
        [self initLabels];
        [self.locationManager startUpdatingLocation];
        [self loadMethods];
    }
    return self;
}

-(void) loadLocationManager{
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 1000;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //[_locationManager startMonitoringForRegion:self.region];
    //[_locationManager startRangingBeaconsInRegion:self.region];
    
    //TFEvent * event1 = [TFEvent eventNamed:kProximityChanged];
   // event1.param1 = [TFPropertyInvocation invocationWithProperty:property1 target:self];
    
  //  self.events = [NSMutableArray arrayWithObjects:event1,,nil];
    
}

-(void) loadMethods{
    TFMethod * method = [TFMethod methodWithName:@"sendNotification"];
    self.methods = [NSMutableArray arrayWithObject:method];

}

-(void) sendNotification{
    
    //[[UIApplication sharedApplication] openURL:url];
    
}

-(void) initLabels{
    
    self.uuid =[[NSUUID alloc] initWithUUIDString:@"F7826DA6-4FA2-4E98-8024-BC5B71E0893E"];
    
}

- (void)initRegion {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"F7826DA6-4FA2-4E98-8024-BC5B71E0893E"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.tum.region"];
    //self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid  major:62.070
     //                                       minor:2.882 identifier:@"com.tum.region"];
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"Start Monitorig");
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLBeaconRegion *)region{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    switch (state) {
        case CLRegionStateInside: {
            [self.locationManager startRangingBeaconsInRegion:region];
            
            notification.alertBody = [NSString stringWithFormat:@"You are inside region %@", region.identifier];
            break;
        }
            
        case CLRegionStateOutside:
            notification.alertBody = [NSString stringWithFormat:@"You are outside region %@", region.identifier];
        case CLRegionStateUnknown:
        default:
            NSLog(@"Region unknown");
    }
    
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Beacon Found");
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Left Region");
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    
    if (self.beaconRegion) {
        if([beacons count] > 0)
        {
            //get closes beacon and find its major
           // CLBeacon *beacon = [beacons objectAtIndex:0];
        }
    }
    
    /*
    self.proximityUUIDLabel.text = beacon.proximityUUID.UUIDString;
    self.majorLabel.text = [NSString stringWithFormat:@"%@", beacon.major];
    self.minorLabel.text = [NSString stringWithFormat:@"%@", beacon.minor];
    self.accuracyLabel.text = [NSString stringWithFormat:@"%f", beacon.accuracy];
    if (beacon.proximity == CLProximityUnknown) {
        self.distanceLabel.text = @"Unknown Proximity";
    } else if (beacon.proximity == CLProximityImmediate) {
        self.distanceLabel.text = @"Immediate";
    } else if (beacon.proximity == CLProximityNear) {
        self.distanceLabel.text = @"Near";
    } else if (beacon.proximity == CLProximityFar) {
        self.distanceLabel.text = @"Far";
    }
    self.rssiLabel.text = [NSString stringWithFormat:@"%i", beacon.rssi];
    */
}

-(CLLocationManager *) locationManager{
    if(!_locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    return _locationManager;
}

    //where to put the viewDidLoad
  /*  - (void)viewDidLoad
    {
        [super viewDidLoad];
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }*/

-(NSString*) description{
    return @"iBeacon";
}

@end
