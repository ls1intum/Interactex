//
//  IFFirmata.h
//  iFirmata
//
//  Created by Juan Haladjian on 6/28/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEService.h"
#import "IFPin.h"

typedef struct{
    uint64_t supportedModes;
    uint8_t analogChannel;
} PinInfo;

@class IFFirmataController;
@class IFI2CComponent;

@protocol IFFirmataControllerDelegate <NSObject>

-(void) firmataDidUpdateDigitalPins:(IFFirmataController*) firmataController;
-(void) firmataDidUpdateAnalogPins:(IFFirmataController*) firmataController;
-(void) firmataDidUpdateI2CComponents:(IFFirmataController*) firmataController;

-(void) firmata:(IFFirmataController*) firmataController didUpdateTitle:(NSString*) title;

@end

@interface IFFirmataController : NSObject <BLEServiceDataDelegate> {
    NSInteger parse_count;
    NSInteger parse_command_len;
    
    uint8_t parse_buf[4096];
    PinInfo pinInfo[128];
    
    BOOL startedSysex;
    BOOL startedI2C;
    BOOL waitingForFirmware;
}

@property (nonatomic, readonly) NSInteger numDigitalPins;
@property (nonatomic, readonly) NSInteger numAnalogPins;
@property (nonatomic, readonly) NSInteger numPins;

@property (nonatomic, strong) NSMutableArray * digitalPins;
@property (nonatomic, strong) NSMutableArray * analogPins;
@property (nonatomic, strong) NSMutableArray * i2cComponents;
@property (nonatomic, weak) BLEService * bleService;
@property (nonatomic, weak) id<IFFirmataControllerDelegate> delegate;

@property (nonatomic, strong) NSString* firmataName;

-(void) start;
-(void) stop;

-(void) sendFirmwareRequest;
-(void) sendResetRequest;

-(void) sendReportRequestForAnalogPin:(IFPin*) pin;
-(void) stopReportingAnalogPins;

-(void) sendPinModeForPin:(IFPin*) pin;
-(void) sendPwmOutputForPin:(IFPin*) pin;
-(void) sendOutputForPin:(IFPin*) pin;

-(void) sendI2CStartStopReportingRequestForRegister:(IFI2CRegister*) reg fromComponent:(IFI2CComponent*) component;

-(void) sendI2CStartReadingForRegister:(IFI2CRegister*) reg fromComponent:(IFI2CComponent*) component;
-(void) sendI2CStopReadingAddress:(NSInteger) address;
-(void) sendI2CStopReadingComponent:(IFI2CComponent*) component;
-(void) sendI2CWriteData:(NSString*) data forRegister:(IFI2CRegister*) reg fromComponent:(IFI2CComponent*) component;
-(void) stopReportingI2CComponents;
-(void) stopReportingI2CComponent:(IFI2CComponent*) component;

-(void) addI2CComponent:(IFI2CComponent*) component;
-(void) removeI2CComponent:(IFI2CComponent*) component;

-(void) addI2CRegister:(IFI2CRegister*) reg toComponent:(IFI2CComponent*) component;
-(void) removeI2CRegister:(IFI2CRegister*) reg fromComponent:(IFI2CComponent*) component;
@end
