/*
 THCompassMPU6050Editable.m
 Interactex Designer
 
 Created by Juan Haladjian on 15/01/2014.
 
 Interactex Designer is a configuration tool to easily setup, simulate and connect e-Textile hardware with smartphone functionality. Interactex Client is an app to store and replay projects made with Interactex Designer.
 
 www.interactex.org
 
 Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
 
 Contacts:
 juan.haladjian@cs.tum.edu
 katharina.bredies@udk-berlin.de
 opensource@telekom.de
 
 
 The first version of the software was designed and implemented as part of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was founded by Telekom Innovation Laboratories Berlin. It has been extended with funding from EIT ICT, as part of the activity "Connected Textiles".
 
 Interactex is built using the Tango framework developed by TU Munich.
 
 In the Interactex software, we use the GHUnit (a test framework for iOS developed by Gabriel Handford) and cocos2D libraries (a framework for building 2D games and graphical applications developed by Zynga Inc.).
 www.cocos2d-iphone.org
 github.com/gabriel/gh-unit
 
 Interactex also implements the Firmata protocol. Its software serial library is based on the original Arduino Firmata library.
 www.firmata.org
 
 All hardware part graphics in Interactex Designer are reproduced with kind permission from Fritzing. Fritzing is an open-source hardware initiative to support designers, artists, researchers and hobbyists to work creatively with interactive electronics.
 www.frizting.org
 
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "THCompassMPU6050Editable.h"
#import "THCompassMPU6050.h"
#import "THElementPinEditable.h"
#import "THCompassProperties.h"
#import "THAppDelegate.h"
#import "THAutorouteProperties.h"

@implementation THCompassMPU6050Editable

-(void) loadCompass{
    self.sprite = [CCSprite spriteWithFile:@"LSMCompass.png"];
    [self addChild:self.sprite];
    
    self.acceptsConnections = YES;
    self.isAccelerometerEnabled = YES;
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 1000;
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    _accelerometerBall = [CCSprite spriteWithFile:@"accelerometerBall.png"];
    _accelerometerBall.visible = NO;
    _accelerometerBall.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
    [self addChild:_accelerometerBall];
    
    _compassCircle = [CCSprite spriteWithFile:@"compassCircle.png"];
    _compassCircle.visible = NO;
    _compassCircle.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
    [self addChild:_compassCircle];
}

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THCompassMPU6050 alloc] init];
        
        self.type = kHardwareTypeMPUCompass;
        
        [self loadCompass];
        [self loadPins];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    [self loadCompass];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THCompassMPU6050Editable * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    
    [controllers addObject:[THCompassProperties properties]];
    [controllers addObject:[THAutorouteProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods
/*
 -(void) handleAccelerated:(UIAcceleration*) acceleration{
 
 //NSLog(@"accel: %f %f",acceleration.y,-acceleration.x);
 
 self.accelerometerX = acceleration.y * 300;
 self.accelerometerY = -acceleration.x * 300;
 //NSLog(@"accel: %d %d",self.x,self.y);
 }*/

-(THElementPinEditable*) pin5Pin{
    return [self.pins objectAtIndex:0];
}

-(THElementPinEditable*) pin4Pin{
    return [self.pins objectAtIndex:1];
}

/*
 -(void) updatePinValue{
 THElementPinEditable * analogPin = self.pin5Pin;
 THBoardPinEditable * boardPin = analogPin.attachedToPin;
 THCompass * compass = (THCompass*) self.object;
 boardPin.currentValue = compass.light;
 }*/

