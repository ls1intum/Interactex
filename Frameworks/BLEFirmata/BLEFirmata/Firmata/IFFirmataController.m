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
#import "IFI2CComponent.h"
#import "IFI2CRegister.h"

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

@implementation IFFirmataController

-(id) init{
    self = [super init];
    if(self){
        
        self.i2cComponents = [NSMutableArray array];
    }
    return self;
}

-(void) start{
    
    NSAssert(self.bleService, @"to start Firmata the bleService property should be set");
    
    self.digitalPins = [NSMutableArray array];
    self.analogPins = [NSMutableArray array];
    
    parse_count = 0;
    
    for (int i=0; i < 128; i++) {
        parse_buf[i] = 0;
    }
    
    for (int i=0; i < 128; i++) {
        pinInfo[i].analogChannel = 127;
        pinInfo[i].supportedModes = 0;
    }
    
    //[self.delegate firmataDidUpdateDigitalPins:self];
    
    NSAssert(self.digitalPins.count == 0,@"sending firmware request but there are digital pins");
    NSAssert(self.analogPins.count == 0,@"sending firmware request but there are digital pins");
    
    waitingForFirmware = YES;
    [self sendFirmwareRequest];
     
}

-(void) stop{
    waitingForFirmware = NO;
    
    for (IFPin * pin in self.digitalPins) {
        [pin removeObserver:self forKeyPath:@"mode"];
        [pin removeObserver:self forKeyPath:@"value"];
    }
    
    for (IFPin * pin in self.analogPins) {
        [pin removeObserver:self forKeyPath:@"mode"];
        [pin removeObserver:self forKeyPath:@"value"];
        [pin removeObserver:self forKeyPath:@"updatesValues"];
    }
    /*
    for (IFI2CComponent * component in self.i2cComponents) {
        [component removeObserver:self forKeyPath:@"notifies"];
    }*/
    
    [self.digitalPins removeAllObjects];
    [self.analogPins removeAllObjects];
    
    [self.delegate firmataDidUpdateDigitalPins:self];
    [self.delegate firmataDidUpdateAnalogPins:self];
    
    _numDigitalPins = 0;
    _numAnalogPins = 0;
    _numPins = 0;
    
    self.firmataName = @"iFirmata";
}

#pragma mark - Reset

-(void) sendResetRequest{
    uint8_t msg = SYSTEM_RESET;
    
    [self.bleService sendData:&msg count:1];
}

#pragma mark I2C requests

-(void) sendI2CStartStopReportingRequestForRegister:(IFI2CRegister*) reg fromComponent:(IFI2CComponent*) component{
    
    if(reg.notifies){
        [self sendI2CStartReadingForRegister:reg fromComponent:component];
    } else {
        [self sendI2CStopReadingComponent:component];
    }
}

-(void) sendI2CStartReadingForRegister:(IFI2CRegister*) reg fromComponent:(IFI2CComponent*) component{
    
    [self checkStartI2C];
    
    uint8_t buf[9];
    buf[0] = START_SYSEX;
    buf[1] = I2C_REQUEST;
    buf[2] = component.address;//compass address = 24
    buf[3] = I2C_READ_CONTINUOUSLY;
    buf[4] = reg.number;//compass register = 40
    buf[5] = 1;
    buf[6] = reg.size;//6 bytes to read
    buf[7] = 0;
    buf[8] = END_SYSEX;
    
    [self.bleService sendData:buf count:9];
}

-(void) sendI2CStopReadingAddress:(NSInteger) address{
    uint8_t buf[5];
    buf[0] = START_SYSEX;
    buf[1] = I2C_REQUEST;
    buf[2] = address;
    buf[3] = I2C_STOP_READING;
    buf[4] = END_SYSEX;
    
    [self.bleService sendData:buf count:5];
}

-(void) sendI2CStopReadingComponent:(IFI2CComponent*) component{
    [self sendI2CStopReadingAddress:component.address];
}

-(void) sendI2CWriteData:(NSString*) data forRegister:(IFI2CRegister*) reg fromComponent:(IFI2CComponent*) component{
    
    [self checkStartI2C];
    
    uint8_t buf[9];
    buf[0] = START_SYSEX;
    buf[1] = I2C_REQUEST;
    buf[2] = component.address;//compass address = 24
    buf[3] = I2C_WRITE;
    buf[4] = reg.number;//compass register = 40
    buf[5] = 0;
    buf[6] = data.integerValue;
    buf[7] = 0;
    buf[8] = END_SYSEX;
    
    [self.bleService sendData:buf count:9];
}

