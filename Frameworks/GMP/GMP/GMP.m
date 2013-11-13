//
//  IFFirmataController.m
//  BLEFirmata
//
//  Created by Juan Haladjian on 8/9/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "GMP.h"
#import "GMPCommunicationModule.h"

#define DELIMITER   0xAA

//message type
enum
{
    FIRMWARE_QUERY = 0x00,
    FIRMWARE_RESPONSE,
    CAPABILITY_QUERY,
    CAPABILITY_RESPONSE,
    CREATE_GROUP_REQUEST,
    CREATE_GROUP_RESPONSE,
    PIN_MODE_SET,
    PIN_MODE_QUERY,
    PIN_MODE_RESPONSE,
    DIO_INPUT,
    DIO_INPUT_STREAM,
    DIO_OUTPUT,
    ADC_READ,
	ADC_READ_STREAM,
    DAC_WRITE,
    PWM_CONFIG,
    I2C_CONFIG,
    I2C_READ,
    I2C_READ_STREAM,
    I2C_WRITE,
    I2C_WRITE_STREAM,
    I2C_STOP_STREAM,
    SPI_CONFIG,
    SPI_READ,
    SPI_WRITE,
    UART_CONFIG,
    UART_READ,
    UART_WRITE,
    HW_TIMER_CONFIG,
    WATCHDOG_CONFIG,
    SYS_RESET,
    CLK_CONFIG,
    ACK_ENABLE = 0x80,
    ACK = 0x81,
};

@implementation GMP


NSString * const kGMPFirmwareName = @"eGMCP1.0";

#pragma mark - Send Messages

-(void) sendFirmwareRequest{
    
    uint8_t data = FIRMWARE_QUERY;
    
    [self.communicationModule sendData:&data count:1];
}


-(void) sendCapabilitiesRequest{
    
    uint8_t data = CAPABILITY_QUERY;
    
    [self.communicationModule sendData:&data count:1];
    
    _isI2CEnabled = NO;
}

-(void) sendResetRequest{
    
    uint8_t msg = SYS_RESET;
    
    [self.communicationModule sendData:&msg count:1];
    
}

-(void) sendPinModeForPin:(NSInteger) pin mode:(GMPPinMode) mode {
    
    uint8_t buf[4];
    
    buf[0] = PIN_MODE_SET;
    buf[1] = 1;
    buf[2] = pin;
    buf[3] = mode;
    
    [self.communicationModule sendData:buf count:4];
}

-(void) sendPinModeRequestForPin:(NSInteger) pin {
    
    uint8_t buf[3];
    
    buf[0] = PIN_MODE_QUERY;
    buf[1] = 1;
    buf[2] = pin;
    
    [self.communicationModule sendData:buf count:3];
}

-(void) sendPinModesForPins:(pin_t*) pinModes count:(NSInteger) count{
    
    NSInteger bufLength = count*2+2;
    
    uint8_t buf[bufLength];
    
    buf[0] = PIN_MODE_SET;
    buf[1] = count;
    
    for (int i = 0; i < count; i++) {
        
        buf[i*2+2] = pinModes[i].index;
        buf[i*2+3] = pinModes[i].capability;
    }
    
    [self.communicationModule sendData:buf count:bufLength];
}

-(void) sendDigitalOutputForPin:(NSInteger) pin value:(NSInteger) value{
    
    uint8_t buf[3];
    
    buf[0] = DIO_OUTPUT;
    buf[1] = pin;
    buf[2] = value;
    
    [self.communicationModule sendData:buf count:3];
}

-(void) sendDigitalReadForPin:(NSInteger) pin{
    
    uint8_t buf[2];
    
    buf[0] = DIO_INPUT;
    buf[1] = pin;
    
    [self.communicationModule sendData:buf count:2];
}

-(void) sendReportRequestForDigitalPin:(NSInteger) pin reports:(BOOL) reports{
    
    uint8_t buf[3];
    
    buf[0] = DIO_INPUT_STREAM;
    buf[1] = pin;
    buf[2] = reports;
    
    [self.communicationModule sendData:buf count:3];
}


-(void) sendAnalogReadForPin:(NSInteger) pin{
    
    uint8_t buf[2];
    
    buf[0] = ADC_READ;
    buf[1] = pin;
    
    [self.communicationModule sendData:buf count:2];
}

-(void) sendReportRequestForAnalogPin:(NSInteger) pin reports:(BOOL) reports{
    
    uint8_t buf[3];
    
    buf[0] = ADC_READ_STREAM;
    buf[1] = pin;
    buf[2] = reports;
    
    [self.communicationModule sendData:buf count:3];
}

-(void) sendAnalogWriteForPin:(NSInteger) pin value:(NSInteger) value{
    
    uint8_t buf[3];
    
    buf[0] = DAC_WRITE;
    buf[1] = pin;
    buf[2] = value;
    
    [self.communicationModule sendData:buf count:3];
}

