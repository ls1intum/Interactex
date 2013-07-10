//
//  IFFirmata.m
//  iFirmata
//
//  Created by Juan Haladjian on 6/28/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "IFFirmataController.h"
#import "IFPin.h"
#import "BLEService.h"
#import "BLEHelper.h"

#define START_SYSEX             0xF0 // start a MIDI Sysex message
#define END_SYSEX               0xF7 // end a MIDI Sysex message
#define PIN_MODE_QUERY          0x72 // ask for current and supported pin modes
#define PIN_MODE_RESPONSE       0x73 // reply with current and supported pin modes
#define PIN_STATE_QUERY         0x6D
#define PIN_STATE_RESPONSE      0x6E
#define CAPABILITY_QUERY        0x6B
#define CAPABILITY_RESPONSE     0x6C
#define ANALOG_MAPPING_QUERY    0x69
#define ANALOG_MAPPING_RESPONSE 0x6A
#define REPORT_FIRMWARE         0x79 // report name and version of the firmware

@implementation IFFirmataController

-(id) init{
    self = [super init];
    if(self){
        [self loadPins];
        
    }
    return self;
}

-(void) loadPins{
    self.digitalPins = [NSMutableArray arrayWithCapacity:IFNumDigitalPins];
    for (int i = 0; i <= IFNumDigitalPins ; i++) {
        
        IFPin * pin = [IFPin pinWithNumber:i type:IFPinTypeDigital mode:IFPinModeInput];
        pin.delegate = self;
        [self.digitalPins addObject:pin];
    }
    
    for (int i = 0; i <= IFNumAnalogPins ; i++) {
        IFPin * pin = [IFPin pinWithNumber:i type:IFPinTypeAnalog mode:IFPinModeAnalog];
        pin.delegate = self;
        [self.analogPins addObject:pin];
    }
}

-(void) start{
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(processInput) userInfo:nil repeats:YES];
    
    [self sendFirmwareRequest];
}

-(void) stop{
    [timer invalidate];
    timer = nil;
}

-(void) sendPwmOutputForPin:(IFPin*) pin{


	if (pin.number <= 15 && pin.value <= 16383) {
		uint8_t buf[3];
		buf[0] = 0xE0 | pin.number;
		buf[1] = pin.value & 0x7F;
		buf[2] = (pin.value >> 7) & 0x7F;
        
        NSData * data = [NSData dataWithBytes:buf length:3];
        [self.bleService writeToTx:data];
        NSLog(@"sending: %d %d %d",buf[0],buf[1],buf[2]);
        
	} else {
		uint8_t buf[12];
		int len=4;
		buf[0] = 0xF0;
		buf[1] = 0x6F;
		buf[2] = pin.number;
		buf[3] = pin.value & 0x7F;
		if (pin.value > 0x00000080) buf[len++] = (pin.value >> 7) & 0x7F;
		if (pin.value > 0x00004000) buf[len++] = (pin.value >> 14) & 0x7F;
		if (pin.value > 0x00200000) buf[len++] = (pin.value >> 21) & 0x7F;
		if (pin.value > 0x10000000) buf[len++] = (pin.value >> 28) & 0x7F;
		buf[len++] = 0xF7;
        
        NSData * data = [NSData dataWithBytes:buf length:3];
        [self.bleService writeToTx:data];
        NSLog(@"sending: %d %d %d",buf[0],buf[1],buf[2]);
	}
}

-(void) sendOutputForPin:(IFPin*) pin{
    if(pin.mode == IFPinModeOutput){
        
        int port = pin.number / 8;
        int value = 0;
        for (int i=0; i<8; i++) {
            int pinIdx = port * 8 + i;
            IFPin * pin = [self.digitalPins objectAtIndex:pinIdx];
            if (pin.mode == IFPinModeInput || pin.mode == IFPinModeOutput) {
                if (pin.value) {
                    value |= (1<<i);
                }
            }
        }
        uint8_t buf[3];
        buf[0] = 0x90 | port;        
        buf[1] = value & 0x7F;
        buf[2] = (value >> 7) & 0x7F;
        
        NSData * data = [NSData dataWithBytes:buf length:3];
        [self.bleService writeToTx:data];
        
        NSLog(@"sending: %d %d %d",buf[0],buf[1],buf[2]);
        
    } else if(pin.mode == IFPinModePWM){
        [self sendPwmOutputForPin:pin];
    }
}