-(void) checkStartI2C{
    if(!startedI2C){
        startedI2C = YES;
        [self sendI2CConfig];
    }
}

-(void) sendI2CConfig{
    uint8_t buf[5];
    buf[0] = START_SYSEX;
    buf[1] = I2C_CONFIG;
    buf[2] = 0;
    buf[3] = 0;
    buf[4] = END_SYSEX;
    
    [self.bleService sendData:buf count:5];
}

-(void) stopReportingI2CComponent:(IFI2CComponent*) component{
    [self sendStopReportingMessageForI2CComponent:component];
    
    for (IFI2CRegister * reg in component.registers) {
        if(reg.notifies){
            [reg removeObserver:self forKeyPath:@"notifies"];
            reg.notifies = NO;
            [reg addObserver:self forKeyPath:@"notifies" options:NSKeyValueObservingOptionNew context:nil];
        }
    }
}

-(void) sendStopReportingMessageForI2CComponent:(IFI2CComponent*) component{
    for (IFI2CRegister * reg in component.registers) {
        if(reg.notifies){
            [self sendI2CStopReadingComponent:component];
        }
    }
}

-(void) stopReportingI2CComponents{
    for (IFI2CComponent * component in self.i2cComponents) {
        [self stopReportingI2CComponent:component];
    }
}

#pragma mark PWM request

-(void) sendPwmOutputForPin:(IFPin*) pin{

	if (pin.number <= 15 && pin.value <= 16383) {
		uint8_t buf[3];
		buf[0] = 0xE0 | pin.number;
		buf[1] = pin.value & 0x7F;
		buf[2] = (pin.value >> 7) & 0x7F;
        
        [self.bleService sendData:buf count:3];
        
	}
    
    //some day we will support extended analog
    /*else {
		uint8_t buf[9];
		int len=4;
		buf[0] = START_SYSEX;
		buf[1] = 0x6F;
		buf[2] = pin.number;
		buf[3] = pin.value & 0x7F;
		if (pin.value > 0x00000080) buf[len++] = (pin.value >> 7) & 0x7F;
		if (pin.value > 0x00004000) buf[len++] = (pin.value >> 14) & 0x7F;
		if (pin.value > 0x00200000) buf[len++] = (pin.value >> 21) & 0x7F;
		if (pin.value > 0x10000000) buf[len++] = (pin.value >> 28) & 0x7F;
		buf[len++] = 0xF7;
        
        [self.bleService sendData:buf count:9];
	}*/
}

-(void) sendServoOutputForPin{
    
}

#pragma mark Digital Output

-(void) sendDigitalOutputForPin:(IFPin*) pin{
    if(self.digitalPins.count == 0) return;
    
    IFPin * firstPin = [self.digitalPins objectAtIndex:0];
    NSInteger firstPinIdx = firstPin.number;
    
    int port = pin.number / 8;
    int value = 0;
    for (int i=0; i<8; i++) {
        int pinIdx = port * 8 + i - firstPinIdx;
        if(pinIdx >= self.digitalPins.count){
            break;
        }
        if(pinIdx >= 0){
            IFPin * pin = [self.digitalPins objectAtIndex:pinIdx];
            if (pin.mode == IFPinModeInput || pin.mode == IFPinModeOutput) {
                if (pin.value) {
                    value |= (1<<i);
                }
            }
        }
    }
    uint8_t buf[3];
    buf[0] = 0x90 | port;
    buf[1] = value & 0x7F;
    buf[2] = (value >> 7) & 0x7F;
    
    [self.bleService sendData:buf count:3];
    
    //NSLog(@"sending: %d %d %d",buf[0],buf[1],buf[2]);
}

-(void) sendOutputForPin:(IFPin*) pin{
    if(pin.mode == IFPinModeOutput){
        
        [self sendDigitalOutputForPin:pin];
        
    } else if(pin.mode == IFPinModePWM){
        [self sendPwmOutputForPin:pin];
    } else if(pin.mode == IFPinModeServo){
        [self sendPwmOutputForPin:pin];
    }
}

-(void) sendPinModeForPin:(IFPin*) pin {
    
	if (pin.number >= 0 && pin.number < 128){
        
		uint8_t buf[3];
        
		buf[0] = 0xF4;
		buf[1] = pin.number;
		buf[2] = pin.mode;
        
        [self.bleService sendData:buf count:3];
        
        //NSLog(@"sending: %d %d %d",buf[0],buf[1],buf[2]);
    }
}

-(void) stopReportingAnalogPins{
    for (IFPin * pin in self.analogPins) {
        pin.updatesValues = NO;
    }
}

