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

float const kRequestTimeoutTime = 2.0f;

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
    for (GMPI2CComponent * component in self.i2cComponents) {
        [component removeObserver:self forKeyPath:@"notifies"];
    }*/
    
    [self.digitalPins removeAllObjects];
    [self.analogPins removeAllObjects];
    
    [self.delegate pinsControllerDidUpdateDigitalPins:self];
    [self.delegate pinsControllerDidUpdateAnalogPins:self];
    
    _numDigitalPins = 0;
    _numAnalogPins = 0;
    _numPins = 0;
    
    self.firmwareName = @"iFirmata";
}

-(void) sendOutputForPin:(GMPPin*) pin{
    
    if(pin.mode == kGMPPinModeOutput){
        
        [self.gmpController sendDigitalOutputForPin:pin.number value:pin.value];
        
    } else if(pin.mode == kGMPPinModePWM || pin.mode == kGMPPinModeServo){
        
        [self.gmpController sendAnalogWriteForPin:pin.number value:pin.value];
        
    }
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
        pin.updatesValues = NO;
    }
}

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
}*/

-(void) countPins{
    _numPins = 0;
    _numAnalogPins = 0;
    
    for (int pin=0; pin < GMPMaxNumPins; pin++) {
        NSLog(@"pin: %d %d",pin,pinCapabilities[pin]);
        
        if(pinCapabilities[pin] ){
            _numPins++;
            
            if((pinCapabilities[pin] & kGMPCapabilityADC) == kGMPCapabilityADC){
                _numAnalogPins++;
            }
        }
    }
    _numDigitalPins = _numPins - _numAnalogPins;
    
    NSLog(@"NumPins: %d, Digital: %d, Analog: %d",self.numPins,self.numDigitalPins,self.numAnalogPins);
}

#pragma mark - GMP Message Handles

-(void) gmpController:(GMP*) gmpController didReceiveFirmwareName: (NSString*) name{
    
    if([name isEqualToString:kGMPFirmwareName]){
        [self.gmpController sendResetRequest];
        [self.gmpController sendCapabilitiesRequest];
    }
}

-(void) resendLastPinModeRequest{
    
    NSInteger pin;
    
    if(self.digitalPins.count == 0){
        pin = [self nextValidPinStartingFromPin:0];
    } else {
        GMPPin * lastDigitalPin = [self.digitalPins objectAtIndex:self.digitalPins.count-1];
        pin = lastDigitalPin.number;
    }
    
    NSInteger lastPin;
    if(self.analogPins.count > 0){
        
        GMPPin * lastAnalogPin = [self.analogPins objectAtIndex:self.analogPins.count-1];
        lastPin = lastAnalogPin.number + pin + 2;
        
    } else {
        lastPin = pin + 1;
    }
    
    NSLog(@"resending %d",lastPin);
    
    [self.gmpController sendPinModeRequestForPin:lastPin];
    
    //[self sendPinModeQueryStartingFromPin:lastPin.number+1];
}

-(NSInteger) nextValidPinStartingFromPin:(NSInteger) pin{
    
    for (int i = pin; i < GMPMaxNumPins; i++) {
        
        if((pinCapabilities[i] & kGMPCapabilityGPIO) == kGMPCapabilityGPIO || (pinCapabilities[i] & kGMPCapabilityPWM) == kGMPCapabilityPWM || (pinCapabilities[i] & kGMPCapabilityADC) == kGMPCapabilityADC){
            
            if(i==20){
                NSLog(@"wtf");
            }
            return i;
        }
    }
    return -1;
}

-(void) sendPinModeQueryStartingFromPin:(NSInteger) pin{
    
    pin = [self nextValidPinStartingFromPin:pin];
    
    if(pin >= 0){
        
        [self.gmpController sendPinModeRequestForPin:pin];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:kRequestTimeoutTime target:self selector:@selector(resendLastPinModeRequest) userInfo:nil repeats:YES];
    }
    return;
    
}

-(void) gmpController:(GMP*) gmpController didReceiveCapabilityResponseForPins:(uint8_t*) buffer count:(NSInteger) count{
    
    for(int i = 0 ; i < count ; i+=2){
        
        uint8_t pin = buffer[i];
        uint8_t capability = buffer[i+1];
        
        pinCapabilities[pin] = capability;
    }
    
    [self countPins];
    [self sendPinModeQueryStartingFromPin:0];
}

