//
//  THCompassEditableObject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/20/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THCompassEditableObject.h"
#import "THCompass.h"
#import "THElementPinEditable.h"

@implementation THCompassEditableObject

-(void) loadCompass{
    self.sprite = [CCSprite spriteWithFile:@"compass.png"];
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
        self.simulableObject = [[THCompass alloc] init];
        
        self.type = kHardwareTypeCompass;
        
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
    THCompassEditableObject * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers {
    NSMutableArray *controllers = [NSMutableArray array];

    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(void) handleAccelerated:(UIAcceleration*) acceleration{
    
    //NSLog(@"accel: %f %f",acceleration.y,-acceleration.x);
    
    self.accelerometerX = acceleration.y * 300;
    self.accelerometerY = -acceleration.x * 300;
    //NSLog(@"accel: %d %d",self.x,self.y);
}

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
    
    _compassCircle.rotation = 90 - self.heading;
    
    [self updateBallPosition];
}

-(void) handleDoubleTapped{
    
}

-(NSInteger) accelerometerX{
    THCompass * compass = (THCompass*) self.simulableObject;
    return compass.accelerometerX;
}

-(void) setAccelerometerX:(NSInteger)accelerometerX{
    
    THCompass * compass = (THCompass*) self.simulableObject;
    compass.accelerometerX = accelerometerX;
}

-(NSInteger) accelerometerY{
    THCompass * compass = (THCompass*) self.simulableObject;
    return compass.accelerometerY;
}

-(void) setAccelerometerY:(NSInteger)accelerometerY{
    
    THCompass * compass = (THCompass*) self.simulableObject;
    compass.accelerometerY = accelerometerY;
}

-(NSInteger) accelerometerZ{
    THCompass * compass = (THCompass*) self.simulableObject;
    return compass.accelerometerZ;
}

-(void) setAccelerometerZ:(NSInteger)accelerometerZ{
    
    THCompass * compass = (THCompass*) self.simulableObject;
    compass.accelerometerZ = accelerometerZ;
}

-(float) heading{
    THCompass * compass = (THCompass*) self.simulableObject;
    return compass.heading;
}

- (void) locationManager:(CLLocationManager *)manager
        didUpdateHeading:(CLHeading *)newHeading{
    
    if (newHeading.headingAccuracy < 0)
        return;
    
    CLLocationDirection  heading = ((newHeading.trueHeading > 0) ?  newHeading.trueHeading : newHeading.magneticHeading);
    
    THCompass * compass = (THCompass*) self.simulableObject;
    compass.heading = heading;
}

-(void) willStartSimulation{
    [super willStartSimulation];
    
    if([CLLocationManager headingAvailable]) {
        [_locationManager startUpdatingHeading];
        [_locationManager startUpdatingLocation];
    } else {
        NSLog(@"Can't report heading");
    }
    
    _accelerometerBall.visible = YES;
    _compassCircle.visible = YES;
    self.sprite.visible = NO;
}

-(void) willStartEdition{
    /*
    if(_accelerometerBall){
        [_accelerometerBall removeFromParentAndCleanup:YES];
    }
    if(_compassCircle){
        [_compassCircle removeFromParentAndCleanup:YES];
    }*/
    
    self.sprite.visible = YES;
}

-(NSString*) description{
    return @"Compass";
}

@end
