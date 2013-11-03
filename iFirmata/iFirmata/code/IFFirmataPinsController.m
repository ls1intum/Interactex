//
//  IFFirmata.m
//  iFirmata
//
//  Created by Juan Haladjian on 6/28/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "IFFirmataPinsController.h"
#import "IFPin.h"
#import "BLEService.h"
#import "BLEHelper.h"
#import "IFI2CComponent.h"
#import "IFI2CRegister.h"
#import "IFFirmataController.h"

@implementation IFFirmataPinsController

-(id) init{
    self = [super init];
    if(self){
        
        self.firmataController = [[IFFirmataController alloc] init];
        self.firmataController.delegate = self;
        
        self.digitalPins = [NSMutableArray array];
        self.analogPins = [NSMutableArray array];
        self.i2cComponents = [NSMutableArray array];
    }
    return self;
}

-(void) reset {
    
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
    
    [self resetBuffers];
    
    numDigitalPins = 0;
    numAnalogPins = 0;
    numPins = 0;
    
    self.firmataName = @"iFirmata";
}

-(void) resetBuffers {
    
    for (int i = 0; i < IFPinInfoBufSize; i++) {
        pinInfo[i].analogChannel = 127;
        pinInfo[i].supportedModes = 0;
    }
}


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
    
    [self.firmataController sendDigitalOutputForPort:port value:value];
    
}

-(void) sendOutputForPin:(IFPin*) pin{
    
    if(pin.mode == IFPinModeOutput){
        
        [self sendDigitalOutputForPin:pin];
        
    } else if(pin.mode == IFPinModePWM || pin.mode == IFPinModeServo){
        
        [self.firmataController sendAnalogOutputForPin:pin.number value:pin.value];
        
    }
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
            [self.firmataController sendI2CStopReadingAddress:component.address];
        }
    }
}

-(void) stopReportingI2CComponents{
    for (IFI2CComponent * component in self.i2cComponents) {
        [self stopReportingI2CComponent:component];
    }
}

