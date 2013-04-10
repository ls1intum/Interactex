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

@class BleService;

@protocol BleServiceDelegate<NSObject>
- (void) bleServiceDidConnect:(BleService*)service;
- (void) bleServiceDidDisconnect:(BleService*)service;
-(void) bleServiceIsReady:(BleService *)service;
- (void) bleServiceDidReset;
//- (void) inputPin:(NSInteger) pin changedTo:(short) value;
- (void) dataReceived:(Byte*) buffer lenght:(NSInteger) length;

@end

typedef enum{
    kBleServiceStateMode,
    kBleServiceStateValues
}THBleServiceState ;

@interface BleService : NSObject <CBPeripheralDelegate> {
    CBService			*bleService;
    
    CBCharacteristic    *rxCharacteristic;
    CBCharacteristic	*rxCountCharacteristic;
    CBCharacteristic    *rxClearCharacteristic;
    CBCharacteristic    *txCharacteristic;
    CBCharacteristic    *bdCharacteristic;
    
    CBUUID              *txUUID;
    CBUUID              *rxCountUUID;
    CBUUID              *rxClearUUID;
    CBUUID              *rxUUID;
    CBUUID              *bdUUID;
    
}

- (id) initWithPeripheral:(CBPeripheral *)peripheral;
- (void) reset;
- (void) start;
-(void) disconnect;

-(void) sendPinModes:(NSArray*) pinModes;
- (void) outputPin:(NSInteger) pin value:(short)value;

- (void)enteredBackground;
- (void)enteredForeground;

- (void) clearRx;

@property (readonly) NSString* tx;
@property (readonly) NSString* rx;
@property (readonly) NSInteger rxCount;

@property (nonatomic, readonly) CBPeripheral *peripheral;
@property (nonatomic) id<BleServiceDelegate> delegate;

@property (nonatomic) THBleServiceState state;

@end
