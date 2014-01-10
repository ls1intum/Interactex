//
//  IFFirmataController.h
//  BLEFirmata
//
//  Created by Juan Haladjian on 8/9/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

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
-(void) sendReportRequestForAnalogPin:(NSInteger) pin reports:(BOOL) reports;
-(void) sendI2CStartReadingAddress:(NSInteger) address reg:(NSInteger) reg size:(NSInteger) size;
-(void) sendI2CConfigMessage;
-(void) sendI2CStopReadingAddress:(NSInteger) address;
-(void) sendI2CWriteToAddress:(NSInteger) address reg:(NSInteger) reg bytes:(uint8_t*) bytes numBytes:(NSInteger) numBytes;

-(void) didReceiveData:(uint8_t *)buffer lenght:(NSInteger)originalLength;

@end