-(BOOL)isPinContained:(NSInteger) pinNumber inArray:(NSMutableArray*) pins{
    for (GMPPin * pin in pins) {
        if(pin.number == pinNumber){
            return YES;
        }
    }
    return NO;
}

-(void) gmpController:(GMP*) gmpController didReceivePinStateResponseForPin:(NSInteger) pin mode:(GMPPinMode) mode{
    
    NSLog(@"received mode %d %d",pin,mode);
    
    GMPPin * pinObj;
    
    if(timer){
        [timer invalidate];
        timer = nil;
    }
    
    BOOL pinExists = NO;
    
    if(mode == kGMPPinModeAnalog){
        
        if(self.digitalPins.count > 0){
            GMPPin * lastDigitalPin = [self.digitalPins objectAtIndex:self.digitalPins.count-1];
            pinExists = [self isPinContained:pin - lastDigitalPin.number - 1 inArray:self.analogPins];
        }
    } else {
        pinExists = [self isPinContained:pin inArray:self.digitalPins];

    }
    
    if(!pinExists){
        if (mode == kGMPPinModeAnalog) {
            
            GMPPin * lastDigitalPin = [self.digitalPins objectAtIndex:self.digitalPins.count-1];
            pinObj = [[GMPPin alloc] initWithNumber:pin - lastDigitalPin.number-1];
            pinObj.type = kGMPPinTypeAnalog;
            pinObj.mode = mode;
            
            [self.analogPins addObject:pinObj];
            
            [pinObj addObserver:self forKeyPath:@"updatesValues" options:NSKeyValueObservingOptionNew context:nil];
            
            [self.delegate pinsControllerDidUpdateAnalogPins:self];
            
        } else {
            
            pinObj = [[GMPPin alloc] initWithNumber:pin];
            pinObj.type = kGMPPinTypeDigital;
            pinObj.mode = mode;
            
            [self.digitalPins addObject:pinObj];
            
            [self.delegate pinsControllerDidUpdateDigitalPins:self];
        }
        
        [pinObj addObserver:self forKeyPath:@"mode" options:NSKeyValueObservingOptionNew context:nil];
        [pinObj addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
        
        [self sendPinModeQueryStartingFromPin:pin+1];
    }
}

-(void) gmpController:(GMP *)gmpController didReceiveDigitalMessageForPin:(NSInteger)pin value:(BOOL)value{
    
    NSLog(@"digital msg for pin: %d",pin);
    
    for (GMPPin * pinObj in self.digitalPins) {
        if(pinObj.number == pin){
            pinObj.value = value;
            break;
        }
    }
}

-(void) gmpController:(GMP *)gmpController didReceiveAnalogMessageForPin:(NSInteger)pin value:(NSInteger)value{
    
    NSLog(@"analog msg for pin: %d %d",pin, value);
    /*
    GMPPin * lastDigital = [self.digitalPins objectAtIndex:self.digitalPins.count-1];
    GMPPin * analogPin =[self.analogPins objectAtIndex:pin - lastDigital.number + 1 reports:pin.updatesValues];
    */
    if(pin < self.analogPins.count){
        
        GMPPin * pinObj = [self.analogPins objectAtIndex:pin];
        pinObj.value = value;
    }
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
    
    if ([keyPath isEqual:@"mode"]) {
        
        GMPPin * pin = object;
        [self.gmpController sendPinModeForPin:pin.number mode:pin.mode];
        
        if(pin.type == kGMPPinTypeDigital && pin.mode == kGMPPinModeInput){
            [self.gmpController sendReportRequestForDigitalPin:pin.number reports:YES];
        }
        
    } else if([keyPath isEqual:@"value"]){
        
        [self sendOutputForPin:object];
        
    } else if([keyPath isEqual:@"updatesValues"]){
        
        GMPPin * pin = object;
        
        GMPPin * lastDigital = [self.digitalPins objectAtIndex:self.digitalPins.count-1];
        [self.gmpController sendReportRequestForAnalogPin:pin.number + lastDigital.number + 1 reports:pin.updatesValues];
        
    } else if([keyPath isEqual:@"notifies"]){
        
        GMPI2CComponent * component = [self componentForRegister:object];
        [self sendI2CStartStopReportingRequestForRegister:object fromComponent:component];
        
    }
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
