/*
 THMPU6050.m
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

#import <Foundation/Foundation.h>


#import "THMPU6050.h"
#import "THElementPin.h"
#import "THI2CComponent.h"
#import "THI2CRegister.h"
#import "THI2CMessage.h"
#import "THAccelerometerData.h"

@implementation THMPU6050

NSInteger const kMPU6050Address = 0x68;
NSInteger const kMPU6050Register = 0x3B;

@synthesize i2cComponent;
@synthesize type;

#pragma mark - Initialization

-(id) init{
    self = [super init];
    if(self){
        [self loadMPU6050];
        [self loadMethods];
        [self loadPins];
        [self loadI2CComponent];
    }
    return self;
}

-(void) loadMPU6050{
    self.isI2CComponent = YES;
    
    self.i2cComponent = [[THI2CComponent alloc] init];
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder{
    
    self = [super initWithCoder:decoder];
    if(self){
        [self loadMPU6050];
        [self loadMethods];
        [self loadI2CComponent];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    [super encodeWithCoder:coder];
    
}

-(id)copyWithZone:(NSZone *)zone{
    
    THMPU6050 * copy = [super copyWithZone:zone];
    copy.i2cComponent = [self.i2cComponent copy];
    copy.type = self.type;
    
    return copy;
}

#pragma mark - Loading

-(void) loadMethods{
    
    TFProperty * property = [TFProperty propertyWithName:@"accelerometer" andType:kDataTypeAny];
    TFProperty * property1 = [TFProperty propertyWithName:@"accelerometerX" andType:kDataTypeFloat];
    TFProperty * property2 = [TFProperty propertyWithName:@"accelerometerY" andType:kDataTypeFloat];
    TFProperty * property3 = [TFProperty propertyWithName:@"accelerometerZ" andType:kDataTypeFloat];
    
    self.properties = [NSMutableArray arrayWithObjects:property1,property2,property3,nil];
    /*
    TFEvent * event1 = [TFEvent eventNamed:kEventXChanged];
    event1.param1 = [TFPropertyInvocation invocationWithProperty:property1 target:self];
    TFEvent * event2 = [TFEvent eventNamed:kEventYChanged];
    event2.param1 = [TFPropertyInvocation invocationWithProperty:property2 target:self];
    TFEvent * event3 = [TFEvent eventNamed:kEventZChanged];
    event3.param1 = [TFPropertyInvocation invocationWithProperty:property3 target:self];*/
    
    TFEvent * event = [TFEvent eventNamed:kEventNewValue];
    event.param1 = [TFPropertyInvocation invocationWithProperty:property target:self];
    self.events = [NSMutableArray arrayWithObjects:event,nil];
    
    TFMethod * method1 = [TFMethod methodWithName:@"start"];
    TFMethod * method2 = [TFMethod methodWithName:@"stop"];
    self.methods = [NSMutableArray arrayWithObjects:method1, method2, nil];
}

-(void) loadPins{
    
    THElementPin * minusPin = [THElementPin pinWithType:kElementPintypeMinus];
    THElementPin * plusPin = [THElementPin pinWithType:kElementPintypePlus];
    
    minusPin.hardware = self;
    THElementPin * sclPin = [THElementPin pinWithType:kElementPintypeScl];
    sclPin.hardware = self;
    sclPin.defaultBoardPinMode = kPinModeI2C;
    
    THElementPin * sdaPin = [THElementPin pinWithType:kElementPintypeSda];
    sdaPin.hardware = self;
    sdaPin.defaultBoardPinMode = kPinModeI2C;
    
    [self.pins addObject:minusPin];
    [self.pins addObject:plusPin];
    [self.pins addObject:sclPin];
    [self.pins addObject:sdaPin];
}

-(void) loadI2CComponent{
    
    self.i2cComponent = [[THI2CComponent alloc] init];
    self.i2cComponent.address = kMPU6050Address;
    
    THI2CRegister * reg1 = [[THI2CRegister alloc] init];
    reg1.number = kMPU6050Register;
    
    [self.i2cComponent addRegister:reg1];
}

#pragma mark - Methods

-(THElementPin*) sclPin{
    return [self.pins objectAtIndex:2];
}

-(THElementPin*) sdaPin{
    return [self.pins objectAtIndex:3];
}

-(void) setValuesFromBuffer:(uint8_t*) buffer length:(NSInteger) length{
    
    NSInteger size = 6;
    NSInteger bufCount = 0;
    uint8_t values[size];
    
    for (int i = 0; i < size; i++) {//firmata sends as two seven bit bytes
        uint8_t byte1 = buffer[bufCount++];
        uint8_t value = byte1 + (buffer[bufCount++] << 7);
        values[i] = value;
    }
    
    THAccelerometerData * accelerometerData = [[THAccelerometerData alloc] init];
    
    accelerometerData.x = (values[1] << 8 | values[0]) / 65536.0f;
    accelerometerData.y = (values[3] << 8 | values[2]) / 65536.0f;
    accelerometerData.z = (values[5] << 8 | values[4]) / 65536.0f;
    
    self.accelerometer = accelerometerData;
}

-(NSMutableArray*) startI2CMessages{
    
    THI2CMessage * message = [[THI2CMessage alloc] init];
    message.type = kI2CComponentMessageTypeStartReading;
    message.reg = kMPU6050Register;
    message.readSize = 6;
    
    NSMutableArray * array = [NSMutableArray arrayWithObjects:message,nil];
    return array;
}

-(void) setAccelerometer:(THAccelerometerData*)accelerometer{
    if(accelerometer != _accelerometer){
        _accelerometer = accelerometer;
        
        [self triggerEventNamed:kEventNewValue];
    }
}

-(void) didStartSimulating{
    /*
    [self triggerEventNamed:kEventNewValue];
    
    [self triggerEventNamed:kEventXChanged];
    [self triggerEventNamed:kEventYChanged];
    [self triggerEventNamed:kEventZChanged];*/
    
    [super didStartSimulating];
}


 -(float) accelerometerX{
     return self.accelerometer.x;
 }
 
 -(void) setAccelerometerX:(float)accelerometerX{
     
 self.accelerometer.x = accelerometerX;
 }
 
-(float) accelerometerY{
    return self.accelerometer.y;
 }
 
 -(void) setAccelerometerY:(float)accelerometerY{
 
     
     self.accelerometer.y = accelerometerY;
 }
 
-(float) accelerometerZ{
    return self.accelerometer.z;
 }
 
 -(void) setAccelerometerZ:(float)accelerometerZ{
     
  self.accelerometer.z = accelerometerZ;
 }

-(void) start{
    
}

-(void) stop{
    
}

-(NSString*) description{
    return @"mpu6050";
}

-(void) prepareToDie{
    
    self.i2cComponent = nil;
    
    [super prepareToDie];
}
@end