-(void) sendPinModeForPin:(IFPin*) pin {
    //[self sendFirmwareRequest];
    
	if (pin.number >= 0 && pin.number < 128){
        
		uint8_t buf[3];
        
		buf[0] = 0xF4;
		buf[1] = pin.number;
		buf[2] = pin.mode;
        
        NSData * data = [NSData dataWithBytes:buf length:3];
        [self.bleService writeToTx:data];
        
        NSLog(@"sending: %d %d %d",buf[0],buf[1],buf[2]);
    }
    //port.Write(buf, 3);
    //		tx_count += 3;
}

-(void) sendFirmwareRequest{
    uint8_t buf[3];
    buf[0] = START_SYSEX;
    buf[1] = REPORT_FIRMWARE; // read firmata name & version
    buf[2] = END_SYSEX;
    
    NSData * data = [NSData dataWithBytes:buf length:3];
    [self.bleService writeToTx:data];
    
    NSLog(@"sending: %d %d %d",buf[0],buf[1],buf[2]);
    
   // tx_count += 3;
}

-(void) handleMessage{
    
	uint8_t cmd = (parse_buf[0] & 0xF0);
    
	//printf("message, %d bytes, %02X\n", parse_count, parse_buf[0]);
    
	if (cmd == 0xE0 && parse_count == 3) {
        NSLog(@"Handles Analog message");
        
		int analog_ch = (parse_buf[0] & 0x0F);
		int analog_val = parse_buf[1] | (parse_buf[2] << 7);
        for (IFPin * pin in self.analogPins) {
			if (pin.analogChannel == analog_ch) {
				pin.value = analog_val;
                NSLog(@"A%d: %d", analog_ch, analog_val);
				return;
			}
		}
		return;
	}
    
	if (cmd == 0x90 && parse_count == 3) {
        
        
		int port_num = (parse_buf[0] & 0x0F);
		int port_val = parse_buf[1] | (parse_buf[2] << 7);
		int pin = port_num * 8;
        
        NSLog(@"digital message for port: %d %d",port_num,port_val);
        
		//printf("port_num = %d, port_val = %d\n", port_num, port_val);
		for (int mask=1; pin < self.digitalPins.count; mask <<= 1, pin++) {
            IFPin * pinObj = [self.digitalPins objectAtIndex:pin];
			if (pinObj.mode == IFPinModeInput) {
				uint32_t val = (port_val & mask) ? 1 : 0;
				if (pinObj.value != val) {
					NSLog(@"pin %d is %d", pin, val);
					pinObj.value = val;
				}
			}
		}
		return;
	}
    
    
	if (parse_buf[0] == START_SYSEX && parse_buf[parse_count-1] == END_SYSEX) {
        NSLog(@"Handles Syssex");
        
		// Sysex message
		if (parse_buf[1] == REPORT_FIRMWARE) {
            
            NSLog(@"Handles Firmware");
            
			char name[140];
			int len=0;
			for (int i=4; i < parse_count-2; i+=2) {
				name[len++] = (parse_buf[i] & 0x7F)
                | ((parse_buf[i+1] & 0x7F) << 7);
			}
			name[len++] = '-';
			name[len++] = parse_buf[2] + '0';
			name[len++] = '.';
			name[len++] = parse_buf[3] + '0';
			name[len++] = 0;
			//firmata_name = name;
			// query the board's capabilities only after hearing the
			// REPORT_FIRMWARE message.  For boards that reset when
			// the port open (eg, Arduino with reset=DTR), they are
			// not ready to communicate for some time, so the only
			// way to reliably query their capabilities is to wait
			// until the REPORT_FIRMWARE message is heard.
			uint8_t buf[80];
			len=0;
			buf[len++] = START_SYSEX;
			buf[len++] = ANALOG_MAPPING_QUERY; // read analog to pin # info
			buf[len++] = END_SYSEX;
			buf[len++] = START_SYSEX;
			buf[len++] = CAPABILITY_QUERY; // read capabilities
			buf[len++] = END_SYSEX;
			for (int i=0; i<16; i++) {
				buf[len++] = 0xC0 | i;  // report analog
				buf[len++] = 1;
				buf[len++] = 0xD0 | i;  // report digital
				buf[len++] = 1;
			}
            /*
            NSData * data = [NSData dataWithBytes:buf length:len];
            [self.bleService writeToTx:data];*/

			//tx_count += len;
		} else if (parse_buf[1] == CAPABILITY_RESPONSE) {
            NSLog(@"Handles CapabilityResponse");
            
			int pin, i, n;
            for (IFPin * pin in self.digitalPins) {
				pin.supportedModes = 0;
			}
			for (i=2, n=0, pin=0; i<parse_count; i++) {
				if (parse_buf[i] == 127) {
					pin++;
					n = 0;
					continue;
				}
				if (n == 0) {
					// first byte is supported mode
                    IFPin * pinObj = [self.digitalPins objectAtIndex:pin];
					pinObj.supportedModes |= (1<<parse_buf[i]);
				}
				n = n ^ 1;
			}
			// send a state query for for every pin with any modes
			for (pin=0; pin < 128; pin++) {
                
                IFPin * pinObj = [self.digitalPins objectAtIndex:pin];
                
				uint8_t buf[512];
				int len=0;
				if (pinObj.supportedModes) {
					buf[len++] = START_SYSEX;
					buf[len++] = PIN_STATE_QUERY;
					buf[len++] = pin;
					buf[len++] = END_SYSEX;
				}
                
                NSData * data = [NSData dataWithBytes:buf length:len];
                [self.bleService writeToTx:data];
                
				//tx_count += len;
			}
		} else if (parse_buf[1] == ANALOG_MAPPING_RESPONSE) {
            NSLog(@"Handles AnalogMapping");
            
			int pin=0;
			for (int i=2; i<parse_count-1; i++) {
                IFPin * pinObj = [self.digitalPins objectAtIndex:pin];
				pinObj.analogChannel = parse_buf[i];
				pin++;
			}
			return;
		} else if (parse_buf[1] == PIN_STATE_RESPONSE && parse_count >= 6) {
            
            NSLog(@"Handles PinStateReponse");
            
			int pin = parse_buf[2];
            
            IFPin * pinObj = [self.digitalPins objectAtIndex:pin];
			pinObj.mode = parse_buf[3];
			pinObj.value = parse_buf[4];
			if (parse_count > 6) pinObj.value |= (parse_buf[5] << 7);
			if (parse_count > 7) pinObj.value |= (parse_buf[6] << 14);
			//add_pin(pin);
		}
		return;
	}
}

