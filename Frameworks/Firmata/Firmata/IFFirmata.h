/*
IFFirmata.h
IFFirmata

Created by Juan Haladjian on 08/09/2013.

IFFirmata is a library used to control an Arduino board based on the Firmata protocol: www.firmata.org
 
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

#define IFParseBufSize 4096

@class IFFirmataCommunicationModule;
@class IFFirmata;
@class BLEService;

typedef enum{
    IFPinTypeDigital,
    IFPinTypeAnalog,
} IFPinType;

typedef enum{
    IFPinModeInput,
    IFPinModeOutput,
    IFPinModeAnalog,
    IFPinModePWM,
    IFPinModeServo,
    IFPinModeShift,
    IFPinModeI2C
} IFPinMode;

@protocol IFFirmataControllerDelegate <NSObject>

@optional

-(void) firmataController:(IFFirmata*) firmataController didReceiveFirmwareName:(NSString*) name;

-(void) firmataController:(IFFirmata*) firmataController didReceiveCapabilityResponse:(uint8_t*) buffer length:(NSInteger) length;

-(void) firmataController:(IFFirmata*) firmataController didReceivePinStateResponse:(uint8_t*) buffer length:(NSInteger) length;

-(void) firmataController:(IFFirmata*) firmataController didReceiveAnalogMappingResponse:(uint8_t*) buffer length:(NSInteger) length;

-(void) firmataController:(IFFirmata*) firmataController didReceiveAnalogMessageOnChannel:(NSInteger) channel value:(NSInteger) value;

-(void) firmataController:(IFFirmata*) firmataController didReceiveDigitalMessageForPort:(NSInteger) port value:(NSInteger) value;

-(void) firmataController:(IFFirmata*) firmataController didReceiveI2CReply:(uint8_t*) buffer length:(NSInteger) length;

@end

/*
@protocol IFFirmataDataDelegate <NSObject>

@required
-(void) didReceiveData:(uint8_t *)buffer lenght:(NSInteger)originalLength;

@end*/


@interface IFFirmata : NSObject
{
    uint8_t parseBuf[IFParseBufSize];
    NSInteger parseCount;
    NSInteger parseCommandLength;
    
    BOOL waitingForFirmware;
    BOOL startedSysex;
}

@property (nonatomic, weak) IFFirmataCommunicationModule * communicationModule;
@property (nonatomic, weak) id<IFFirmataControllerDelegate> delegate;
@property (nonatomic, readonly) BOOL startedI2C;
@property (nonatomic, copy) NSString * firmwareName;

-(void) reset;
-(void) sendFirmwareRequest;
-(void) sendResetRequest;
-(void) sendAnalogMappingRequest;
-(void) sendCapabilitiesRequest;
-(void) sendPinQueryForPinNumbers:(NSInteger*) pinNumbers length:(NSInteger) length;
-(void) sendPinModeRequestForPin:(NSInteger) pinNumber;
-(void) sendPinModeForPin:(NSInteger) pin mode:(IFPinMode) mode;
-(void) sendDigitalOutputForPort:(NSInteger) port value:(NSInteger) value;
-(void) sendAnalogOutputForPin:(NSInteger) pin value:(NSInteger) value;
-(void) sendReportRequestsForDigitalPins;
-(void) sendReportRequestForAnalogPin:(NSInteger) pin reports:(BOOL) reports;
-(void) sendI2CStartReadingAddress:(NSInteger) address reg:(NSInteger) reg size:(NSInteger) size;
-(void) sendI2CConfigMessage;
-(void) sendI2CStopReadingAddress:(NSInteger) address;
-(void) sendI2CWriteToAddress:(NSInteger) address reg:(NSInteger) reg bytes:(uint8_t*) bytes numBytes:(NSInteger) numBytes;

-(void) didReceiveData:(uint8_t *)buffer lenght:(NSInteger)originalLength;

@end