-(void) sendReportRequestForAnalogPin:(IFPin*) pin{
    
    uint8_t buf[2];
    buf[0] = 0xC0 | pin.number;  // report analog
    buf[1] = pin.updatesValues;
    
    [self.bleService sendData:buf count:2];
    
    //NSLog(@"sending: %d %d for pin: %d",buf[0],buf[1],pin.number);
}
/*
-(void) sendTestData{
    
    uint8_t buf[16];
    //int len = 0;
    for (int i = 0; i < 16; i++) {
        
        buf[i] = i+100;
        
    }
    [self.bleService sendData:buf count:16];
}*/

-(void) sendFirmwareRequest{
    
    uint8_t buf[3];
    buf[0] = START_SYSEX;
    buf[1] = REPORT_FIRMWARE; // read firmata name & version
    buf[2] = END_SYSEX;
    
    [self.bleService sendData:buf count:3];
    
    //NSLog(@"sending firmware: %d %d %d",buf[0],buf[1],buf[2]);
}

-(void) sendCapabilitiesAndReportRequest{
    NSInteger len = 0;
    
    uint8_t buf[16];
    
    buf[len++] = START_SYSEX;
    buf[len++] = ANALOG_MAPPING_QUERY; // read analog to pin # info
    buf[len++] = END_SYSEX;
    buf[len++] = START_SYSEX;
    buf[len++] = CAPABILITY_QUERY; // read capabilities
    buf[len++] = END_SYSEX;
    
    //[self.bleService sendData:buf count:6];
    
    // report digital
    for (int i=0; i<3; i++) {
        buf[len++] = 0xD0 | i;
        buf[len++] = 1;
    }
    
    [self.bleService sendData:buf count:16];
}

