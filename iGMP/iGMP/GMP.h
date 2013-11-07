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
    GPIO = 0x01,
    PWM	= 0x02,
    ADC	= 0x04,
    DAC	= 0x06,
    COMP = 0x08,
    UART = 0x10,
    SPI	= 0x20,
    I2C	= 0x40,
    ONE_WIRE = 0x80
} GMPPinMode;

/*
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
} IFPinMode;*/
/*
typedef enum {
    kGMPParsinStateNone,
    kGMPParsinStateFirmware
    
}GMPParsinState;*/

@protocol GMPControllerDelegate <NSObject>

@optional

-(void) gmpController:(GMP*) gmpController didReceiveFirmwareName: (NSString*) name;

-(void) gmpController:(GMP*) gmpController didReceiveCapabilityResponseForPin:(pin_t) pin;

-(void) gmpController:(GMP*) gmpController didReceivePinStateResponse:(uint8_t*) buffer length:(NSInteger) length;
/*
-(void) gmpController:(GMP*) gmpController didReceiveAnalogMessageOnChannel:(NSInteger) channel value:(NSInteger) value;*/

-(void) gmpController:(GMP*) gmpController didReceiveDigitalMessageForPin:(NSInteger) pin value:(NSInteger) value;

-(void) gmpController:(GMP*) gmpController didReceiveI2CReply:(uint8_t*) buffer length:(NSInteger) length;

@end

@interface GMP : NSObject
{
    pin_t pins[64];
    NSInteger numPins;
}

@property (nonatomic, strong) GMPCommunicationModule * communicationModule;
@property (nonatomic, weak) id<GMPControllerDelegate> delegate;
@property (nonatomic, readonly) BOOL startedI2C;

-(void) sendFirmwareRequest;
-(void) sendCapabilitiesAndReportRequest;
-(void) sendPinModeForPin:(NSInteger) pin mode:(GMPPinMode) mode;
-(void) sendPinModesForPins:(pin_t*) pinModes count:(NSInteger) count;

/*
-(void) sendPinQueryForPinNumbers:(NSInteger*) pinNumbers length:(NSInteger) length;
-(void) sendPinQueryForPinNumber:(NSInteger) pinNumber;

-(void) sendDigitalOutputForPort:(NSInteger) port value:(NSInteger) value;
-(void) sendAnalogOutputForPin:(NSInteger) pin value:(NSInteger) value;
-(void) sendReportRequestForAnalogPin:(NSInteger) pin reports:(BOOL) reports;
 */

//I2C

-(void) sendI2CReadAddress:(NSInteger) address reg:(NSInteger) reg size:(NSInteger) size;
-(void) sendI2CStartReadingAddress:(NSInteger) address reg:(NSInteger) reg size:(NSInteger) size;

-(void) sendI2CWriteValue:(NSInteger) value toAddress:(NSInteger) address reg:(NSInteger) reg;

-(void) sendI2CStopStreamingAddress:(NSInteger) address;
-(void) sendI2CConfigMessage;

 -(void) sendResetRequest;

-(void) didReceiveData:(uint8_t *)buffer lenght:(NSInteger)originalLength;

@end