-(void) dataReceived:(Byte *)buffer lenght:(NSInteger)length{
    
    //NSLog(@"**Data received, length: %d**",length);
    
	//for (p = buffer; p < end; p++) {
    for (int i = 0 ; i < length; i++) {
        short value = buffer[i];
        
        NSLog(@"%d",value);
        
		uint8_t msn = value & 0xF0;
		if (msn == 0xE0 || msn == 0x90 || value == 0xF9) {
			parse_command_len = 3;
			parse_count = 0;
		} else if (msn == 0xC0 || msn == 0xD0) {
			parse_command_len = 2;
			parse_count = 0;
		} else if (value == START_SYSEX) {
			parse_count = 0;
			parse_command_len = sizeof(parse_buf);
		} else if (value == END_SYSEX) {
			parse_command_len = parse_count + 1;
		} else if (value & 0x80) {
			parse_command_len = 1;
			parse_count = 0;
		}
		if (parse_count < (int)sizeof(parse_buf)) {
			parse_buf[parse_count++] = value;
		}
		if (parse_count == parse_command_len) {
			[self handleMessage];
			parse_count = parse_command_len = 0;
		}
	}
}

-(void) reportMessage:(NSString*) message{
    NSLog(@"%@",message);
}

-(void) processInput{
    /*
    NSInteger length = self.bleService.rxCount;
    
    if(length > 0){
        NSData * data = self.bleService.rxCharacteristic.value;
        [self.bleService clearRx];
        [self dataReceived:(Byte*)data.bytes lenght:data.length];
	}*/
}

#pragma mark -- Pin Delegate

-(void) pin:(IFPin*) pin changedMode:(IFPinMode) newMode{
    [self sendPinModeForPin:pin];
}

-(void) pin:(IFPin*) pin changedValue:(NSInteger) newValue{
    [self sendOutputForPin:pin];
}

@end