-(void)sendI2CConfigMessage{
    
    uint8_t buf[3];
    
    buf[0] = I2C_CONFIG;
    buf[1] = 0;
    buf[2] = 0;
    
    [self.communicationModule sendData:buf count:3];
    
    _isI2CEnabled = YES;
}

-(void) checkEnableI2C{
    if (!self.isI2CEnabled) {
        [self sendI2CConfigMessage];
    }
}

-(void) sendI2CReadAddress:(NSInteger) address reg:(NSInteger) reg size:(NSInteger) size{
    
    uint8_t buf[4];
    
    buf[0] = I2C_READ;
    buf[1] = address;
    buf[2] = reg;
    buf[3] = size;
    
    [self.communicationModule sendData:buf count:4];
}

-(void) sendI2CStartReadingAddress:(NSInteger) address reg:(NSInteger) reg size:(NSInteger) size{
    
    [self checkEnableI2C];
    
    uint8_t buf[4];
    
    buf[0] = I2C_READ_STREAM;
    buf[1] = address;
    buf[2] = reg;
    buf[3] = size;
    
    [self.communicationModule sendData:buf count:4];
}


-(void) sendI2CWriteToAddress:(NSInteger) address reg:(NSInteger) reg values:(uint8_t*) values numValues:(NSInteger) numValues {
    
    [self checkEnableI2C];
    
    NSInteger size = 2 * numValues + 4;
    uint8_t buf[size];
    
    buf[0] = I2C_WRITE;
    buf[1] = address;
    buf[2] = reg;
    buf[3] = numValues;
    
    memcpy(buf + 4, values, 2 * numValues);
    
    [self.communicationModule sendData:buf count:size];
}

-(void) sendI2CStartWritingAddress:(NSInteger) address reg:(NSInteger) reg size:(NSInteger) size{
    
    [self checkEnableI2C];
    
    /*
    uint8_t buf[4];
    
    buf[0] = I2C_WRITE_STREAM;
    buf[1] = address;
    buf[2] = reg;
    buf[3] = size;
    
    [self.communicationModule sendData:buf count:4];*/
}

-(void) sendI2CStopStreamingAddress:(NSInteger) address{
    
    [self checkEnableI2C];
    
    uint8_t buf[2];
    
    buf[0] = I2C_STOP_STREAM;
    buf[1] = address;
    
    [self.communicationModule sendData:buf count:2];
}

#pragma mark - Receive Messages


-(void) didReceiveData:(uint8_t *)buffer lenght:(NSInteger)length{
    /*
     printf("\n ");
     NSLog(@"**Data received, length: %d**",length);
    
    for (int i = 0 ; i < length; i++) {
        int value = buffer[i];
        printf("%d ",value);
    }
    printf("\n ");*/
    
    uint8_t value = buffer[0];
    
    if(value == FIRMWARE_RESPONSE){
        
        char buf[length];
        memcpy(buf, buffer+1, length-1);
        buf[length-1] = 0;
        
        NSString * firmwareName = [NSString stringWithUTF8String:buf];
        
        [self.delegate gmpController:self didReceiveFirmwareName:firmwareName];
        
    } else if(value == CAPABILITY_RESPONSE){
        
        //_numberOfPins = (length-1)/2;
        
        [self.delegate gmpController:self didReceiveCapabilityResponseForPins:&buffer[1] count:length-1];
       
        
    } else if(value == PIN_MODE_RESPONSE){
        
        NSInteger pin = buffer[1];
        uint8_t mode = buffer[2];
        [self.delegate gmpController:self didReceivePinStateResponseForPin:pin mode:mode];
        
    } else if(value == DIO_INPUT){
        
        NSInteger pin = buffer[1];
        BOOL value = buffer[2];
        [self.delegate gmpController:self didReceiveDigitalMessageForPin:pin value:value];
        
    } else if(value == ADC_READ){
        
        NSInteger pin = buffer[1];
        uint8_t value1 = buffer[2];
        uint8_t value2 = buffer[3];
        
        NSInteger value = value1 | (value2 << 7);
        
        [self.delegate gmpController:self didReceiveAnalogMessageForPin:pin value:value];
        
    } else if(value == I2C_READ){
        /*
         for(int i = 1 ; i < length ; i++){
         uint8_t val = buffer[i];
         NSLog(@"received i2c value: %d",val);
         }*/
        
        NSInteger address = buffer[1];
        NSInteger reg = buffer[2];
        
        uint8_t buf[length-3];
        memcpy(buf, buffer+3, length-3);
        
        [self.delegate gmpController:self didReceiveI2CReplyForAddress:address reg:reg buffer:buf length:length-3];
        
    }
}

@end