-(void) createAnalogPins{
    
    int firstAnalog = self.numDigitalPins;
    for (; firstAnalog < 128; firstAnalog++) {
        if(pinInfo[firstAnalog].supportedModes & (1<<IFPinModeAnalog)){
            break;
        }
    }
    //NSLog(@"first analog at pos: %d",firstAnalog);
    for (int i = 0; i < self.numAnalogPins; i++) {
                
        IFPin * pin = [IFPin pinWithNumber:i type:IFPinTypeAnalog mode:IFPinModeAnalog];
        pin.analogChannel = pinInfo[i+firstAnalog].analogChannel;
        [self.analogPins addObject:pin];
        
        int value = parse_buf[4];
        if (parse_count > 6) value |= (parse_buf[5] << 7);
        if (parse_count > 7) value |= (parse_buf[6] << 14);
        pin.value = value;
        
        [pin addObserver:self forKeyPath:@"mode" options:NSKeyValueObservingOptionNew context:nil];
        [pin addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
        [pin addObserver:self forKeyPath:@"updatesValues" options:NSKeyValueObservingOptionNew context:nil];
        
        [self.delegate firmataDidUpdateAnalogPins:self];
    }
}
-(void) sendStateQuery{
    
    uint8_t buf[16];
    int len = 0;
    for (int pin=0; pin < 128; pin++) {
        if((pinInfo[pin].supportedModes & (1<<IFPinModeInput)) && (pinInfo[pin].supportedModes & (1<<IFPinModeOutput)) && !(pinInfo[pin].supportedModes & (1<<IFPinModeAnalog))){
            
            buf[len++] = START_SYSEX;
            buf[len++] = PIN_STATE_QUERY;
            buf[len++] = pin;
            buf[len++] = END_SYSEX;
            if(len == 16){
                [self.bleService sendData:buf count:16];
                break;
            }
        }
    }
}

-(void) makePinQueryForPin:(int) pin{
    
    for(int i = pin ; i < pin + 4; i++){
        uint8_t buf[4];
        if((pinInfo[i].supportedModes & (1<<IFPinModeInput)) && (pinInfo[i].supportedModes & (1<<IFPinModeOutput)) && !(pinInfo[i].supportedModes & (1<<IFPinModeAnalog))){
            
            buf[0] = START_SYSEX;
            buf[1] = PIN_STATE_QUERY;
            buf[2] = i;
            buf[3] = END_SYSEX;
            
            [self.bleService sendData:buf count:4];
        }
    }
}

-(void) countPins{
    _numPins = 0;
    _numAnalogPins = 0;
    
    for (int pin=0; pin < 128; pin++) {
        if(pinInfo[pin].supportedModes ){
            _numPins++;            
            
            if(pinInfo[pin].supportedModes & (1<<IFPinModeAnalog)){
                _numAnalogPins++;
            }
        }
    }
    _numDigitalPins = self.numPins - self.numAnalogPins;
    
    //NSLog(@"NumPins: %d, Digital: %d, Analog: %d",self.numPins,self.numDigitalPins,self.numAnalogPins);
}

#pragma mark - Firmata Message Handles

-(void) handleFirmwareReport{
    //NSLog(@"Handles Firmware");
    if(!waitingForFirmware){
        NSLog(@"got firmware but not waiting!");
    } else{
        waitingForFirmware = NO;
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
        _firmataName = [NSString stringWithUTF8String:name];
        [self.delegate firmata:self didUpdateTitle:self.firmataName];
        
        [self sendCapabilitiesAndReportRequest];
    }
}

-(void) handleAnalogMessage{
    //NSLog(@"Handles Analog message");
    
    int channel = (parse_buf[0] & 0x0F);
    int value = parse_buf[1] | (parse_buf[2] << 7);
    
    for (IFPin * pin in self.analogPins) {
        if (pin.analogChannel == channel) {
            pin.value = value;
            return;
        }
    }
}

-(void) handleDigitalMessage{
    int port_num = (parse_buf[0] & 0x0F);
    int port_val = parse_buf[1] | (parse_buf[2] << 7);
    int pin = port_num * 8;
    
    //NSLog(@"digital message for port: %d %d",port_num,port_val);
    IFPin * firstPin = (IFPin*) [self.digitalPins objectAtIndex:0];
    int mask = 1;
    
    for (mask <<= firstPin.number; pin < self.digitalPins.count; mask <<= 1, pin++) {
        IFPin * pinObj = [self.digitalPins objectAtIndex:pin];
        if (pinObj.mode == IFPinModeInput) {
            uint32_t val = (port_val & mask) ? 1 : 0;
            if (pinObj.value != val) {
                pinObj.value = val;
            }
        }
    }
}

-(void) handleCapabilityResponse{
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
    
    [self countPins];
    [self createAnalogPins];
    [self sendStateQuery];
}

-(void) handleAnalogMappingResponse{
    //NSLog(@"Handles AnalogMapping");
    
    int pin=0;
    for (int i=2; i<parse_count-1; i++) {
        
        pinInfo[pin].analogChannel = parse_buf[i];
        pin++;
    }
}

-(void) handlePinStateResponse{
    int pinNumber = parse_buf[2];
    int mode = parse_buf[3];
    
    //NSLog(@"Handles PinState Response %d %d",pinNumber,mode);
    
    if((pinInfo[pinNumber].supportedModes & (1<<IFPinModeInput) || pinInfo[pinNumber].supportedModes & (1<<IFPinModeOutput)) && !(pinInfo[pinNumber].supportedModes & (1<<IFPinModeAnalog))){
        
        
        IFPin * pin = [IFPin pinWithNumber:pinNumber type:IFPinTypeDigital mode:mode];
        [self.digitalPins addObject:pin];
        
        int value = parse_buf[4];
        if (parse_count > 6) value |= (parse_buf[5] << 7);
        if (parse_count > 7) value |= (parse_buf[6] << 14);
        pin.value = value;
        
        [pin addObserver:self forKeyPath:@"mode" options:NSKeyValueObservingOptionNew context:nil];
        [pin addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
        
        [self.delegate firmataDidUpdateDigitalPins:self];
        
        if(self.digitalPins.count % 4 == 0){
            [self makePinQueryForPin:pinNumber+1];
        }
    } else {
        NSLog(@"pin %d is in mode: %d",pinNumber,mode);
    }
}

-(void) handleI2CReply{
    uint8_t address = parse_buf[2] + (parse_buf[3] << 7);
    NSInteger registerNumber = parse_buf[4];
    
    //NSLog(@"addr: %d reg %d ",address,registerNumber);
    if(!startedI2C){
        NSLog(@"reporting but i2c did not start");
        [self sendI2CStopReadingAddress:address];
        
    } else {
        
        IFI2CComponent * component = nil;
        for (IFI2CComponent * aComponent in self.i2cComponents) {
            if(aComponent.address == address){
                component = aComponent;
            }
        }
        
        IFI2CRegister * reg = [component registerWithNumber:registerNumber];
        if(reg){
            uint8_t values[reg.size];
            NSInteger parseBufCount = 6;
            for (int i = 0; i < reg.size; i++) {
                uint8_t value = parse_buf[parseBufCount++] + (parse_buf[parseBufCount++] << 7);
                values[i] = value;
            }
            NSData * data = [NSData dataWithBytes:values length:reg.size];
            reg.value = data;
            
            /*
             int x = ((int16_t)(values[1] << 8 | values[0])) >> 4;
             int y = ((int16_t)(values[3] << 8 | values[2])) >> 4;
             int z = ((int16_t)(values[5] << 8 | values[4])) >> 4;*/
            
        }
    }
}

-(void) handleMessage{
    
	uint8_t cmd = (parse_buf[0] & START_SYSEX);
    
	if (cmd == 0xE0 && parse_count == 3) {
        [self handleAnalogMessage];

	} else if (cmd == 0x90 && parse_count == 3) {
        
		[self handleDigitalMessage];

	} else if (parse_buf[0] == START_SYSEX && parse_buf[parse_count-1] == END_SYSEX) {
        
		if (parse_buf[1] == REPORT_FIRMWARE) {
            
            [self handleFirmwareReport];

		} else if (parse_buf[1] == CAPABILITY_RESPONSE) {
            
			[self handleCapabilityResponse];
            
		} else if (parse_buf[1] == ANALOG_MAPPING_RESPONSE) {
            
            [self handleAnalogMappingResponse];
            
		} else if (parse_buf[1] == PIN_STATE_RESPONSE && parse_count >= 6) {
            
			[self handlePinStateResponse];
            
		} else if(parse_buf[1] == I2C_REPLY){

            [self handleI2CReply];
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
        
		uint8_t msn = value & START_SYSEX;
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
			parse_count = 0;
            parse_command_len = 0;
		}
	}
}

#pragma mark -- Pin Delegate

-(IFI2CComponent*) componentForRegister:(IFI2CRegister*) reg{
    for (IFI2CComponent * component in self.i2cComponents) {
        for (IFI2CRegister * aRegister in component.registers) {
            if(aRegister == reg){
                return component;
            }
        }
    }
    return nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath  ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqual:@"mode"]) {
        [self sendPinModeForPin:object];
    } else if([keyPath isEqual:@"value"]){
        [self sendOutputForPin:object];
    } else if([keyPath isEqual:@"updatesValues"]){
        [self sendReportRequestForAnalogPin:object];
    } else if([keyPath isEqual:@"notifies"]){
        IFI2CComponent * component = [self componentForRegister:object];
        [self sendI2CStartStopReportingRequestForRegister:object fromComponent:component];
    }
}

