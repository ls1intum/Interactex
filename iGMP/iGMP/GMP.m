//
//  IFFirmataController.m
//  BLEFirmata
//
//  Created by Juan Haladjian on 8/9/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "GMP.h"
#import "GMPCommunicationModule.h"

#define START_SYSEX             0xF0
#define END_SYSEX               0xF7
#define PIN_MODE_QUERY          0x72
#define PIN_MODE_RESPONSE       0x73
#define PIN_STATE_QUERY         0x6D
#define PIN_STATE_RESPONSE      0x6E
#define CAPABILITY_QUERY        0x6B
#define CAPABILITY_RESPONSE     0x6C
#define ANALOG_MAPPING_QUERY    0x69
#define ANALOG_MAPPING_RESPONSE 0x6A
#define REPORT_FIRMWARE         0x79
#define I2C_CONFIG              0x78
#define I2C_REQUEST             0x76
#define I2C_REPLY               0x77
#define I2C_READ_CONTINUOUSLY   0b00010000
#define I2C_WRITE               0b00000000
#define I2C_READ                0b00001000
#define I2C_STOP_READING        0b00011000
#define SYSTEM_RESET            0xFF

@implementation GMP

#pragma mark - Send Messages

-(void) reset{
    parseCommandLength = 0;
    parseCount = 0;
    
    for (int i = 0; i < IFParseBufSize; i++) {
        parseBuf[i] = 0;
    }
    
    waitingForFirmware = NO;
}

-(void) sendFirmwareRequest{
    
    uint8_t buf[3];
    buf[0] = START_SYSEX;
    buf[1] = REPORT_FIRMWARE;
    buf[2] = END_SYSEX;
    
    [self.communicationModule sendData:buf count:3];
}

