//
//  IFFirmataController.h
//  BLEFirmata
//
//  Created by Juan Haladjian on 8/9/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEService.h"
#import "IFFirmataConstants.h"

#define IFParseBufSize 4096

@class IFFirmataController;
@class BLEService;
@class IFPin;
@class IFI2CRegister;
@class IFI2CComponent;

@protocol IFFirmataControllerDelegate <NSObject>

@optional

-(void) firmataController:(IFFirmataController*) firmataController didReceiveFirmwareReport:(uint8_t*) buffer length:(NSInteger) length;

-(void) firmataController:(IFFirmataController*) firmataController didReceiveCapabilityResponse:(uint8_t*) buffer length:(NSInteger) length;

-(void) firmataController:(IFFirmataController*) firmataController didReceivePinStateResponse:(uint8_t*) buffer length:(NSInteger) length;

-(void) firmataController:(IFFirmataController*) firmataController didReceiveAnalogMappingResponse:(uint8_t*) buffer length:(NSInteger) length;

-(void) firmataController:(IFFirmataController*) firmataController didReceiveAnalogMessageOnChannel:(NSInteger) channel value:(NSInteger) value;

-(void) firmataController:(IFFirmataController*) firmataController didReceiveDigitalMessageForPort:(NSInteger) port value:(NSInteger) value;

-(void) firmataController:(IFFirmataController*) firmataController didReceiveI2CReply:(uint8_t*) buffer length:(NSInteger) length;

@end

@interface IFFirmataController : NSObject <BLEServiceDataDelegate>
{
    uint8_t parseBuf[IFParseBufSize];
    NSInteger parseCount;
    NSInteger parseCommandLength;
    
    BOOL waitingForFirmware;
    BOOL startedSysex;
}


@property (nonatomic, weak) BLEService * bleService;
@property (nonatomic, weak) id<IFFirmataControllerDelegate> delegate;
@property (nonatomic, readonly) BOOL startedI2C;

-(void) reset;
-(void) sendFirmwareRequest;
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

@end
