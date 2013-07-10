#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


extern NSString *kBleServiceUUIDString;
extern NSString *kRxCharacteristicUUIDString;
extern NSString *kRxCountCharacteristicUUIDString; 
extern NSString *kRxClearCharacteristicUUIDString;
extern NSString *kTxCharacteristicUUIDString;

extern NSString *kBleServiceEnteredBackgroundNotification;
extern NSString *kBleServiceEnteredForegroundNotification;

extern const short kMsgPinModeStarted;
extern const short kMsgPinValueStarted;

@class BLEService;

@protocol BLEServiceDelegate<NSObject>

@optional
-(void) bleServiceDidConnect:(BLEService*)service;
-(void) bleServiceDidDisconnect:(BLEService*)service;
-(void) bleServiceIsReady:(BLEService *)service;
-(void) bleServiceDidReset;
-(void) dataReceived:(Byte*) buffer lenght:(NSInteger) length;
-(void) reportMessage:(NSString*) message;
@end

typedef enum{
    kBleServiceStateMode,
    kBleServiceStateValues
}THBleServiceState ;

@interface BLEService : NSObject <CBPeripheralDelegate> {
    CBService			*bleService;
    
    CBUUID              *bdUUID;
    CBUUID              *rxUUID;
    CBUUID              *rxCountUUID;
    CBUUID              *rxClearUUID;
    CBUUID              *txUUID;
    
}

-(id) initWithPeripheral:(CBPeripheral *)peripheral;
-(void) reset;
-(void) start;
-(void) disconnect;

-(void)enteredBackground;
-(void)enteredForeground;

-(void) clearRx;
-(void) writeToTx:(NSData*) data;


@property (nonatomic, readonly) CBCharacteristic * bdCharacteristic;
@property (nonatomic, readonly) CBCharacteristic * rxCharacteristic;
@property (nonatomic, readonly) CBCharacteristic * rxCountCharacteristic;
@property (nonatomic, readonly) CBCharacteristic * rxClearCharacteristic;
@property (nonatomic, readonly) CBCharacteristic * txCharacteristic;

@property (nonatomic, readonly) NSString* tx;
@property (nonatomic, readonly) NSString* rx;
@property (nonatomic, readonly) NSInteger rxCount;

@property (nonatomic, readonly) CBPeripheral *peripheral;
@property (nonatomic) id<BLEServiceDelegate> delegate;
@property (nonatomic) THBleServiceState state;

-(NSString*) characteristicNameFor:(CBCharacteristic*) characteristic;

@end