/*
-(void) sendCapabilitiesAndReportRequest{
    NSInteger len = 0;
    
    uint8_t buf[16];
    
    buf[len++] = START_SYSEX;
    buf[len++] = ANALOG_MAPPING_QUERY;
    buf[len++] = END_SYSEX;
    buf[len++] = START_SYSEX;
    buf[len++] = CAPABILITY_QUERY;
    buf[len++] = END_SYSEX;
    
    for (int i=0; i<3; i++) {
        buf[len++] = 0xD0 | i;
        buf[len++] = 1;
    }
    
    [self.communicationModule sendData:buf count:16];
    //    [self.bleService sendData:buf count:16];
}

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

-(void) sendResetRequest{
    
    uint8_t msg = SYSTEM_RESET;
    
    [self.communicationModule sendData:&msg count:1];
    //    [self.bleService sendData:&msg count:1];
}

-(void) sendPinModeForPin:(NSInteger) pin mode:(IFPinMode) mode {
    
	if (pin >= 0 && pin < 128){
        
		uint8_t buf[3];
        
		buf[0] = 0xF4;
		buf[1] = pin;
		buf[2] = mode;
        
        [self.communicationModule sendData:buf count:3];
        //[self.bleService sendData:buf count:3];
    }
}

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

-(void) sendI2CStartReadingAddress:(NSInteger) address reg:(NSInteger) reg size:(NSInteger) size{
    
    [self checkStartI2C];
    
    uint8_t buf[9];
    buf[0] = START_SYSEX;
    buf[1] = I2C_REQUEST;
    buf[2] = address;//compass address = 24
    buf[3] = I2C_READ_CONTINUOUSLY;
    buf[4] = reg;//compass register = 40
    buf[5] = 1;
    buf[6] = size;//6 bytes to read
    buf[7] = 0;
    buf[8] = END_SYSEX;
    
    [self.communicationModule sendData:buf count:9];
    //[self.communicationModule sendData:buf count:9];
}

-(void) sendI2CStopReadingAddress:(NSInteger) address{
    
    uint8_t buf[5];
    buf[0] = START_SYSEX;
    buf[1] = I2C_REQUEST;
    buf[2] = address;
    buf[3] = I2C_STOP_READING;
    buf[4] = END_SYSEX;
    
    [self.communicationModule sendData:buf count:5];
    //[self.communicationModule sendData:buf count:5];
}

-(void) sendI2CWriteValue:(NSInteger) value toAddress:(NSInteger) address reg:(NSInteger) reg {
    
    [self checkStartI2C];
    
    uint8_t buf[9];
    buf[0] = START_SYSEX;
    buf[1] = I2C_REQUEST;
    buf[2] = address;//compass address = 24
    buf[3] = I2C_WRITE;
    buf[4] = reg;//compass register = 40
    buf[5] = 0;
    buf[6] = value;
    buf[7] = 0;
    buf[8] = END_SYSEX;
    
    [self.communicationModule sendData:buf count:9];
    //[self.communicationModule sendData:buf count:9];
}

-(void) checkStartI2C{
    
    if(!self.startedI2C){
        _startedI2C = YES;
        [self sendI2CConfigMessage];
    }
}

-(void) sendI2CConfigMessage{
    
    uint8_t buf[5];
    buf[0] = START_SYSEX;
    buf[1] = I2C_CONFIG;
    buf[2] = 0;
    buf[3] = 0;
    buf[4] = END_SYSEX;
    
    [self.communicationModule sendData:buf count:5];
    //[self.communicationModule sendData:buf count:5];
}

#pragma mark - Receive Messages

 
-(void) handleMessage{
    
	uint8_t cmd = (parseBuf[0] & START_SYSEX);
    
	if (cmd == 0xE0 && parseCount == 3) {
        
        int channel = (parseBuf[0] & 0x0F);
        int value = parseBuf[1] | (parseBuf[2] << 7);
        
        if([self.delegate respondsToSelector:@selector(firmataController:didReceiveAnalogMessageOnChannel:value:)]){
            [self.delegate firmataController:self didReceiveAnalogMessageOnChannel:channel value:value];
        }
        
	} else if (cmd == 0x90 && parseCount == 3) {
        
        int portNum = (parseBuf[0] & 0x0F);
        int portVal = parseBuf[1] | (parseBuf[2] << 7);
        int port = portNum * 8;
        
        if([self.delegate respondsToSelector:@selector(firmataController:didReceiveDigitalMessageForPort:value:)]){
            [self.delegate firmataController:self didReceiveDigitalMessageForPort:port value:portVal];
        }
        
	} else if (parseBuf[0] == START_SYSEX && parseBuf[parseCount-1] == END_SYSEX) {
        
		if (parseBuf[1] == REPORT_FIRMWARE) {
            
            if([self.delegate respondsToSelector:@selector(firmataController:didReceiveFirmwareReport:length:)]){
                [self.delegate firmataController:self didReceiveFirmwareReport:parseBuf length:parseCommandLength];
            }
            
		} else if (parseBuf[1] == CAPABILITY_RESPONSE) {
            
            if([self.delegate respondsToSelector:@selector(firmataController:didReceiveCapabilityResponse:length:)]){
                [self.delegate firmataController:self didReceiveCapabilityResponse:parseBuf length:parseCommandLength];
            }
            
		} else if (parseBuf[1] == ANALOG_MAPPING_RESPONSE) {
            
            if([self.delegate respondsToSelector:@selector(firmataController:didReceiveAnalogMappingResponse:length::length:)]){
                [self.delegate firmataController:self didReceiveAnalogMappingResponse:parseBuf length:parseCommandLength];
            }
            
		} else if (parseBuf[1] == PIN_STATE_RESPONSE && parseCount >= 6) {
            
            if([self.delegate respondsToSelector:@selector(firmataController:didReceivePinStateResponse:length:)]){
                [self.delegate firmataController:self didReceivePinStateResponse:parseBuf length:parseCommandLength];
            }
            
		} else if(parseBuf[1] == I2C_REPLY){
            
            if([self.delegate respondsToSelector:@selector(firmataController:didReceiveI2CReply:length:)]){
                [self.delegate firmataController:self didReceiveI2CReply:parseBuf length:parseCommandLength];
            }
        }
	}
}*/

-(void) didReceiveData:(uint8_t *)buffer lenght:(NSInteger)originalLength{
    
    NSInteger length = originalLength;
    
    //remove all END_SYSEX messages at the end of the buffer
    for (int i = 15; i >= 0; i--) {
        if(buffer[i] != END_SYSEX){
            break;
        }
        length --;
    }
    
    //check if we had started a sysex somewhere
    for (int i = 0; i < length; i++) {
        if(buffer[i] == START_SYSEX){
            startedSysex = YES;
        } else if (buffer[i] == END_SYSEX ){
            startedSysex = NO;
        }
    }
    
    //restore the wrongly removed sysex at the end
    if(length < originalLength && startedSysex){
        buffer[length++] = END_SYSEX;
        startedSysex = NO;
    }
    
    /*
     printf("\n ");
     NSLog(@"**Data received, length: %d**",length);
     
     for (int i = 0 ; i < length; i++) {
     int value = buffer[i];
     printf("%d ",value);
     }
     printf("\n ");*/
    
    
    for (int i = 0 ; i < length; i++) {
        uint8_t value = buffer[i];
        
	}
}

@end
