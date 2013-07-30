
#import "BLEService.h"
#import "BLEDiscovery.h"
#import "BLEPinModeDescriptor.h"
#import "BLEHelper.h"

NSString *kBleServiceUUIDString = @"F9266FD7-EF07-45D6-8EB6-BD74F13620F9";//Juan
//NSString *kBleServiceUUIDString = @"EF080D8C-C3BE-41FF-BD3F-05A5F4795D7F";//Vincent

NSString *kRxCharacteristicUUIDString = @"4585C102-7784-40B4-88E1-3CB5C4FD37A3";
NSString *kRxCountCharacteristicUUIDString = @"11846C20-6630-11E1-B86C-0800200C9A66";
NSString *kRxClearCharacteristicUUIDString = @"DAF75440-6EBA-11E1-B0C4-0800200C9A66";
NSString *kTxCharacteristicUUIDString = @"E788D73B-E793-4D9E-A608-2F2BAFC59A00";
NSString *kBdCharacteristicUUIDString = @"38117F3C-28AB-4718-AB95-172B363F2AE0";

NSString *kBleServiceEnteredBackgroundNotification = @"kAlarmServiceEnteredBackgroundNotification";
NSString *kBleServiceEnteredForegroundNotification = @"kAlarmServiceEnteredForegroundNotification";

const NSTimeInterval kFlushInterval = 1.0f/5.0f;

@implementation BLEService

#pragma mark Init

- (id) initWithPeripheral:(CBPeripheral *)peripheral {
    self = [super init];
    if (self) {
        _peripheral = peripheral;
        [self.peripheral setDelegate:self];
        
        rxCountUUID	= [CBUUID UUIDWithString:kRxCountCharacteristicUUIDString];
        rxClearUUID	= [CBUUID UUIDWithString:kRxClearCharacteristicUUIDString];
        rxUUID	= [CBUUID UUIDWithString:kRxCharacteristicUUIDString];
        txUUID	= [CBUUID UUIDWithString:kTxCharacteristicUUIDString];
        bdUUID	= [CBUUID UUIDWithString:kBdCharacteristicUUIDString];
        
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


- (void) reset {
	if (self.peripheral) {
		_peripheral = nil;
	}
}

#pragma mark Service interaction

- (void) start {
	CBUUID	*serviceUUID	= [CBUUID UUIDWithString:kBleServiceUUIDString];
	NSArray	*serviceArray	= [NSArray arrayWithObjects:serviceUUID, nil];

    [_peripheral discoverServices:serviceArray];
    
}

- (void) disconnect {
    [[BLEDiscovery sharedInstance] disconnectCurrentPeripheral];
    
    sendBufferCount = 0;
    sendBufferStart = 0;
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
	NSArray		*services	= nil;
	NSArray		*uuids	= [NSArray arrayWithObjects:rxUUID,
								   rxCountUUID,
								   rxClearUUID,
								   txUUID,
								   nil];

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
		if ([[service UUID] isEqual:[CBUUID UUIDWithString:kBleServiceUUIDString]]) {
			bleService = service;
			break;
		}
	}

	if (bleService) {
		[peripheral discoverCharacteristics:uuids forService:bleService];
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
            [self.delegate bleServiceIsReady:self];
		} else {
            //NSString * message = [NSString stringWithFormat:@"Discovered: %@",characteristic.UUID];
            //[self.delegate reportMessage:message];
        }
	}
}

#pragma mark Characteristics interaction

-(void) clearRx{
    if(self.peripheral.isConnected){
        short byte = 1;
        NSData * data = [NSData dataWithBytes:&byte length:1];
        [_peripheral writeValue:data forCharacteristic:self.rxClearCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(void) writeToTx:(NSData*) data{
    
    if(self.txCharacteristic){
        //without response does not work with BLE Shield
        [_peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
        
        /*
        for (int i = 0; i < data.length; i++) {
            printf("%d ",(int)((char*)data.bytes)[i]);
        }
        printf("\n");*/
        
    }
}

-(void) sendData:(uint8_t*) bytes count:(NSInteger) count{
    /*
    NSData * data = [NSData dataWithBytes:bytes length:count];
    [self writeToTx:data];*/
    
    
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
    // Find the fishtank service
    for (CBService *service in [_peripheral services]) {
        if ([[service UUID] isEqual:[CBUUID UUIDWithString:kBleServiceUUIDString]]) {
            
            // Find the temperature characteristic
            for (CBCharacteristic *characteristic in [service characteristics]) {
                if ( [[characteristic UUID] isEqual:[CBUUID UUIDWithString:kRxCharacteristicUUIDString]] ) {
                    
                    // And STOP getting notifications from it
                    [_peripheral setNotifyValue:NO forCharacteristic:characteristic];
                }
            }
        }
    }
}

/** Coming back from the background, we want to register for notifications again for the temperature changes */
- (void)enteredForeground
{
    // Find the fishtank service
    for (CBService *service in _peripheral.services) {
        if ([[service UUID] isEqual:[CBUUID UUIDWithString:kBleServiceUUIDString]]) {
            
            // Find the temperature characteristic
            for (CBCharacteristic *characteristic in [service characteristics]) {
                if ( [[characteristic UUID] isEqual:[CBUUID UUIDWithString:kRxCharacteristicUUIDString]] ) {
                    
                    // And START getting notifications from it
                    [_peripheral setNotifyValue:YES forCharacteristic:characteristic];
                }
            }
        }
    }
}

- (NSInteger) rxCount {
    
    [self.peripheral readValueForCharacteristic:self.rxCountCharacteristic];
    
    NSInteger result  = NAN;
    int16_t value	= 0;
	
    if (self.rxCountCharacteristic) {
        NSData * data = [self.rxCountCharacteristic value];
        [data getBytes:&value length:sizeof (value)];
        result = value;
    }
    return result;
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

-(NSString*) characteristicNameFor:(CBCharacteristic*) characteristic{
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
    }
    return @"Unknown";
}

-(void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if(characteristic == self.rxClearCharacteristic){
        NSLog(@"cleared RX");
    } else if(characteristic == self.txCharacteristic){
        
        //NSLog(@"wrote to TX:");
        Byte * data;
        NSInteger length = [BLEHelper Data:characteristic.value toArray:&data];
        for (int i = 0 ; i < length; i++) {
            int value = data[i];
            printf("%d ",value);
        }
        printf("\n");
    }
}

- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
	if (peripheral != _peripheral) {
		NSLog(@"Wrong peripheral\n");
		return ;
	}

    if ([error code] != 0) {
		NSLog(@"Error %@\n", error);
		return ;
	}

    //NSLog(@"characteristic %@ updated value",characteristic);
    
    if(characteristic == self.rxCharacteristic){
        
        Byte * data;
        NSInteger length = [BLEHelper Data:characteristic.value toArray:&data];
        [self.dataDelegate dataReceived:data lenght:length];
    }
}

-(NSString*) description{
    return @"BLEService";
}
@end
