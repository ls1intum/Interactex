//
//  THCompassEditableObject.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/20/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THHardwareComponentEditableObject.h"
#import <CoreLocation/CoreLocation.h>

@interface THCompassEditableObject : THHardwareComponentEditableObject <UIAccelerometerDelegate, CLLocationManagerDelegate> {
    CCSprite * _accelerometerBall;
    CCSprite * _compassCircle;
    CLLocationManager * _locationManager;
    
    CGPoint _velocity;
}

@property (nonatomic) NSInteger accelerometerX;
@property (nonatomic) NSInteger accelerometerY;
@property (nonatomic) NSInteger accelerometerZ;

@property (nonatomic, readonly) float heading;

@property (nonatomic, readonly) THElementPinEditable * pin5Pin;
@property (nonatomic, readonly) THElementPinEditable * pin4Pin;


@end
