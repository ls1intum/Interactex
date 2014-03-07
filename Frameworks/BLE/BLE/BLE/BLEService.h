/*
 BLEService.h
 BLE
 
 Created by Juan Haladjian on 11/06/2013.
 
 BLE is a library used to send and receive data from/to a device over Bluetooth 4.0.
 
 www.interactex.org
 
 Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
 
 Contacts:
 juan.haladjian@cs.tum.edu
 katharina.bredies@udk-berlin.de
 opensource@telekom.de
 
 
 It has been created with funding from EIT ICT, as part of the activity "Connected Textiles".
 
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


#define SEND_BUFFER_SIZE 512
#define RECEIVE_BUFFER_SIZE 512
#define TX_BUFFER_SIZE 16


#define kBleNumSupportedServices 3

extern NSString * const kBleSupportedServices[kBleNumSupportedServices];
extern NSString * const kBleCharacteristics[kBleNumSupportedServices][2];

extern const NSTimeInterval kFlushInterval;

@class BLEService;

@protocol BLEServiceDelegate<NSObject>

@required
-(void) bleServiceDidConnect:(BLEService*)service;
-(void) bleServiceDidDisconnect:(BLEService*)service;

@optional
-(void) bleServiceIsReady:(BLEService *)service;
-(void) bleServiceDidReset;
-(void) reportMessage:(NSString*) message;
@end

@protocol BLEServiceDataDelegate<NSObject>

@required
-(void) didReceiveData:(uint8_t *)buffer lenght:(NSInteger)originalLength;

@optional
-(void) bleServiceIsReady:(BLEService *)service;
-(void) updatedValueForCharacteristic:(CBCharacteristic *)characteristic;
@end

typedef enum{
    kBleDeviceTypeKroll,
    kBleDeviceTypeJennic,
    kBleDeviceTypeRedBearLab,
} BLEDeviceType;

@interface BLEService : NSObject <CBPeripheralDelegate> {
    CBService			*bleService;
    
    NSTimer * timer;
    //NSTimer * sendOverTimer;

    uint8_t sendBuffer[SEND_BUFFER_SIZE];
    uint8_t receiveBuffer[SEND_BUFFER_SIZE];
    
    int sendBufferStart;
    int sendBufferCount;
    NSTimeInterval lastTimeFlushed;
    BOOL shouldSend;
    
    int receiveDataStart;
    int receiveDataCurrentIndex;
    int receiveDataCount;
    int receiveDataLength;
    
    BOOL overBit;
    
}

@property (nonatomic, strong) CBCharacteristic * rxCharacteristic;
@property (nonatomic, strong) CBCharacteristic * txCharacteristic;

@property (nonatomic, readonly) CBUUID * uuid;

@property (nonatomic, readonly) NSString * txString;
@property (nonatomic, readonly) NSString * rxString;

@property (nonatomic) NSArray * currentCharacteristicUUIDs;

@property (nonatomic, readonly) CBPeripheral * peripheral;
@property (nonatomic) id<BLEServiceDelegate> delegate;
@property (nonatomic) id<BLEServiceDataDelegate> dataDelegate;

@property (nonatomic) BLEDeviceType deviceType;

-(NSString*) characteristicNameFor:(CBCharacteristic*) characteristic;
-(id) initWithPeripheral:(CBPeripheral *)peripheral;

-(void) start;
-(void) stop;

-(void) enteredBackground;
-(void) enteredForeground;

-(void) sendData:(const uint8_t*) bytes count:(NSInteger) count;
-(void) flushData;

-(void) updateRx;
-(void) updateTx;
-(void) updateCharacteristic:(CBCharacteristic*) characteristic;

-(void) writeToTx:(NSData*) data;

@end
