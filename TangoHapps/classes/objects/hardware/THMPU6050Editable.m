/*
 THMPU6050Editable.m
 Interactex Designer
 
 Created by Juan Haladjian on 15/03/2015.
 
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
 
 Martijn ten Bhömer from TU Eindhoven contributed PureData support. Contact: m.t.bhomer@tue.nl.
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 */

#import "THMPU6050Editable.h"
#import "THMPU6050.h"
#import "THElementPinEditable.h"
#import "THCompassProperties.h"
#import "THAppDelegate.h"
#import "THAutorouteProperties.h"
#import "THBoardEditable.h"
#import "THBoardPinEditable.h"
#import "THAccelerometerData.h"

@implementation THMPU6050Editable

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THMPU6050 alloc] init];
        
        [self loadCompass];
        [super loadPins];
    }
    return self;
}

-(void) loadCompass{
    
    self.isI2CComponent = YES;
    
    self.type = kHardwareTypeMPU6050;
    
    self.isAccelerometerEnabled = YES;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        [self loadCompass];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THMPU6050Editable * copy = [super copyWithZone:zone];
    
    copy.componentType = self.componentType;
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    
    //[controllers addObject:[THCompassProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(THElementPinEditable*) sclPin{
    return [self.pins objectAtIndex:2];
}

-(THElementPinEditable*) sdaPin{
    return [self.pins objectAtIndex:3];
}

-(void) update{
    
    THAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    CMMotionManager * manager = appDelegate.motionManager;
    CMAccelerometerData * accelerometerData = manager.accelerometerData;
    
    THAccelerometerData * myAccel = [[THAccelerometerData alloc] init];
    myAccel.x = accelerometerData.acceleration.y;
    myAccel.y = -accelerometerData.acceleration.x;
    myAccel.z = accelerometerData.acceleration.z;
    
    self.accelerometer = myAccel;
}

-(THAccelerometerData*) accelerometer{
    THMPU6050 * mpu6050 = (THMPU6050*) self.simulableObject;
    return mpu6050.accelerometer;
}

-(void) setAccelerometer:(THAccelerometerData*)accelerometer{
    
    THMPU6050 * mpu6050 = (THMPU6050*) self.simulableObject;
    mpu6050.accelerometer = accelerometer;
}

/*
-(float) accelerometerX{
    THMPU6050 * mpu6050 = (THMPU6050*) self.simulableObject;
    return mpu6050.accelerometerX;
}

-(void) setAccelerometerX:(float)accelerometerX{
    
    THMPU6050 * mpu6050 = (THMPU6050*) self.simulableObject;
    mpu6050.accelerometerX = accelerometerX;
}

-(float) accelerometerY{
    THMPU6050 * mpu6050 = (THMPU6050*) self.simulableObject;
    return mpu6050.accelerometerY;
}

-(void) setAccelerometerY:(float)accelerometerY{
    
    THMPU6050 * mpu6050 = (THMPU6050*) self.simulableObject;
    mpu6050.accelerometerY = accelerometerY;
}

-(float) accelerometerZ{
    THMPU6050 * mpu6050 = (THMPU6050*) self.simulableObject;
    return mpu6050.accelerometerZ;
}

-(void) setAccelerometerZ:(float)accelerometerZ{
    
    THMPU6050 * mpu6050 = (THMPU6050*) self.simulableObject;
    mpu6050.accelerometerZ = accelerometerZ;
}*/

#pragma mark - Lifecycle

-(void) autoroute{
    [super autoroute];
    
    [self autoroutePin:self.sclPin];
    [self autoroutePin:self.sdaPin];
}

-(void) willStartSimulation{
    
    
    THAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    CMMotionManager * manager = appDelegate.motionManager;
    manager.accelerometerUpdateInterval = 1.0f / 30.0f;
    [manager startAccelerometerUpdates];
    
    [super willStartSimulation];
    
    //self.sprite.visible = NO;
}

-(void) willStartEdition{
    
    THAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    CMMotionManager * manager = appDelegate.motionManager;
    [manager stopAccelerometerUpdates];
    
    //self.sprite.visible = YES;
}

-(NSString*) description{
    return @"MPU6050";
}

@end
