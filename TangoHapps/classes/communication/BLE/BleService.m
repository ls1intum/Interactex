
#import "BleService.h"
#import "LeDiscovery.h"
#import "THPinModeDescriptor.h"

NSString *kBleServiceUUIDString = @"F9266FD7-EF07-45D6-8EB6-BD74F13620F9";//Juan
//NSString *kBleServiceUUIDString = @"EF080D8C-C3BE-41FF-BD3F-05A5F4795D7F";//Vincent

NSString *kRxCharacteristicUUIDString = @"4585C102-7784-40B4-88E1-3CB5C4FD37A3";
NSString *kRxCountCharacteristicUUIDString = @"11846C20-6630-11E1-B86C-0800200C9A66";
NSString *kRxClearCharacteristicUUIDString = @"DAF75440-6EBA-11E1-B0C4-0800200C9A66";
NSString *kTxCharacteristicUUIDString = @"E788D73B-E793-4D9E-A608-2F2BAFC59A00";
NSString *kBdCharacteristicUUIDString = @"38117F3C-28AB-4718-AB95-172B363F2AE0";

NSString *kBleServiceEnteredBackgroundNotification = @"kAlarmServiceEnteredBackgroundNotification";
NSString *kBleServiceEnteredForegroundNotification = @"kAlarmServiceEnteredForegroundNotification";

const short kMsgPinModeStarted = 255;
const short kMsgPinValueStarted = 254;

@implementation BleService

#pragma mark Init

- (id) initWithPeripheral:(CBPeripheral *)peripheral {
    self = [super init];
    if (self) {
        _peripheral = peripheral;
        [_peripheral setDelegate:self];
        
        rxCountUUID	= [CBUUID UUIDWithString:kRxCountCharacteristicUUIDString];
        rxClearUUID	= [CBUUID UUIDWithString:kRxClearCharacteristicUUIDString];
        rxUUID	= [CBUUID UUIDWithString:kRxCharacteristicUUIDString];
        txUUID	= [CBUUID UUIDWithString:kTxCharacteristicUUIDString];
        bdUUID	= [CBUUID UUIDWithString:kBdCharacteristicUUIDString];
	}
    return self;
}


- (void) dealloc {
	if (_peripheral) {
		[_peripheral setDelegate:[LeDiscovery sharedInstance]];
		_peripheral = nil;
    }
}


- (void) reset
{
	if (_peripheral) {
		_peripheral = nil;
	}
}

#pragma mark Service interaction

- (void) start
{
	CBUUID	*serviceUUID	= [CBUUID UUIDWithString:kBleServiceUUIDString];
	NSArray	*serviceArray	= [NSArray arrayWithObjects:serviceUUID, nil];

    [_peripheral discoverServices:serviceArray];
}


- (void) disconnect{
    [[LeDiscovery sharedInstance] disconnectPeripheral:self.peripheral];
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
	NSArray		*services	= nil;
	NSArray		*uuids	= [NSArray arrayWithObjects:rxUUID,
								   rxCountUUID,
								   rxClearUUID,
								   txUUID,
								   nil];

	if (peripheral != _peripheral) {
		NSLog(@"Wrong Peripheral.\n");
		return ;
	}
    
    if (error != nil) {
        NSLog(@"Error %@\n", error);
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
		NSLog(@"Wrong Peripheral.\n");
		return ;
	}
	
	if (service != bleService) {
		NSLog(@"Wrong Service.\n");
		return ;
	}
    
    if (error != nil) {
		NSLog(@"Error %@\n", error);
		return ;
	}
    
	for (CBCharacteristic *characteristic in service.characteristics) {
        
        if ([[characteristic UUID] isEqual:bdUUID]) {
            NSLog(@"Discovered BD");
			bdCharacteristic = characteristic;
			[peripheral readValueForCharacteristic:bdCharacteristic];
        } else if ([[characteristic UUID] isEqual:rxUUID]) {
            NSLog(@"Discovered RX");
			rxCharacteristic = characteristic;
			[peripheral readValueForCharacteristic:rxCharacteristic];
			[peripheral setNotifyValue:YES forCharacteristic:rxCharacteristic];
		} else if ([[characteristic UUID] isEqual:rxCountUUID]) {
            NSLog(@"Discovered RX Count");
			rxCountCharacteristic = characteristic ;
			[peripheral readValueForCharacteristic:characteristic];
        } else if ([[characteristic UUID] isEqual:rxClearUUID]) {
            NSLog(@"Discovered RXClear");
			rxClearCharacteristic = characteristic;
		} else if ([[characteristic UUID] isEqual:txUUID]) {
            NSLog(@"Discovered TX");
			txCharacteristic = characteristic;
            [self.delegate bleServiceIsReady:self];
		} else {
            NSLog(@"discovered characteristic %@", characteristic.UUID);
        }
	}
}