-(void) stopReportingAnalogPins{
    for (IFPin * pin in self.analogPins) {
        pin.updatesValues = NO;
    }
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


-(void) createAnalogPinsFromBuffer:(uint8_t*) buffer length:(NSInteger) length{
    
    int firstAnalog = numDigitalPins;
    for (; firstAnalog < IFPinInfoBufSize; firstAnalog++) {
        if(pinInfo[firstAnalog].supportedModes & (1<<IFPinModeAnalog)){
            break;
        }
    }
    
    //NSLog(@"first analog at pos: %d",firstAnalog);
    for (int i = 0; i < numAnalogPins; i++) {
                
        IFPin * pin = [IFPin pinWithNumber:i type:IFPinTypeAnalog mode:IFPinModeAnalog];
        pin.analogChannel = pinInfo[i+firstAnalog].analogChannel;
        [self.analogPins addObject:pin];
        
        int value = buffer[4];
        if (length > 6) value |= (buffer[5] << 7);
        if (length > 7) value |= (buffer[6] << 14);
        pin.value = value;
        
        [pin addObserver:self forKeyPath:@"mode" options:NSKeyValueObservingOptionNew context:nil];
        [pin addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
        [pin addObserver:self forKeyPath:@"updatesValues" options:NSKeyValueObservingOptionNew context:nil];
        
        [self.delegate firmataDidUpdateAnalogPins:self];
    }
}

-(void) countPins{
    numPins = 0;
    numAnalogPins = 0;
    
    for (int pin=0; pin < 128; pin++) {
        if(pinInfo[pin].supportedModes ){
            numPins++;            
            
            if(pinInfo[pin].supportedModes & (1<<IFPinModeAnalog)){
                numAnalogPins++;
            }
        }
    }
    numDigitalPins = numPins - numAnalogPins;
    
    //NSLog(@"NumPins: %d, Digital: %d, Analog: %d",self.numPins,self.numDigitalPins,self.numAnalogPins);
}

#pragma mark - Firmata Message Handles

-(void) firmataController:(IFFirmataController*) firmataController didReceiveFirmwareReport:(uint8_t*) buffer length:(NSInteger) length{
    
    char name[140];
    int len=0;
    for (int i=4; i < length-2; i+=2) {
        name[len++] = (buffer[i] & 0x7F)
        | ((buffer[i+1] & 0x7F) << 7);
    }
    name[len++] = '-';
    name[len++] = buffer[2] + '0';
    name[len++] = '.';
    name[len++] = buffer[3] + '0';
    name[len++] = 0;
    _firmataName = [NSString stringWithUTF8String:name];
    [self.delegate firmata:self didUpdateTitle:self.firmataName];
    
    [self.firmataController sendCapabilitiesAndReportRequest];
}

-(void) firmataController:(IFFirmataController*) firmataController didReceiveAnalogMessageOnChannel:(NSInteger) channel value:(NSInteger) value{
    
    for (IFPin * pin in self.analogPins) {
        if (pin.analogChannel == channel) {
            pin.value = value;
            return;
        }
    }
}

-(void) firmataController:(IFFirmataController*) firmataController didReceiveDigitalMessageForPort:(NSInteger) pinNumber value:(NSInteger) value{
    
    IFPin * firstPin = (IFPin*) [self.digitalPins objectAtIndex:0];
    int mask = 1;
    
    for (mask <<= firstPin.number; pinNumber < self.digitalPins.count; mask <<= 1, pinNumber++) {
        IFPin * pinObj = [self.digitalPins objectAtIndex:pinNumber];
        if (pinObj.mode == IFPinModeInput) {
            uint32_t val = (value & mask) ? 1 : 0;
            if (pinObj.value != val) {
                pinObj.value = val;
            }
        }
    }
}

//makes the pin query for the initial pins. The other queries happen later
-(void) sendInitialPinStateQuery{
    
    NSInteger buf[4];
    int len = 0;
    for (int pin=0; pin < IFPinInfoBufSize; pin++) {
        if((pinInfo[pin].supportedModes & (1<<IFPinModeInput)) && (pinInfo[pin].supportedModes & (1<<IFPinModeOutput)) && !(pinInfo[pin].supportedModes & (1<<IFPinModeAnalog))){
            
            buf[len++] = pin;
            
            if(len == 4){
                break;
            }
        }
    }
    
    [self.firmataController sendPinQueryForPinNumbers:buf length:len];
}

-(void) firmataController:(IFFirmataController*) firmataController didReceiveCapabilityResponse:(uint8_t*) buffer length:(NSInteger) length{
    
    for (int i=2, n=0, pin=0; i<length; i++) {
        if (buffer[i] == 127) {
            pin++;
            n = 0;
            continue;
        }
        if (n == 0) {
            pinInfo[pin].supportedModes |= (1<<buffer[i]);
        }
        n = n ^ 1;
    }
    
    [self countPins];
    [self createAnalogPinsFromBuffer:buffer length:length];
    [self sendInitialPinStateQuery];
}


-(void) firmataController:(IFFirmataController*) firmataController didReceiveAnalogMappingResponse:(uint8_t*) buffer length:(NSInteger) length {
    
    int pin=0;
    for (int i=2; i<length-1; i++) {
        
        pinInfo[pin].analogChannel = buffer[i];
        pin++;
    }
}

-(void) makePinQueryForSubsequentPinsStartingAtPin:(int) pin{
    
    NSInteger numPinsToSend = 0;
    NSInteger pinNumbers[4];
    
    for(int i = pin ; i < pin + 4; i++){

        if((pinInfo[i].supportedModes & (1<<IFPinModeInput)) && (pinInfo[i].supportedModes & (1<<IFPinModeOutput)) && !(pinInfo[i].supportedModes & (1<<IFPinModeAnalog))){
            pinNumbers[numPinsToSend++] = i;
            
        }
    }
    if(numPinsToSend > 0){
        [self.firmataController sendPinQueryForPinNumbers:pinNumbers length:numPinsToSend];
    }
}

-(void) firmataController:(IFFirmataController*) firmataController didReceivePinStateResponse:(uint8_t*) buffer length:(NSInteger) length {

    int pinNumber = buffer[2];
    int mode = buffer[3];
    
    //NSLog(@"Handles PinState Response %d %d",pinNumber,mode);
    
    if((pinInfo[pinNumber].supportedModes & (1<<IFPinModeInput) || pinInfo[pinNumber].supportedModes & (1<<IFPinModeOutput)) && !(pinInfo[pinNumber].supportedModes & (1<<IFPinModeAnalog))){
        
        IFPin * pin = [IFPin pinWithNumber:pinNumber type:IFPinTypeDigital mode:mode];
        [self.digitalPins addObject:pin];
        
        int value = buffer[4];
        if (length > 6) value |= (buffer[5] << 7);
        if (length > 7) value |= (buffer[6] << 14);
        pin.value = value;
        
        [pin addObserver:self forKeyPath:@"mode" options:NSKeyValueObservingOptionNew context:nil];
        [pin addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
        
        [self.delegate firmataDidUpdateDigitalPins:self];
        
        if(self.digitalPins.count % 4 == 0){
            [self makePinQueryForSubsequentPinsStartingAtPin:pinNumber+1];
        }
        
    } else {
        
       // NSLog(@"pin %d is in mode: %d",pinNumber,mode);
        
    }
}

-(void) firmataController:(IFFirmataController*) firmataController didReceiveI2CReply:(uint8_t*) buffer length:(NSInteger)length {
    
    uint8_t address = buffer[2] + (buffer[3] << 7);
    NSInteger registerNumber = buffer[4];
    
    //NSLog(@"addr: %d reg %d ",address,registerNumber);
    if(!self.firmataController.startedI2C){
        
        NSLog(@"reporting but i2c did not start");
        [self.firmataController sendI2CStopReadingAddress:address];
        
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
                uint8_t byte1 = buffer[parseBufCount++];
                uint8_t value = byte1 + (buffer[parseBufCount++] << 7);
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

-(void) sendI2CStartStopReportingRequestForRegister:(IFI2CRegister*) reg fromComponent:(IFI2CComponent*) component{
    
    if(reg.notifies){
        [self.firmataController sendI2CStartReadingAddress:component.address reg:reg.number size:reg.size];
        
    } else {
        [self.firmataController sendI2CStopReadingAddress:component.address];
        
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath  ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqual:@"mode"]) {
        
        IFPin * pin = object;
        [self.firmataController sendPinModeForPin:pin.number mode:pin.mode];
        
    } else if([keyPath isEqual:@"value"]){
        
        [self sendOutputForPin:object];
        
    } else if([keyPath isEqual:@"updatesValues"]){
        
        IFPin * pin = object;
        [self.firmataController sendReportRequestForAnalogPin:pin.number reports:pin.updatesValues];
        
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
        [self.firmataController sendI2CStopReadingAddress:component.address];
    }
    
    [reg removeObserver:self forKeyPath:@"notifies"];
    [component removeRegister:reg];
}

@end
