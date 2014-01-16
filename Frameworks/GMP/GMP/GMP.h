/*
GMP.h
GMP

Created by Juan Haladjian on 11/06/2013.

GMP is a library used to remotely control a microcontroller. GMP is based on Firmata: www.firmata.org

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany

Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
It has been created with funding from EIT ICT, as part of the activity "Connected Textiles".


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import <Foundation/Foundation.h>

#import "GMPCommunicationModule.h"

#define IFParseBufSize 1024

typedef struct
{
    uint8_t index;
    uint8_t capability;
} pin_t;

typedef struct
{
    uint8_t pins[8];
}group_t;


@class GMP;

// pin modes
// bit 0 1:digital (gpio),
// bit 3~1 001: pwm, 010: adc, 011: dac, 100: comperator
// bit 7~4 0001: uart, 0010: spi, 0100: i2c, 1000: one wire
typedef enum {
    kGMPCapabilityGPIO = 0x01,
    kGMPCapabilityPWM	= 0x02,
    kGMPCapabilityADC	= 0x04,
    kGMPCapabilityDAC	= 0x06,
    kGMPCapabilityCOMP = 0x08,
    kGMPCapabilityUART = 0x10,
    kGMPCapabilitySPI	= 0x20,
    kGMPCapabilityI2C	= 0x40,
    kGMPCapabilityOneWire = 0x80
} GMPPinCapability;

//servo?

typedef enum{
    kGMPPinModeInput = 0x00,
    kGMPPinModeOutput,
    kGMPPinModeAnalog,
    kGMPPinModePWM,
    kGMPPinModeServo,
    kGMPPinModeShift,
    kGMPPinModeI2C
} GMPPinMode;

/*
typedef enum {
    kGMPParsinStateNone,
    kGMPParsinStateFirmware
    
}GMPParsinState;*/

extern NSString * const kGMPFirmwareName;

@protocol GMPControllerDelegate <NSObject>

@optional

-(void) gmpController:(GMP*) gmpController didReceiveFirmwareName: (NSString*) name;

-(void) gmpController:(GMP*) gmpController didReceiveCapabilityResponseForPins:(uint8_t*) buffer count:(NSInteger) count;

-(void) gmpController:(GMP*) gmpController didReceivePinStateResponseForPin:(NSInteger) pin mode:(GMPPinMode) mode;

-(void) gmpController:(GMP*) gmpController didReceiveAnalogMessageForPin:(NSInteger) pin value:(NSInteger) value;

-(void) gmpController:(GMP*) gmpController didReceiveDigitalMessageForPin:(NSInteger) pin value:(BOOL) value;

-(void) gmpController:(GMP*) gmpController didReceiveI2CReplyForAddress:(NSInteger) address reg:(NSInteger) reg buffer:(uint8_t*) buffer length:(NSInteger) length;

@end

@interface GMP : NSObject {
}

@property (nonatomic, strong) GMPCommunicationModule * communicationModule;
@property (nonatomic, weak) id<GMPControllerDelegate> delegate;

@property (nonatomic, readonly) BOOL isI2CEnabled;
//@property (nonatomic, readonly) NSInteger numberOfPins;

//Initialization / Termination
-(void) sendFirmwareRequest;
-(void) sendCapabilitiesRequest;
-(void) sendResetRequest;

//Modes
-(void) sendPinModeRequestForPin:(NSInteger) pin;
-(void) sendPinModeForPin:(NSInteger) pin mode:(GMPPinMode) mode;
-(void) sendPinModesForPins:(pin_t*) pinModes count:(NSInteger) count;

//Digital
-(void) sendDigitalOutputForPin:(NSInteger) pin value:(NSInteger) value;
-(void) sendDigitalReadForPin:(NSInteger) pin;
-(void) sendReportRequestForDigitalPin:(NSInteger) pin reports:(BOOL) reports;

//Analog
-(void) sendAnalogReadForPin:(NSInteger) pin;
-(void) sendReportRequestForAnalogPin:(NSInteger) pin reports:(BOOL) reports;
-(void) sendAnalogWriteForPin:(NSInteger) pin value:(NSInteger) value;

//I2C
-(void) sendI2CReadAddress:(NSInteger) address reg:(NSInteger) reg size:(NSInteger) size;
-(void) sendI2CStartReadingAddress:(NSInteger) address reg:(NSInteger) reg size:(NSInteger) size;
-(void) sendI2CWriteToAddress:(NSInteger) address reg:(NSInteger) reg values:(uint8_t*) values numValues:(NSInteger) numValues;

-(void) sendI2CStopStreamingAddress:(NSInteger) address;
-(void) sendI2CConfigMessage;

//Other
-(void) didReceiveData:(uint8_t *)buffer lenght:(NSInteger)originalLength;

@end

