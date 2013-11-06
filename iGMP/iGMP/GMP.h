//
//  GMPController.h
//  iGMP
//
//  Created by Juan Haladjian on 11/6/13.
//  Copyright (c) 2013 Technical University Munich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMPCommunicationModule.h"

#define IFParseBufSize 1024

@class GMP;

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

@protocol GMPControllerDelegate <NSObject>

@optional

-(void) firmataController:(GMP*) gmpController didReceiveFirmwareReport:(uint8_t*) buffer length:(NSInteger) length;

-(void) firmataController:(GMP*) gmpController didReceiveCapabilityResponse:(uint8_t*) buffer length:(NSInteger) length;

-(void) firmataController:(GMP*) gmpController didReceivePinStateResponse:(uint8_t*) buffer length:(NSInteger) length;

-(void) firmataController:(GMP*) gmpController didReceiveAnalogMappingResponse:(uint8_t*) buffer length:(NSInteger) length;

-(void) firmataController:(GMP*) gmpController didReceiveAnalogMessageOnChannel:(NSInteger) channel value:(NSInteger) value;

-(void) firmataController:(GMP*) gmpController didReceiveDigitalMessageForPort:(NSInteger) port value:(NSInteger) value;

-(void) firmataController:(GMP*) gmpController didReceiveI2CReply:(uint8_t*) buffer length:(NSInteger) length;

@end

@interface GMP : NSObject
{
    uint8_t parseBuf[IFParseBufSize];
    NSInteger parseCount;
    NSInteger parseCommandLength;
    
    BOOL waitingForFirmware;
    BOOL startedSysex;
}

@property (nonatomic, weak) GMPCommunicationModule * communicationModule;
@property (nonatomic, weak) id<GMPControllerDelegate> delegate;
@property (nonatomic, readonly) BOOL startedI2C;

-(void) reset;
-(void) sendFirmwareRequest;

/*
-(void) sendResetRequest;
-(void) sendCapabilitiesAndReportRequest;
-(void) sendPinQueryForPinNumbers:(NSInteger*) pinNumbers length:(NSInteger) length;
-(void) sendPinQueryForPinNumber:(NSInteger) pinNumber;
-(void) sendPinModeForPin:(NSInteger) pin mode:(IFPinMode) mode;
-(void) sendDigitalOutputForPort:(NSInteger) port value:(NSInteger) value;
-(void) sendAnalogOutputForPin:(NSInteger) pin value:(NSInteger) value;
-(void) sendReportRequestForAnalogPin:(NSInteger) pin reports:(BOOL) reports;
-(void) sendI2CStartReadingAddress:(NSInteger) address reg:(NSInteger) reg size:(NSInteger) size;
-(void) sendI2CConfigMessage;
-(void) sendI2CStopReadingAddress:(NSInteger) address;
-(void) sendI2CWriteValue:(NSInteger) value toAddress:(NSInteger) address reg:(NSInteger) reg;

-(void) didReceiveData:(uint8_t *)buffer lenght:(NSInteger)originalLength;
*/
@end

