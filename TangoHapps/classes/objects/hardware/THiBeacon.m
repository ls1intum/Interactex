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

static NSString * const kUUID = @"F7826DA6-4FA2-4E98-8024-BC5B71E0893E";
static NSString * const kIdentifier = @"com.tum.region";

BOOL exitNotified = NO;
BOOL enterNotified = NO;

@synthesize status = _status;


#pragma mark - Creation and Initialization

-(void) initLabels{
    
    self.uuid =[[NSUUID alloc] initWithUUIDString:kUUID];
    self.status = @"Not Started";
    
}
- (instancetype)initWithName:(NSString *)name
                        uuid:(NSUUID *)uuid
                       major:(CLBeaconMajorValue)major
                       minor:(CLBeaconMinorValue)mvinor{
    return self;
}

-(id) init{
    self = [super init];
    if(self){
        
        //[self loadLocationManager];
        [self createBeaconRegion];
        [self initLabels];
        [self.locationManager startUpdatingLocation];
        [self loadMethods];
    }
    return self;
}

- (void)createBeaconRegion
{
    if (self.beaconRegion)
        return;
    
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:kUUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:kIdentifier];
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
}

-(void) loadMethods{
    
    TFProperty * property1 = [TFProperty propertyWithName:@"status" andType:kDataTypeString];
    self.properties = [NSMutableArray arrayWithObjects:property1,nil];
    
    TFMethod * method1 = [TFMethod methodWithName:@"turnOn"];
    TFMethod * method2 = [TFMethod methodWithName:@"turnOff"];
    self.methods = [NSMutableArray arrayWithObjects:method1,method2,nil];
    
    TFEvent * event1 = [TFEvent eventNamed:KNotificationiBeaconRegionEntered];
    TFEvent * event2 = [TFEvent eventNamed:KNotificationiBeaconRegionExited];
    TFEvent * event3 = [TFEvent eventNamed:KNotificationiBeaconRangingStatus];
    event3.param1 =[TFPropertyInvocation invocationWithProperty:property1 target:self];
    
    self.events = [NSMutableArray arrayWithObjects:event1,event2,event3,nil];
    
    //TFEvent * event1 = [TFEvent eventNamed:@"switchOn"];
    //TFEvent * event2 = [TFEvent eventNamed:@"switchOff"];
    //TFEvent * event3 = [TFEvent eventNamed:kEventOnChanged];
    //event3.param1 = [TFPropertyInvocation invocationWithProperty:property target:self];
    //self.events = [NSMutableArray arrayWithObjects:event1,event2,event3, nil];
    
}


#pragma mark - Methods

- (void)turnOn
{
    NSLog(@"Method TurnOn");
    [self startRangingForBeacons];
    [self startMonitoringForBeacons];
}

-(void) turnOff{
    NSLog(@"Method TurnOff");
    [self stopRangingForBeacons];
    [self stopMonitoringForBeacons];
}

#pragma mark - Functionality

-(void) didStartSimulating{
    [self triggerEventNamed:KNotificationiBeaconRegionEntered];
    [self triggerEventNamed:KNotificationiBeaconRegionExited];
    [self triggerEventNamed:KNotificationiBeaconRangingStatus];
    [super didStartSimulating];
}

- (NSString *)detailsStringForBeacon:(CLBeacon *)beacon
{
    NSString *proximity;
    switch (beacon.proximity) {
        case CLProximityNear:
            proximity = @"Near";
            break;
        case CLProximityImmediate:
            proximity = @"Immediate";
            break;
        case CLProximityFar:
            proximity = @"Far";
            break;
        case CLProximityUnknown:
        default:
            proximity = @"Unknown";
            break;
    }
    
    NSString *format = @"%@, %@ • %@ • %f • %li";
    return [NSString stringWithFormat:format, beacon.major, beacon.minor, proximity, beacon.accuracy, beacon.rssi];
}

#pragma mark - Beacon ranging

- (void)startRangingForBeacons
{
    NSLog(@"Turning on ranging...");
    
    if (![CLLocationManager isRangingAvailable]) {
        NSLog(@"Couldn't turn on ranging: Ranging is not available.");
        return;
    }
    
    if (self.locationManager.rangedRegions.count > 0) {
        NSLog(@"Didn't turn on ranging: Ranging already on.");
        return;
    }
    
    [self createBeaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    
    NSLog(@"Ranging turned on for region: %@.", self.beaconRegion);
}

- (void)stopRangingForBeacons
{
    if (self.locationManager.rangedRegions.count == 0) {
        NSLog(@"Didn't turn off ranging: Ranging already off.");
        return;
    }
    
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}

#pragma mark - Beacon region monitoring

- (void)startMonitoringForBeacons
{
    NSLog(@"Turning on monitoring...");
    
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        NSLog(@"Couldn't turn on region monitoring: Region monitoring is not available for CLBeaconRegion class.");
        exitNotified = NO;
        return;
    }
    
    [self createBeaconRegion];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
    NSLog(@"Monitoring turned on for region: %@.", self.beaconRegion);
}

