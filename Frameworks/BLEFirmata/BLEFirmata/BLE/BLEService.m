
#import "BLEService.h"
#import "BLEDiscovery.h"
#import "BLEHelper.h"
#import <QuartzCore/QuartzCore.h>

uint8_t const kBleCrcStart = 170;


NSString * const kBleSupportedServices[kBleNumSupportedServices] = {@"F9266FD7-EF07-45D6-8EB6-BD74F13620F9"};

NSString * const kBleCharacteristics[kBleNumSupportedServices][2] = {
    {@"4585C102-7784-40B4-88E1-3CB5C4FD37A3",@"E788D73B-E793-4D9E-A608-2F2BAFC59A00"}};

/*NSString * const kBleSupportedServices[kBleNumSupportedServices] = {@"F9266FD7-EF07-45D6-8EB6-BD74F13620F9",@"ffe0"};//Kroll's BLE; Kyle's BLE

NSString * const kBleCharacteristics[kBleNumSupportedServices][2] = {
    {@"4585C102-7784-40B4-88E1-3CB5C4FD37A3",@"E788D73B-E793-4D9E-A608-2F2BAFC59A00"},
    {@"ffe1",@"ffe1"}};//RX; TX
*/

const NSTimeInterval kFlushInterval = 1.0f/30.0f;

@implementation BLEService


static NSMutableArray * supportedServiceUUIDs;
static NSMutableArray * supportedCharacteristicUUIDs;

#pragma mark Static Methods

+(NSMutableArray*) supportedServiceUUIDs{
    return supportedServiceUUIDs;
}

+(NSMutableArray*) supportedCharacteristicUUIDs{
    return supportedCharacteristicUUIDs;
}

#pragma mark Init

- (id) initWithPeripheral:(CBPeripheral *)peripheral {
    self = [super init];
    if (self) {
        _peripheral = peripheral;
        [self.peripheral setDelegate:self];
        
        supportedServiceUUIDs =  [NSMutableArray array];
        supportedCharacteristicUUIDs = [NSMutableArray array];
        
        for (int i = 0; i < kBleNumSupportedServices; i++) {
            CBUUID * rxCharacteristic = [CBUUID UUIDWithString:kBleCharacteristics[i][0]];
            CBUUID * txCharacteristic = [CBUUID UUIDWithString:kBleCharacteristics[i][1]];
            NSArray * characteristics = [NSArray arrayWithObjects:rxCharacteristic,txCharacteristic, nil];
            [supportedCharacteristicUUIDs addObject:characteristics];
            
            CBUUID * service = [CBUUID UUIDWithString:kBleSupportedServices[i]];
            [supportedServiceUUIDs addObject:service];
        }
        
        timer = [NSTimer scheduledTimerWithTimeInterval:kFlushInterval target:self selector:@selector(flushData) userInfo:nil repeats:YES];
	}
    return self;
}


- (void) dealloc {
	if (self.peripheral) {
		[self.peripheral setDelegate:[BLEDiscovery sharedInstance]];
		_peripheral = nil;
    }
}

-(CBUUID*) uuid{
    return bleService.UUID;
}

#pragma mark Service interaction

- (void) start {
	//
    //CBUUID	*serviceUUID	= [CBUUID UUIDWithString:kBleServiceUUIDString];
	//NSArray	*serviceArray	= [NSArray arrayWithObjects:serviceUUID, nil];
    
    [_peripheral discoverServices:supportedServiceUUIDs];
}

- (void) reset {
	if (self.peripheral) {
		_peripheral = nil;
	}
}