-(void) updateBallPosition{
    float dt = 1.0f/30.0f;
    
    float vx = _velocity.x + self.accelerometerX * dt;
    float vy = _velocity.y + self.accelerometerY * dt;
    _velocity = ccp(vx,vy);
    
    float px = _accelerometerBall.position.x + _velocity.x * dt;
    float py = _accelerometerBall.position.y + _velocity.y * dt;
    CGPoint newPos = ccp(px,py);
    
    float radius = _compassCircle.contentSize.width / 2.0f - 5;
    
    float dist = ccpDistance(_accelerometerBall.position, _compassCircle.position);
    float angle = ccpAngle(_velocity, ccpSub(_compassCircle.position,_accelerometerBall.position));
    angle = CC_RADIANS_TO_DEGREES(angle);
    
    if(dist > radius && angle > 60){
        _velocity = ccpMult(_velocity, -0.8);
        [[SimpleAudioEngine sharedEngine] playEffect:@"compassHit.mp3"];
    }
    _accelerometerBall.position = newPos;
}

-(void) update{
    
    THAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    CMMotionManager * manager = appDelegate.motionManager;
    CMAccelerometerData * accelerometerData = manager.accelerometerData;
    
    self.accelerometerX = accelerometerData.acceleration.y * 300;
    self.accelerometerY = - accelerometerData.acceleration.x * 300;
    self.accelerometerZ = accelerometerData.acceleration.z * 300;
    
    /*
     CMMagnetometerData * magnetometer = manager.magnetometerData;
     NSLog(@"%f",magnetometer.magneticField.x);*/
    
    //_compassCircle.rotation = 90 - self.heading;
    
    [self updateBallPosition];
}

-(void) handleDoubleTapped{
    
}

-(NSInteger) accelerometerX{
    THCompassMPU6050 * compass = (THCompassMPU6050*) self.simulableObject;
    return compass.accelerometerX;
}

-(void) setAccelerometerX:(NSInteger)accelerometerX{
    
    THCompassMPU6050 * compass = (THCompassMPU6050*) self.simulableObject;
    compass.accelerometerX = accelerometerX;
}

-(NSInteger) accelerometerY{
    THCompassMPU6050 * compass = (THCompassMPU6050*) self.simulableObject;
    return compass.accelerometerY;
}

-(void) setAccelerometerY:(NSInteger)accelerometerY{
    
    THCompassMPU6050 * compass = (THCompassMPU6050*) self.simulableObject;
    compass.accelerometerY = accelerometerY;
}

-(NSInteger) accelerometerZ{
    THCompassMPU6050 * compass = (THCompassMPU6050*) self.simulableObject;
    return compass.accelerometerZ;
}

-(void) setAccelerometerZ:(NSInteger)accelerometerZ{
    
    THCompassMPU6050 * compass = (THCompassMPU6050*) self.simulableObject;
    compass.accelerometerZ = accelerometerZ;
}

-(float) heading{
    THCompassMPU6050 * compass = (THCompassMPU6050*) self.simulableObject;
    return compass.heading;
}

/*
 - (void) locationManager:(CLLocationManager *)manager
 didUpdateHeading:(CLHeading *)newHeading{
 
 if (newHeading.headingAccuracy < 0)
 return;
 
 CLLocationDirection  heading = ((newHeading.trueHeading > 0) ?  newHeading.trueHeading : newHeading.magneticHeading);
 
 THCompass * compass = (THCompass*) self.simulableObject;
 compass.heading = heading;
 }*/

-(void) willStartSimulation{
    [super willStartSimulation];
    
    if([CLLocationManager headingAvailable]) {
        [_locationManager startUpdatingHeading];
        [_locationManager startUpdatingLocation];
    } else {
        NSLog(@"Can't report heading");
    }
    
    THAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    CMMotionManager * manager = appDelegate.motionManager;
    manager.accelerometerUpdateInterval = 1.0f / 20.0f;
    [manager startAccelerometerUpdates];
    
    _accelerometerBall.visible = YES;
    _compassCircle.visible = YES;
    self.sprite.visible = NO;
}

-(void) willStartEdition{
    
    THAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    CMMotionManager * manager = appDelegate.motionManager;
    [manager stopAccelerometerUpdates];
    [manager stopMagnetometerUpdates];
    
    _accelerometerBall.visible = NO;
    _compassCircle.visible = NO;
    self.sprite.visible = YES;
}

-(NSString*) description{
    return @"Compass";
}

@end