- (void)stopMonitoringForBeacons
{
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
    
    NSLog(@"Turned off monitoring");
}


#pragma mark - Location Manager and delegate methods

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
 //   UILocalNotification *notification = [[UILocalNotification alloc] init];
  //  notification.soundName = UILocalNotificationDefaultSoundName;
    
    if (![CLLocationManager locationServicesEnabled]) {
            NSLog(@"Location services are not enabled.");
   //         notification.alertBody = [NSString stringWithFormat:@"Location services are not enabled."];
    //        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
            return;
    }
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
            NSLog(@"Location services not authorised.");
     //       notification.alertBody = [NSString stringWithFormat:@"Location services not authorised."];
      //      [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
            return;
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSString *stateString = nil;
    switch (state) {
        case CLRegionStateInside:
            stateString = @"inside";
            break;
        case CLRegionStateOutside:
            stateString = @"outside";
            break;
        case CLRegionStateUnknown:
            stateString = @"unknown";
            break;
    }
    NSLog(@"State changed to %@ for region %@.", stateString, region);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    //NSLog(@"Beacon Found");
    //[self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    NSLog(@"You are inside region %@", region.identifier);
    [self triggerEventNamed:KNotificationiBeaconRegionEntered];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    //NSLog(@"Left Region");
    //[self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    NSLog(@"You are outside of  region %@", region.identifier);
    [self triggerEventNamed:KNotificationiBeaconRegionExited];
    
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    NSLog(@"didRangeBeacons:%lu",(unsigned long)[beacons count]);
    
    if (self.beaconRegion) {
        if([beacons count] > 0)
        {
            //get closes beacon and find its major
            CLBeacon *beacon = [beacons objectAtIndex:0];
            self.status = [self detailsStringForBeacon:beacon];
            //self.status = [NSString stringWithFormat:@"%@",beacon.proximityUUID];
        }
    }
}

#pragma mark - Setters and Getters

-(CLLocationManager *) locationManager{
    if(!_locationManager){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    
    return _locationManager;
}


-(NSString*) description{
    return @"iBeacon";
}

-(void) setStatus:(NSString *)status{
    _status = status;
    NSLog(@"Status set%@",status);
    //TODO change of string
    [self triggerEventNamed:KNotificationiBeaconRangingStatus];
}


#pragma mark - Not Used
//where to put the viewDidLoad
/*  - (void)viewDidLoad
 {
 [super viewDidLoad];
 _locationManager = [[CLLocationManager alloc] init];
 _locationManager.delegate = self;
 }*/

/*
 - (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLBeaconRegion *)region{
 //    UILocalNotification *notification = [[UILocalNotification alloc] init];
 
 switch (state) {
 case CLRegionStateInside: {
 [self.locationManager startRangingBeaconsInRegion:region];
 
 //          notification.alertBody = [NSString stringWithFormat:@"You are inside region %@", region.identifier];
 NSLog(@"You are inside region %@", region.identifier);
 [self triggerEventNamed:KNotificationiBeaconRegionEntered];
 break;
 }
 
 case CLRegionStateOutside:
 //        notification.alertBody = [NSString stringWithFormat:@"You are outside region %@", region.identifier];
 NSLog(@"You are inside region %@", region.identifier);
 [self triggerEventNamed:KNotificationiBeaconRegionExited];
 break;
 case CLRegionStateUnknown:
 default:
 NSLog(@"Region unknown");
 }
 
 //    notification.soundName = UILocalNotificationDefaultSoundName;
 //   [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
 }
 */

/*
 - (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
 NSLog(@"Start Monitorig");
 [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
 }*/




/*
-(void) loadLocationManager{
    
    //self.locationManager.distanceFilter = 1000;
    // self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //[_locationManager startMonitoringForRegion:self.region];
    //[_locationManager startRangingBeaconsInRegion:self.region];
    
    //TFEvent * event1 = [TFEvent eventNamed:kProximityChanged];
    // event1.param1 = [TFPropertyInvocation invocationWithProperty:property1 target:self];
    
    //  self.events = [NSMutableArray arrayWithObjects:event1,,nil];
    
}
 */

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
@end
