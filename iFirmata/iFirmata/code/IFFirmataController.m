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
        //[self loadPins];
        
        
    }
    return self;
}

-(void) start{

    self.digitalPins = [NSMutableArray array];
    self.analogPins = [NSMutableArray array];
    
    for (int i=0; i < 128; i++) {
        //pin_info[i].mode = 255;
        //pin_info[i].analog_channel = 127;
        pinInfo[i].supportedModes = 0;
        //pin_info[i].value = 0;
    }
    
    [self.delegate didUpdatePins];
    
    [self sendFirmwareRequest];
}

-(void) stop{
    
    for (IFPin * pin in self.digitalPins) {
        
        [pin removeObserver:self forKeyPath:@"mode"];
        [pin removeObserver:self forKeyPath:@"value"];
    }
    
    for (IFPin * pin in self.analogPins) {
        
        [pin removeObserver:self forKeyPath:@"mode"];
        [pin removeObserver:self forKeyPath:@"value"];
        [pin removeObserver:self forKeyPath:@"updatesValues"];
    }
    
    [self.digitalPins removeAllObjects];
    [self.analogPins removeAllObjects];
    
    
    [self.delegate didUpdatePins];
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

-(void) sendDigitalOutputForPin:(IFPin*) pin{
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
}

-(void) sendOutputForPin:(IFPin*) pin{
    if(pin.mode == IFPinModeOutput){
        
        [self sendDigitalOutputForPin:pin];
        
    } else if(pin.mode == IFPinModePWM){
        [self sendPwmOutputForPin:pin];
    }
}

-(void) sendPinModeForPin:(IFPin*) pin {
    
	if (pin.number >= 0 && pin.number < 128){
        
		uint8_t buf[3];
        
		buf[0] = 0xF4;
		buf[1] = pin.number;
		buf[2] = pin.mode;
        
        NSData * data = [NSData dataWithBytes:buf length:3];
        [self.bleService writeToTx:data];
        
        NSLog(@"sending: %d %d %d",buf[0],buf[1],buf[2]);
    }
}

-(void) sendReportRequestForAnalogPin:(IFPin*) pin{
    
    uint8_t buf[2];
    buf[0] = 0xC0 | pin.number;  // report analog
    buf[1] = 1;
    
    NSData * data = [NSData dataWithBytes:buf length:2];
    [self.bleService writeToTx:data];    
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

-(void) sendCapabilitiesAndReportRequest{
    NSInteger len = 0;
    
    uint8_t buf1[6];
    uint8_t buf2[64];
    
    buf1[len++] = START_SYSEX;
    buf1[len++] = ANALOG_MAPPING_QUERY; // read analog to pin # info
    buf1[len++] = END_SYSEX;
    buf1[len++] = START_SYSEX;
    buf1[len++] = CAPABILITY_QUERY; // read capabilities
    buf1[len++] = END_SYSEX;
    
    NSData * data = [NSData dataWithBytes:buf1 length:len];
    [self.bleService writeToTx:data];
    
    //report every digital
    len = 0;
    for(int i = 0; i < 3;i++){
        buf2[len++] = 0xD0 | i;
        buf2[len++] = 1;
    }
    
    data = [NSData dataWithBytes:buf2 length:len];
    [self.bleService writeToTx:data];
    
    /*
     len = 0;
     for (int i=0; i<16; i++) {
     buf2[len++] = 0xC0 | i;  // report analog
     buf2[len++] = 1;
     buf2[len++] = 0xD0 | i;  // report digital
     buf2[len++] = 1;
     
     if(i > 0 && (i % 4) == 0){
     NSData * data2 = [NSData dataWithBytes:buf2 length:len];
     [self.bleService writeToTx:data2];
     len = 0;
     }
     }*/

}
-(void) createAnalogPins{
    //create the analog pins
    for (int pin=0; pin < self.numPins; pin++) {
        //NSLog(@"%d - %lld ",pin, pinInfo[pin].supportedModes);
        
        if(pinInfo[pin].supportedModes & (1<<IFPinModeAnalog)){
                        
            //NSLog(@"is analog");
            _numAnalogPins++;
        }
    }
    _numDigitalPins = self.numPins - _numAnalogPins;
    
    for (int i = 0; i < self.numAnalogPins; i++) {
                
        IFPin * pin = [IFPin pinWithNumber:i type:IFPinTypeAnalog mode:IFPinModeAnalog];
        pin.analogChannel = pinInfo[i+self.numDigitalPins].analogChannel;
        [self.analogPins addObject:pin];
        
        NSLog(@"%d analog with channel: %d",pin.number,pin.analogChannel);
        
        int value = parse_buf[4];
        if (parse_count > 6) value |= (parse_buf[5] << 7);
        if (parse_count > 7) value |= (parse_buf[6] << 14);
        pin.value = value;
        
        [pin addObserver:self forKeyPath:@"mode" options:NSKeyValueObservingOptionNew context:nil];
        [pin addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
        [pin addObserver:self forKeyPath:@"updatesValues" options:NSKeyValueObservingOptionNew context:nil];
        
        [self.delegate didUpdatePins];
    }
    
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
        
        //NSLog(@"digital message for port: %d %d",port_num,port_val);
        
		//printf("port_num = %d, port_val = %d\n", port_num, port_val);
		for (int mask=1; pin < self.digitalPins.count; mask <<= 1, pin++) {
            IFPin * pinObj = [self.digitalPins objectAtIndex:pin];
			if (pinObj.mode == IFPinModeInput) {
				uint32_t val = (port_val & mask) ? 1 : 0;
				if (pinObj.value != val) {
					//NSLog(@"pin %d is %d", pin, val);
					pinObj.value = val;
				}
			}
		}
		return;
	}
    
	if (parse_buf[0] == START_SYSEX && parse_buf[parse_count-1] == END_SYSEX) {
        
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
            NSString * nameStr = [NSString stringWithUTF8String:name];
            NSLog(@"%@",nameStr);
            
			// query the board's capabilities only after hearing the
			// REPORT_FIRMWARE message.  For boards that reset when
			// the port open (eg, Arduino with reset=DTR), they are
			// not ready to communicate for some time, so the only
			// way to reliably query their capabilities is to wait
			// until the REPORT_FIRMWARE message is heard.
			
            [self sendCapabilitiesAndReportRequest];

			//tx_count += len;
		} else if (parse_buf[1] == CAPABILITY_RESPONSE) {
            NSLog(@"Handles CapabilityResponse");
            
			for (int pin=0; pin < 128; pin++) {
				pinInfo[pin].supportedModes = 0;
			}
            
			for (int i=2, n=0, pin=0; i<parse_count; i++) {
				if (parse_buf[i] == 127) {
					pin++;
					n = 0;
					continue;
				}
				if (n == 0) {
					pinInfo[pin].supportedModes |= (1<<parse_buf[i]);
				}
				n = n ^ 1;
			}
            
            _numPins = 0;
            for (int pin=0; pin < 128; pin++) {
				if(pinInfo[pin].supportedModes){
                    _numPins++;
                }
			}
            
            NSLog(@"NumPins: %d",self.numPins);
            
            [self createAnalogPins];
            
            
			// send a state query for every pin with any modes
            int len = 0;
            
            for (int pin=0; pin < self.numPins; pin++) {

				uint8_t buf[16];
                buf[len++] = START_SYSEX;
                buf[len++] = PIN_STATE_QUERY;
                buf[len++] = pin;
                buf[len++] = END_SYSEX;
                
                if(len == 16){
                    NSData * data = [NSData dataWithBytes:buf length:len];
                    [self.bleService writeToTx:data];
                    len = 0;
                }
			}
		} else if (parse_buf[1] == ANALOG_MAPPING_RESPONSE) {
            NSLog(@"Handles AnalogMapping");
                        
			int pin=0;
			for (int i=2; i<parse_count-1; i++) {
                
                pinInfo[pin].analogChannel = parse_buf[i];
                pin++;
			}
		} else if (parse_buf[1] == PIN_STATE_RESPONSE && parse_count >= 6) {
            
			int pinNumber = parse_buf[2];
			int mode = parse_buf[3];
            
            //NSLog(@"Handles PinStateResponse %d %d",pinNumber,mode);
            
            IFPin * pin = [IFPin pinWithNumber:pinNumber type:IFPinTypeDigital mode:mode];
            [self.digitalPins addObject:pin];
            
			int value = parse_buf[4];
			if (parse_count > 6) value |= (parse_buf[5] << 7);
			if (parse_count > 7) value |= (parse_buf[6] << 14);
            pin.value = value;
            
            [pin addObserver:self forKeyPath:@"mode" options:NSKeyValueObservingOptionNew context:nil];
            [pin addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
            
            [self.delegate didUpdatePins];
            
			//add_pin(pin);
		}
	}
}

-(void) dataReceived:(Byte *)buffer lenght:(NSInteger)originalLength{
    
    NSInteger length = originalLength;
    
    //cut all END_SYSEX messages at the end of the buffer
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
    /*
    printf("in systex: %d before \n",startedSysex);
    for (int i = 0 ; i < length; i++) {
        int value = buffer[i];
        printf("%d ",value);
    }
    printf("\n ");*/
    
    //if it had started but we removed the endSysex from the buffer, close it
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
        short value = buffer[i];
        
		uint8_t msn = value & 0xF0;
		if (msn == 0xE0 || msn == 0x90 || value == 0xF9) {//digital / analog pin, or protocol version
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
    //printf("\n ");
}

-(void) reportMessage:(NSString*) message{
    NSLog(@"%@",message);
}

#pragma mark -- Pin Delegate

- (void)observeValueForKeyPath:(NSString *)keyPath  ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqual:@"mode"]) {
        [self sendPinModeForPin:object];
    } else if([keyPath isEqual:@"value"]){
        [self sendOutputForPin:object];
    }else if([keyPath isEqual:@"updatesValues"]){
        [self sendReportRequestForAnalogPin:object];
    }
}

-(void) dealloc{
    
    [self stop];
}

@end