- (void) disconnect {
    [[BLEDiscovery sharedInstance] disconnectCurrentPeripheral];
    
    sendBufferCount = 0;
    sendBufferStart = 0;
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
	NSArray		*services	= nil;
	//NSArray		*uuids	= [NSArray arrayWithObjects:rxUUID,   rxCountUUID,   rxClearUUID, txUUID, nil];

	if (peripheral != _peripheral) {
        [self.delegate reportMessage:@"Wrong Peripheral"];
		return ;
	}
    
    if (error != nil) {
        NSString * message = [NSString stringWithFormat:@"Error: %@",error];
        [self.delegate reportMessage:message];
		return ;
	}

	services = [peripheral services];
	if (!services || ![services count]) {
		return ;
	}

	bleService = nil;
    
	for (CBService *service in services) {
        
        //NSLog(@"service found is: %@", [BLEHelper UUIDToString:service.UUID]);
        
        for (int i = 0; i < supportedServiceUUIDs.count; i++) {
            CBUUID * serviceUUID = [supportedServiceUUIDs objectAtIndex:i];
            
            if([service.UUID isEqual:serviceUUID]){
                
               // NSLog(@"service connected is: %@", [BLEHelper UUIDToString:service.UUID]);
                
                self.currentCharacteristicUUIDs = [supportedCharacteristicUUIDs objectAtIndex:i];
                bleService = service;
                break;
            }
        }
	}

	if (bleService) {
        [peripheral discoverCharacteristics:nil forService:bleService];
		//[peripheral discoverCharacteristics:uuids forService:bleService];
	}
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
	if (peripheral != _peripheral) {
        [self.delegate reportMessage:@"Wrong Peripheral"];
		return ;
	}
	
	if (service != bleService) {
        [self.delegate reportMessage:@"Wrong Service"];
		return ;
	}
    
    if (error != nil) {
        NSString * message = [NSString stringWithFormat:@"Error: %@",error];
        [self.delegate reportMessage:message];
		return ;
	}
    
	for (CBCharacteristic *characteristic in service.characteristics) {
        
        NSLog(@"discovered characteristic %@",[characteristic UUID]);
        
        if ([[characteristic UUID] isEqual:self.currentCharacteristicUUIDs[0]]) {
            
			_rxCharacteristic = characteristic;
			[peripheral setNotifyValue:YES forCharacteristic:_rxCharacteristic];
		}
        
        if ([[characteristic UUID] isEqual:self.currentCharacteristicUUIDs[1]]) {
            
			_txCharacteristic = characteristic;
            
			//[peripheral setNotifyValue:YES forCharacteristic:_txCharacteristic];
            [self.delegate bleServiceIsReady:self];
		}
        
        /*
        if ([[characteristic UUID] isEqual:bdUUID]) {
            
            //[self.delegate reportMessage:@"Discovered BD"];
			_bdCharacteristic = characteristic;
			[peripheral readValueForCharacteristic:_bdCharacteristic];
        } else if ([[characteristic UUID] isEqual:rxUUID]) {
            //[self.delegate reportMessage:@"Discovered RX"];
			_rxCharacteristic = characteristic;
			//[peripheral readValueForCharacteristic:_rxCharacteristic];
			[peripheral setNotifyValue:YES forCharacteristic:_rxCharacteristic];
		} else if ([[characteristic UUID] isEqual:rxCountUUID]) {
            //[self.delegate reportMessage:@"Discovered RX Count"];
			_rxCountCharacteristic = characteristic ;
			[peripheral readValueForCharacteristic:characteristic];
        } else if ([[characteristic UUID] isEqual:rxClearUUID]) {
            //[self.delegate reportMessage:@"Discovered RX Clear"];
			_rxClearCharacteristic = characteristic;
		} else if ([[characteristic UUID] isEqual:txUUID]) {
            //[self.delegate reportMessage:@"Discovered TX"];
            
			_txCharacteristic = characteristic;
            
			[peripheral setNotifyValue:YES forCharacteristic:_txCharacteristic];
            [self.delegate bleServiceIsReady:self];
		} else {
            //NSString * message = [NSString stringWithFormat:@"Discovered: %@",characteristic.UUID];
            //[self.delegate reportMessage:message];
        }*/
        
        
	}
}

#pragma mark Characteristics interaction
/*
-(void) clearRx{
    if(self.peripheral.isConnected){
        short byte = 1;
        NSData * data = [NSData dataWithBytes:&byte length:1];
        [_peripheral writeValue:data forCharacteristic:self.rxClearCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}*/

-(uint16_t) calculateCRCForBytes:(uint8_t*) bytes count:(NSInteger) count{
    uint16_t crc = 0;
    
    for (int i = 0; i < count; i++) {
        uint8_t b = bytes[i];
        
        crc = (uint8_t)(crc >> 8) | (crc << 8);
        crc ^= b;
        crc ^= (uint8_t)(crc & 0xff) >> 4;
        crc ^= crc << 12;
        crc ^= (crc & 0xff) << 5;
    }
    return crc;
}

