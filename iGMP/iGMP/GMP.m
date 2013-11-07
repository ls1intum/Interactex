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
    DIO_OUTPUT,
    ADC_READ,
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

#pragma mark - Send Messages

-(void) sendFirmwareRequest{
    
    uint8_t data = FIRMWARE_QUERY;
    
    [self.communicationModule sendData:&data count:1];
}


-(void) sendCapabilitiesAndReportRequest{
    
    uint8_t data = CAPABILITY_QUERY;
    
    [self.communicationModule sendData:&data count:1];
}

-(void) sendPinModeForPin:(NSInteger) pin mode:(GMPPinMode) mode {
    
    uint8_t buf[4];
    
    buf[0] = PIN_MODE_SET;
    buf[1] = 1;
    buf[2] = pin;
    buf[3] = mode;
    
    [self.communicationModule sendData:buf count:4];
}

-(void) sendPinModesForPins:(pin_t*) pinModes count:(NSInteger) count{
    
    NSInteger bufLength = count*2+2;
    
    uint8_t buf[bufLength];
    
    buf[0] = PIN_MODE_SET;
    buf[1] = count;
    
    for (int i = 0; i < count; i++) {
        
        buf[i*2+2] = pinModes[i].index;
        buf[i*2+3] = pinModes[i].capability;
        
        [self.communicationModule sendData:buf count:bufLength];
    }
}

/*
-(void) sendPinQueryForPinNumbers:(NSInteger*) pinNumbers length:(NSInteger) length{
    
    uint8_t buf[length * 4];
    NSInteger bufLength = 0;
    
    for (int i = 0; i < length; i++) {
        
        buf[bufLength++] = START_SYSEX;
        buf[bufLength++] = PIN_STATE_QUERY;
        buf[bufLength++] = pinNumbers[i];
        buf[bufLength++] = END_SYSEX;
        
    }
    
    [self.communicationModule sendData:buf count:bufLength];
    //    [self.bleService sendData:buf count:bufLength];
}

-(void) sendPinQueryForPinNumber:(NSInteger) pinNumber{
    
    uint8_t buf[4];
    buf[0] = START_SYSEX;
    buf[1] = PIN_STATE_QUERY;
    buf[2] = pinNumber;
    buf[3] = END_SYSEX;
    
    
    [self.communicationModule sendData:buf count:4];
    //    [self.bleService sendData:buf count:4];
}
*/

/*
-(void) sendAnalogOutputForPin:(NSInteger) pin value:(NSInteger) value{
    
	if (pin <= 15 && value <= 16383) {
		uint8_t buf[3];
		buf[0] = 0xE0 | pin;
		buf[1] = value & 0x7F;
		buf[2] = (value >> 7) & 0x7F;
        
        
        [self.communicationModule sendData:buf count:3];
        //        [self.bleService sendData:buf count:3];
        
	}
}

-(void) sendDigitalOutputForPort:(NSInteger) port value:(NSInteger) value{
    
    uint8_t buf[3];
    buf[0] = 0x90 | port;
    buf[1] = value & 0x7F;
    buf[2] = (value >> 7) & 0x7F;
    
    [self.communicationModule sendData:buf count:3];
}

-(void) sendReportRequestForAnalogPin:(NSInteger) pin reports:(BOOL) reports{
    
    uint8_t buf[2];
    buf[0] = 0xC0 | pin;
    buf[1] = reports;
    
    [self.communicationModule sendData:buf count:2];
    //[self.communicationModule sendData:buf count:2];
}
*/

-(void) sendI2CReadAddress:(NSInteger) address reg:(NSInteger) reg size:(NSInteger) size{
    
    uint8_t buf[4];
    
    buf[0] = I2C_READ;
    buf[1] = address;
    buf[2] = reg;
    buf[3] = size;
    
    [self.communicationModule sendData:buf count:4];
}

-(void) sendI2CStartReadingAddress:(NSInteger) address reg:(NSInteger) reg size:(NSInteger) size{
    
    uint8_t buf[4];
    
    buf[0] = I2C_READ_STREAM;
    buf[1] = address;
    buf[2] = reg;
    buf[3] = size;
    
    [self.communicationModule sendData:buf count:4];
}


-(void) sendI2CWriteValue:(NSInteger) value toAddress:(NSInteger) address reg:(NSInteger) reg {
    
    uint8_t buf[4];
    
    buf[0] = I2C_WRITE;
    buf[1] = address;
    buf[2] = reg;
    buf[3] = value;
    
    [self.communicationModule sendData:buf count:4];
}

-(void) sendI2CStartWritingAddress:(NSInteger) address reg:(NSInteger) reg size:(NSInteger) size{
    /*
    uint8_t buf[4];
    
    buf[0] = I2C_WRITE_STREAM;
    buf[1] = address;
    buf[2] = reg;
    buf[3] = size;
    
    [self.communicationModule sendData:buf count:4];*/
}

-(void) sendI2CStopStreamingAddress:(NSInteger) address{
    
    uint8_t buf[2];
    
    buf[0] = I2C_STOP_STREAM;
    buf[1] = address;
    
    [self.communicationModule sendData:buf count:2];
}

-(void) sendI2CConfigMessage{
    /*
    uint8_t buf[5];
    
    [self.communicationModule sendData:buf count:5];
    //[self.communicationModule sendData:buf count:5];
     */
}

-(void) sendResetRequest{
    
    uint8_t msg = SYS_RESET;
    
    [self.communicationModule sendData:&msg count:1];
}

#pragma mark - Receive Messages


-(void) didReceiveData:(uint8_t *)buffer lenght:(NSInteger)length{
    
     printf("\n ");
     NSLog(@"**Data received, length: %d**",length);
    
    for (int i = 0 ; i < length; i++) {
        int value = buffer[i];
        printf("%d ",value);
    }
    printf("\n ");
    
    uint8_t value = buffer[0];
    
    if(value == FIRMWARE_RESPONSE){
        
        char buf[length];
        memcpy(buf, buffer+1, length-1);
        buf[length-1] = 0;
        
        NSString * firmwareName = [NSString stringWithUTF8String:buf];
        
        [self.delegate gmpController:self didReceiveFirmwareName:firmwareName];
        
    } else if(value == CAPABILITY_RESPONSE){
        
        pin_t currentPin;
        numPins = 0;
        
        for(int i = 1 ; i < length ; i+=3){
            
            currentPin.index = buffer[i];
            currentPin.capability = buffer[i+1];
            
            pins[numPins++] = currentPin;
        }
        
        /*
        NSLog(@"capabilities!");
        for (int i = 0 ; i < numPins; i++) {
            NSLog(@"pin: %d %d",pins[i].index,pins[i].mode);
        }*/
        
    } else if(value == I2C_READ){
        /*
        for(int i = 1 ; i < length ; i++){
            uint8_t val = buffer[i];
            NSLog(@"received i2c value: %d",val);
        }*/
        
        uint8_t buf[length-1];
        memcpy(buf, buffer+1, length-1);
        
        [self.delegate gmpController:self didReceiveI2CReply:buf length:length-1];
        
    }
}

@end
