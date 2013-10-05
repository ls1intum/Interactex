/*
BleService.m
Interactex Designer

Created by Juan Haladjian on 05/10/2013.

Interactex Designer is a configuration tool to easily setup, simulate and connect e-Textile hardware with smartphone functionality. Interactex Client is an app to store and replay projects made with Interactex Designer.

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
The first version of the software was designed and implemented as part of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was founded by Telekom Innovation Laboratories Berlin. It has been extended with funding from EIT ICT, as part of the activity "Connected Textiles".

Interactex is built using the Tango framework developed by TU Munich.

In the Interactex software, we use the GHUnit (a test framework for iOS developed by Gabriel Handford) and cocos2D libraries (a framework for building 2D games and graphical applications developed by Zynga Inc.). 
www.cocos2d-iphone.org
github.com/gabriel/gh-unit

Interactex also implements the Firmata protocol. Its software serial library is based on the original Arduino Firmata library.
www.firmata.org

All hardware part graphics in Interactex Designer are reproduced with kind permission from Fritzing. Fritzing is an open-source hardware initiative to support designers, artists, researchers and hobbyists to work creatively with interactive electronics.
www.frizting.org


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

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
            
            [self.delegate reportMessage:@"Discovered BD"];
			bdCharacteristic = characteristic;
			[peripheral readValueForCharacteristic:bdCharacteristic];
        } else if ([[characteristic UUID] isEqual:rxUUID]) {
            [self.delegate reportMessage:@"Discovered RX"];
			rxCharacteristic = characteristic;
			[peripheral readValueForCharacteristic:rxCharacteristic];
			[peripheral setNotifyValue:YES forCharacteristic:rxCharacteristic];
		} else if ([[characteristic UUID] isEqual:rxCountUUID]) {
            [self.delegate reportMessage:@"Discovered RX Count"];
			rxCountCharacteristic = characteristic ;
			[peripheral readValueForCharacteristic:characteristic];
        } else if ([[characteristic UUID] isEqual:rxClearUUID]) {
            [self.delegate reportMessage:@"Discovered RX Clear"];
			rxClearCharacteristic = characteristic;
		} else if ([[characteristic UUID] isEqual:txUUID]) {
            [self.delegate reportMessage:@"Discovered TX"];
			txCharacteristic = characteristic;
            [self.delegate bleServiceIsReady:self];
		} else {
            NSString * message = [NSString stringWithFormat:@"Discovered: %@",characteristic.UUID];
            [self.delegate reportMessage:message];
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
        [self.delegate reportMessage:@"Trying to output pin but not connected to a pheripheral"];
		return ;
    }
    
    NSData * data1 = [NSData dataWithBytes:&pin length:1];
    NSData * data2 = [NSData dataWithBytes:&value length:1];
    
    [_peripheral writeValue:data1 forCharacteristic:txCharacteristic type:CBCharacteristicWriteWithResponse];
    [_peripheral writeValue:data2 forCharacteristic:txCharacteristic type:CBCharacteristicWriteWithResponse];
    
    
    NSString * message = [NSString stringWithFormat:@"%d %d sent!",pin,value];
    [self.delegate reportMessage:message];
    
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
        
        for (int i = 0 ; i < length; i++) {
            string = [string stringByAppendingFormat:@" %d",data[i]];
        }
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
