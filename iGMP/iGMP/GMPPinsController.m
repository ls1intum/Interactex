//
//  IFFirmata.m
//  iFirmata
//
//  Created by Juan Haladjian on 6/28/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "GMPPinsController.h"
#import "GMPPin.h"
#import "BLEService.h"
#import "BLEHelper.h"
#import "GMPI2CComponent.h"
#import "GMPI2CRegister.h"
#import "GMP.h"

@implementation GMPPinsController

NSString * const kGMPFirmwareName = @"eGMCP1.0";

-(id) init{
    self = [super init];
    if(self){
        
        self.gmpController = [[GMP alloc] init];
        self.gmpController.delegate = self;
        
        self.digitalPins = [NSMutableArray array];
        self.analogPins = [NSMutableArray array];
        self.i2cComponents = [NSMutableArray array];
    }
    return self;
}

-(void) reset {
    
    for (GMPPin * pin in self.digitalPins) {
        [pin removeObserver:self forKeyPath:@"mode"];
        [pin removeObserver:self forKeyPath:@"value"];
    }
    
    for (GMPPin * pin in self.analogPins) {
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
    
    [self.delegate pinsControllerDidUpdateDigitalPins:self];
    [self.delegate pinsControllerDidUpdateAnalogPins:self];
    
    numDigitalPins = 0;
    numAnalogPins = 0;
    numPins = 0;
    
    self.firmwareName = @"iFirmata";
}

-(void) sendDigitalOutputForPin:(GMPPin*) pin{
    /*
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
    
    [self.gmpController sendDigitalOutputForPort:port value:value];*/
    
}

-(void) sendOutputForPin:(GMPPin*) pin{
    /*
    if(pin.mode == IFPinModeOutput){
        
        [self sendDigitalOutputForPin:pin];
        
    } else if(pin.mode == IFPinModePWM || pin.mode == IFPinModeServo){
        
        [self.firmataController sendAnalogOutputForPin:pin.number value:pin.value];
        
    }*/
}

-(void) stopReportingI2CComponent:(GMPI2CComponent*) component{
    [self sendStopReportingMessageForI2CComponent:component];
    
    for (GMPI2CRegister * reg in component.registers) {
        if(reg.notifies){
            [reg removeObserver:self forKeyPath:@"notifies"];
            reg.notifies = NO;
            [reg addObserver:self forKeyPath:@"notifies" options:NSKeyValueObservingOptionNew context:nil];
        }
    }
}

-(void) sendStopReportingMessageForI2CComponent:(GMPI2CComponent*) component{
    for (GMPI2CRegister * reg in component.registers) {
        if(reg.notifies){
            [self.gmpController sendI2CStopStreamingAddress:component.address];
        }
    }
}

-(void) stopReportingI2CComponents{
    for (GMPI2CComponent * component in self.i2cComponents) {
        [self stopReportingI2CComponent:component];
    }
}

-(void) stopReportingAnalogPins{
    for (GMPPin * pin in self.analogPins) {
        //pin.updatesValues = NO;
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

/*
-(void) createAnalogPinsFromBuffer:(uint8_t*) buffer length:(NSInteger) length{
    
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
}*/

#pragma mark - Firmata Message Handles

-(void) gmpController:(GMP*) gmpController didReceiveFirmwareName: (NSString*) name{
    
    if([name isEqualToString:kGMPFirmwareName]){
        [self.gmpController sendCapabilitiesAndReportRequest];
    }
}

-(void) firmataController:(GMP*) firmataController didReceiveAnalogMessageOnChannel:(NSInteger) channel value:(NSInteger) value{
    
    /*
    for (GMPPin * pin in self.analogPins) {
        if (pin.analogChannel == channel) {
            pin.value = value;
            return;
        }
    }*/
}

-(void) firmataController:(GMP*) gmpController didReceiveDigitalMessageForPort:(NSInteger) pinNumber value:(NSInteger) value{
    
    /*
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
    }*/
}
/*
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
}*/

-(void) gmpController:(GMP*) gmpController didReceiveCapabilityResponseForPin:(pin_t) pin{
    
    NSLog(@"received capability %d %d",pin.index,pin.capability);
    
    /*
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
    [self sendInitialPinStateQuery];*/
}

-(void) firmataController:(GMP*) firmataController didReceiveAnalogMappingResponse:(uint8_t*) buffer length:(NSInteger) length {
    /*
    int pin=0;
    for (int i=2; i<length-1; i++) {
        
        pinInfo[pin].analogChannel = buffer[i];
        pin++;
    }*/
}

-(void) makePinQueryForSubsequentPinsStartingAtPin:(int) pin{
    /*
    NSInteger numPinsToSend = 0;
    NSInteger pinNumbers[4];
    
    for(int i = pin ; i < pin + 4; i++){

        if((pinInfo[i].supportedModes & (1<<IFPinModeInput)) && (pinInfo[i].supportedModes & (1<<IFPinModeOutput)) && !(pinInfo[i].supportedModes & (1<<IFPinModeAnalog))){
            pinNumbers[numPinsToSend++] = i;
            
        }
    }
    if(numPinsToSend > 0){
        [self.firmataController sendPinQueryForPinNumbers:pinNumbers length:numPinsToSend];
    }*/
}


-(void) gmpController:(GMP*) gmpController didReceivePinStateResponse:(uint8_t*) buffer length:(NSInteger) length{
    
/*
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
        
    }*/
}

-(void) gmpController:(GMP*) gmpController didReceiveI2CReply:(uint8_t*) buffer length:(NSInteger) length {
    
    uint8_t address = buffer[2] + (buffer[3] << 7);
   // NSInteger registerNumber = buffer[4];
    
    
    GMPI2CComponent * component = nil;
    for (GMPI2CComponent * aComponent in self.i2cComponents) {
        if(aComponent.address == address){
            component = aComponent;
        }
    }
    /*
    GMPI2CRegister * reg = [component registerWithNumber:registerNumber];
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
        
    }*/
}


#pragma mark -- Pin Delegate

-(GMPI2CComponent*) componentForRegister:(GMPI2CRegister*) reg{
    for (GMPI2CComponent * component in self.i2cComponents) {
        for (GMPI2CRegister * aRegister in component.registers) {
            if(aRegister == reg){
                return component;
            }
        }
    }
    return nil;
}

-(void) sendI2CStartStopReportingRequestForRegister:(GMPI2CRegister*) reg fromComponent:(GMPI2CComponent*) component{
    
    if(reg.notifies){
        /*
        [self.gmpController sendI2CStartReadingAddress:component.address reg:reg.number size:reg.size];*/
        
    } else {
        [self.gmpController sendI2CStopStreamingAddress:component.address];
        
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath  ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    /*
    if ([keyPath isEqual:@"mode"]) {
        
        GMPPin * pin = object;
        [self.gmpController sendPinModeForPin:pin.number mode:pin.mode];
        
    } else if([keyPath isEqual:@"value"]){
        
        [self sendOutputForPin:object];
        
    } else if([keyPath isEqual:@"updatesValues"]){
        
        GMPPin * pin = object;
        [self.gmpController sendReportRequestForAnalogPin:pin.number reports:pin.updatesValues];
        
    } else if([keyPath isEqual:@"notifies"]){
        
        GMPI2CComponent * component = [self componentForRegister:object];
        [self sendI2CStartStopReportingRequestForRegister:object fromComponent:component];
        
    }*/
}

#pragma mark -- I2C Components

-(void) addObserversForI2CComponent:(GMPI2CComponent*) component{
    
    for (GMPI2CRegister * reg in component.registers) {
        [reg addObserver:self forKeyPath:@"notifies" options:NSKeyValueObservingOptionNew context:nil];
    }
}

-(void) addObserversForI2CComponents{
    for (GMPI2CComponent * component in self.i2cComponents) {
        [self addObserversForI2CComponent:component];
    }
}

-(void) removeObserversForI2CComponent:(GMPI2CComponent*) component{
    for (GMPI2CRegister * reg in component.registers) {
        [reg removeObserver:self forKeyPath:@"notifies"];
    }
}

-(void) removeObserversForI2CComponents{
    for (GMPI2CComponent * component in self.i2cComponents) {
        [self removeObserversForI2CComponent:component];
    }
}

-(void) setI2cComponents:(NSMutableArray *)i2cComponents{
    if(_i2cComponents != i2cComponents){
        
        [self removeObserversForI2CComponents];
        
        _i2cComponents = i2cComponents;
        
        [self addObserversForI2CComponents];
        
        [self.delegate pinsControllerDidUpdateI2CComponents:self];
    }
}

-(void) addI2CComponent:(GMPI2CComponent*) component{
    [self addObserversForI2CComponent:component];
    
    [self.i2cComponents addObject:component];
    [self.delegate pinsControllerDidUpdateI2CComponents:self];
}

-(void) removeI2CComponent:(GMPI2CComponent*) component{
    [self removeObserversForI2CComponent:component];
    
    [self sendStopReportingMessageForI2CComponent:component];
    
    [self.i2cComponents removeObject:component];
    [self.delegate pinsControllerDidUpdateI2CComponents:self];
}

-(void) addI2CRegister:(GMPI2CRegister*) reg toComponent:(GMPI2CComponent*) component{
    [reg addObserver:self forKeyPath:@"notifies" options:NSKeyValueObservingOptionNew context:nil];
    [component addRegister:reg];
}

-(void) removeI2CRegister:(GMPI2CRegister*) reg fromComponent:(GMPI2CComponent*) component{
    if(reg.notifies){
        [self.gmpController sendI2CStopStreamingAddress:component.address];
    }
    
    [reg removeObserver:self forKeyPath:@"notifies"];
    [component removeRegister:reg];
}

@end