#pragma mark Characteristics interaction

-(void) clearRx{
    
    short byte = 1;
    NSData * data = [NSData dataWithBytes:&byte length:1];
    [_peripheral writeValue:data forCharacteristic:rxClearCharacteristic type:CBCharacteristicWriteWithResponse];
}

-(void) sendPinModes:(NSArray*) pinModes{
            
    NSData * startData = [NSData dataWithBytes:&kMsgPinModeStarted length:1];
        [_peripheral writeValue:startData forCharacteristic:txCharacteristic type:CBCharacteristicWriteWithResponse];
    
    for (THPinModeDescriptor * pinDescriptor in pinModes) {
        
        short pin = pinDescriptor.pin;
        short mode = pinDescriptor.mode;
        
        NSData * data1 = [NSData dataWithBytes:&pin length:1];
        NSData * data2 = [NSData dataWithBytes:&mode length:1];
        
        [_peripheral writeValue:data1 forCharacteristic:txCharacteristic type:CBCharacteristicWriteWithResponse];
        [_peripheral writeValue:data2 forCharacteristic:txCharacteristic type:CBCharacteristicWriteWithResponse];
    }
    
    //send start
    NSData * endData = [NSData dataWithBytes:&kMsgPinValueStarted length:1];
    [_peripheral writeValue:endData forCharacteristic:txCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (void) outputPin:(NSInteger) pin value:(short)value {    
    if (!_peripheral) {
        NSLog(@"Not connected to a peripheral");
		return ;
    }
    
    NSData * data1 = [NSData dataWithBytes:&pin length:1];
    NSData * data2 = [NSData dataWithBytes:&value length:1];
    
    [_peripheral writeValue:data1 forCharacteristic:txCharacteristic type:CBCharacteristicWriteWithResponse];
    [_peripheral writeValue:data2 forCharacteristic:txCharacteristic type:CBCharacteristicWriteWithResponse];
    
    NSLog(@"%d %d",pin,value);
    
    /*
    short bytes[2] = {pin,value};
    NSData * data1 = [NSData dataWithBytes:&bytes length:2];
    [_peripheral writeValue:data1 forCharacteristic:txCharacteristic type:CBCharacteristicWriteWithResponse];*/
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
    NSInteger result  = NAN;
    int16_t value	= 0;
	
    if (rxCountCharacteristic) {
        NSData * data = [rxCountCharacteristic value];
        [data getBytes:&value length:sizeof (value)];
        result = value;
    }
    return result;
}

- (NSString*) tx {
	if (txCharacteristic) {
        
        Byte * data;
        NSInteger length = [THBluetoothHelper Data:txCharacteristic.value toArray:&data];
        
        NSString * string = @"";
        
        NSLog(@"TX: %d",length);
        
        for (int i = 0 ; i < length; i++) {
            //printf("%d ",data[i]);
            string = [string stringByAppendingFormat:@" %d",data[i]];
        }
        
        printf("\n");
        
        return string;
    }
    
    return nil;
}

- (NSString*) rx {
	if (rxCharacteristic) {
               
        Byte * data;
        NSInteger length = [THBluetoothHelper Data:rxCharacteristic.value toArray:&data];
        
        NSString * string = @"";
        
        NSLog(@"RX: %d",length);
        
        for (int i = 0 ; i < length; i++) {
            string = [string stringByAppendingFormat:@" %d",data[i]];
            //printf("%d ",data[i]);
        }
        //printf("\n");
        return string;
    }
    
    return nil;
}

-(NSString*) characteristicNameFor:(CBCharacteristic*) characteristic{
    if(characteristic == rxCharacteristic) {
        return @"RX";
    } else if(characteristic == txCharacteristic){
        return @"TX";
    } else if(characteristic == rxClearCharacteristic){
        return @"RXClear";
    } else if(characteristic == rxCountCharacteristic){
        return @"RXCount";
    }
    return @"Unknown";
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

    if(characteristic == rxCharacteristic){
        Byte * data;
        NSInteger length = [THBluetoothHelper Data:characteristic.value toArray:&data];
        
        for (int i = 0 ; i < length; i++) {
            
            short value = data[i];
            if(value == 255){
                [self.delegate dataReceived:data lenght:i];
                break;
            }
        }
        
        //NSLog([THBluetoothHelper dataToString:characteristic.value]);
    }
}

- (void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    /* When a write occurs, need to set off a re-read of the local CBCharacteristic to update its value */
    [peripheral readValueForCharacteristic:characteristic];
    
    //NSLog(@"wrote something: %@ %@",characteristic,characteristic.value);
}
@end