-(NSData*) crcPackageForBytes:(const uint8_t*) bytes count:(NSInteger) count{
    
    uint8_t crcBytes[count+4];
    crcBytes[0] = kBleCrcStart;
    crcBytes[1] = count;
    
    memcpy(crcBytes + 2, bytes, count);
    
    uint16_t crcValue = [self calculateCRCForBytes:crcBytes+1 count:count+1];
    
    //NSLog(@"crc value: %d",crcValue);
    
    uint8_t firstByte = (crcValue & 0xFF00) >> 8;
    uint8_t secondByte = (crcValue & 0x00FF);
    
    crcBytes[count+2] = firstByte;
    crcBytes[count+3] = secondByte;
    
    return [NSData dataWithBytes:crcBytes length:count + 4];
}

-(void) writeToTx:(NSData*) data{
    
    if(self.txCharacteristic){
        //without response does not work with BLE Shield
        [_peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}


-(void) sendData:(const uint8_t*) bytes count:(NSInteger) count{

    if(self.shouldUseCRC){
        NSData * crcData = [self crcPackageForBytes:bytes count:count];
        bytes = crcData.bytes;
        count = crcData.length;
    }
    
    int idx = (sendBufferStart + sendBufferCount) % SEND_BUFFER_SIZE;
    for (int i = 0; i < count; i++) {
        sendBuffer[idx] = bytes[i];
        idx = (idx + 1) % SEND_BUFFER_SIZE;
    }
    sendBufferCount += count;
    if(sendBufferCount >= SEND_BUFFER_SIZE){
        NSLog(@"Warning, reaching limits of ble send buffer");
        sendBufferCount = SEND_BUFFER_SIZE;
    }
    
    double currentTime = CACurrentMediaTime();
    
    if(currentTime - lastTimeFlushed > kFlushInterval){
        [self flushData];
    }
    
    /*
    printf("Sending:\n");
    for (int i = 0; i < count+4; i++) {
        printf("%X ",crcBytes[i]);
    }
    printf("\n");*/
}

-(void) flushData {
    if(sendBufferCount > 0){
                
        char buf[TX_BUFFER_SIZE];
        
        int numBytesSend = MIN(TX_BUFFER_SIZE,sendBufferCount);
        
        if(sendBufferStart + numBytesSend > SEND_BUFFER_SIZE){
            
            char firstPartSize = SEND_BUFFER_SIZE - sendBufferStart ;
            
            memcpy(buf,&sendBuffer[0] + sendBufferStart,firstPartSize);
            memcpy(&buf[0] + firstPartSize,&sendBuffer[0],numBytesSend-firstPartSize);
            
        } else {
            
            memcpy(buf,&sendBuffer[0] + sendBufferStart,numBytesSend);
        }
        
        NSData * data = [NSData dataWithBytes:buf length:numBytesSend];
        [self writeToTx:data];
        
        sendBufferCount -= numBytesSend;
        sendBufferStart = (sendBufferStart + numBytesSend) % SEND_BUFFER_SIZE;
        
        //NSLog(@"sendbufCount: %d",sendBufferCount);
        lastTimeFlushed = CACurrentMediaTime();
    }
}

- (void)enteredBackground
{
    [_peripheral setNotifyValue:NO forCharacteristic:self.rxCharacteristic];
}

- (void)enteredForeground
{
    [_peripheral setNotifyValue:YES forCharacteristic:self.rxCharacteristic];
}

/*
-(void) updateRxClear{
    
    [self.peripheral readValueForCharacteristic:self.rxClearCharacteristic];
}

-(void) updateRxCount{
    
    [self.peripheral readValueForCharacteristic:self.rxCountCharacteristic];
}*/

-(void) updateRx{
    
    [self.peripheral readValueForCharacteristic:self.rxCharacteristic];
}

-(void) updateTx{
    
    [self.peripheral readValueForCharacteristic:self.txCharacteristic];
}

-(void) updateCharacteristic:(CBCharacteristic*) characteristic{
    [self.peripheral readValueForCharacteristic:characteristic];
}

- (NSString*) tx {
	if (self.txCharacteristic) {
        
        return [BLEHelper DataToString:self.txCharacteristic.value];
    }
    
    return nil;
}

- (NSString*) rx {
	if (self.rxCharacteristic) {
                 
        return [BLEHelper DataToString:self.rxCharacteristic.value];
    }
    
    return nil;
}

/*
- (NSInteger) rxCount {
    
    NSInteger result  = NAN;
    int16_t value	= 0;
	
    if (self.rxCountCharacteristic) {
        NSData * data = [self.rxCountCharacteristic value];
        [data getBytes:&value length:sizeof (value)];
        result = value;
    }
    return result;
}

- (NSInteger) rxClear {
    
    NSInteger result  = NAN;
    int16_t value	= 0;
	
    if (self.rxClearCharacteristic) {
        NSData * data = [self.rxClearCharacteristic value];
        [data getBytes:&value length:sizeof (value)];
        result = value;
    }
    return result;
}*/

-(NSString*) characteristicNameFor:(CBCharacteristic*) characteristic{
    
    if(characteristic == self.rxCharacteristic) {
        return @"RX";
    } else if(characteristic == self.txCharacteristic){
        return @"TX";
    }
    
    /*
    if(characteristic == self.bdCharacteristic) {
        return @"BD";
    } else if(characteristic == self.rxCharacteristic) {
        return @"RX";
    } else if(characteristic == self.txCharacteristic){
        return @"TX";
    } else if(characteristic == self.rxClearCharacteristic){
        return @"RX Clear";
    } else if(characteristic == self.rxCountCharacteristic){
        return @"RX Count";
    }*/
    
    return @"Unknown";
}

-(void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if(characteristic == self.txCharacteristic){
        
        Byte * data;
        NSInteger length = [BLEHelper Data:characteristic.value toArray:&data];
        for (int i = 0 ; i < length; i++) {
            int value = data[i];
            printf("%d ",value);
        }
        printf("\n");
    }
}

-(NSInteger) receiveBufferSize{
    
    if(receiveDataCurrentIndex > receiveDataStart){
        return receiveDataCurrentIndex - receiveDataStart;
    } else {
        return RECEIVE_BUFFER_SIZE - receiveDataStart + receiveDataCurrentIndex;
    }
    
}

-(NSData*) checkCRCAndNotify:(NSData*) data{
    
    for (int i = 0; i < data.length; i++) {
        
        uint8_t byte = ((uint8_t*)data.bytes)[i];
        
        if(parsingState == BLEReceiveBufferStateNormal){
            
            receiveDataLength = 0;
            receiveDataCount = 0;
            
            if(byte == kBleCrcStart){
                
                
                parsingState = BLEReceiveBufferStateParsingLength;
            }
            
        } else if(parsingState == BLEReceiveBufferStateParsingLength){
            
            receiveDataLength = byte;
            
            parsingState = BLEReceiveBufferStateParsingData;
            
        } else if(parsingState == BLEReceiveBufferStateParsingData){
            
            receiveBuffer[receiveDataCount++] = byte;

            if(receiveDataCount == receiveDataLength){
                
                parsingState = BLEReceiveBufferStateParsingCrc1;
            }
            
        } else if(parsingState == BLEReceiveBufferStateParsingCrc1){
            
            firstCrcByte = byte;
            parsingState = BLEReceiveBufferStateParsingCrc2;
            
        } else if(parsingState == BLEReceiveBufferStateParsingCrc2){
            
            secondCrcByte = byte;
            
            uint16_t crc = (firstCrcByte << 8) + secondCrcByte;
            
            uint8_t bytesWithLength[data.length+1];
            bytesWithLength[0] = receiveDataLength;
            memcpy(bytesWithLength+1, receiveBuffer, receiveDataLength);
            
            uint16_t myCrc = [self calculateCRCForBytes:bytesWithLength count:receiveDataLength+1];

            if(crc == myCrc){
                [self.dataDelegate didReceiveData:receiveBuffer lenght:receiveDataLength];
            }
            
            parsingState = BLEReceiveBufferStateNormal;
        }
    }
    
    return [NSData dataWithBytes:receiveBuffer length:receiveDataLength];
}

- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
	if (peripheral != _peripheral) {
		NSLog(@"Wrong peripheral\n");
		return;
	}

    if ([error code] != 0) {
		NSLog(@"Error %@\n", error);
		return ;
	}
    
    if(characteristic == self.rxCharacteristic){
        
        
        /*
        printf("receiving:\n");
        for (int i = 0 ; i < length; i++) {
            int value = data[i];
            printf("%X ",value);
        }
        printf("\n");*/
        
        if(self.shouldUseCRC){
            
            [self checkCRCAndNotify:characteristic.value];
            
        } else{
            
            uint8_t * data;
            NSInteger length = [BLEHelper Data:characteristic.value toArray:&data];
            [self.dataDelegate didReceiveData:data lenght:length];
        }

    } else {
        
        if([self.dataDelegate respondsToSelector:@selector(updatedValueForCharacteristic:)]){
            [self.dataDelegate updatedValueForCharacteristic:characteristic];
        }
    }
    
}

-(NSString*) description{
    return @"BLEService";
}

@end