#pragma mark -- I2C Components

-(void) addObserversForI2CComponent:(IFI2CComponent*) component{
    for (IFI2CRegister * reg in component.registers) {
        [reg addObserver:self forKeyPath:@"notifies" options:NSKeyValueObservingOptionNew context:nil];
    }
}

-(void) addObserversForI2CComponents{
    for (IFI2CComponent * component in self.i2cComponents) {
        [self addObserversForI2CComponent:component];
    }
}

-(void) removeObserversForI2CComponent:(IFI2CComponent*) component{
    for (IFI2CRegister * reg in component.registers) {
        [reg removeObserver:self forKeyPath:@"notifies"];
    }
}

-(void) removeObserversForI2CComponents{
    for (IFI2CComponent * component in self.i2cComponents) {
        [self removeObserversForI2CComponent:component];
    }
}

-(void) setI2cComponents:(NSMutableArray *)i2cComponents{
    if(_i2cComponents != i2cComponents){
        
        [self removeObserversForI2CComponents];
        
        _i2cComponents = i2cComponents;
        
        [self addObserversForI2CComponents];
        
        [self.delegate firmataDidUpdateI2CComponents:self];
    }
}

-(void) addI2CComponent:(IFI2CComponent*) component{
    [self addObserversForI2CComponent:component];
    
    [self.i2cComponents addObject:component];
    [self.delegate firmataDidUpdateI2CComponents:self];
}

-(void) removeI2CComponent:(IFI2CComponent*) component{
    [self removeObserversForI2CComponent:component];
    
    [self sendStopReportingMessageForI2CComponent:component];
    
    [self.i2cComponents removeObject:component];
    [self.delegate firmataDidUpdateI2CComponents:self];
}

-(void) addI2CRegister:(IFI2CRegister*) reg toComponent:(IFI2CComponent*) component{
    [reg addObserver:self forKeyPath:@"notifies" options:NSKeyValueObservingOptionNew context:nil];
    [component addRegister:reg];
}

-(void) removeI2CRegister:(IFI2CRegister*) reg fromComponent:(IFI2CComponent*) component{
    if(reg.notifies){
        [self sendI2CStopReadingComponent:component];
    }
    
    [reg removeObserver:self forKeyPath:@"notifies"];
    [component removeRegister:reg];
}

@end
