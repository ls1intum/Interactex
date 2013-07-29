#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


#define SEND_BUFFER_SIZE 512
#define TX_BUFFER_SIZE 16

extern NSString *kBleServiceUUIDString;
extern NSString *kRxCharacteristicUUIDString;
extern NSString *kRxCountCharacteristicUUIDString; 
extern NSString *kRxClearCharacteristicUUIDString;
extern NSString *kTxCharacteristicUUIDString;

extern NSString *kBleServiceEnteredBackgroundNotification;
extern NSString *kBleServiceEnteredForegroundNotification;

extern const short kMsgPinModeStarted;
extern const short kMsgPinValueStarted;
extern const NSTimeInterval kFlushInterval;

@class BLEService;

@protocol BLEServiceDelegate<NSObject>

@optional
-(void) bleServiceDidConnect:(BLEService*)service;
-(void) bleServiceDidDisconnect:(BLEService*)service;
-(void) bleServiceIsReady:(BLEService *)service;
-(void) bleServiceDidReset;
-(void) reportMessage:(NSString*) message;
@end

@protocol BLEServiceDataDelegate<NSObject>

-(void) dataReceived:(Byte*) buffer lenght:(NSInteger) length;
@end


@interface BLEService : NSObject <CBPeripheralDelegate> {
    CBService			*bleService;
    
    CBUUID              *bdUUID;
    CBUUID              *rxUUID;
    CBUUID              *rxCountUUID;
    CBUUID              *rxClearUUID;
    CBUUID              *txUUID;
    
    NSTimer * timer;
    char sendBuffer[SEND_BUFFER_SIZE];
    int sendBufferStart;
    int sendBufferCount;
    NSTimeInterval lastTimeFlushed;
}

-(id) initWithPeripheral:(CBPeripheral *)peripheral;
-(void) reset;
-(void) start;
-(void) disconnect;

-(void)enteredBackground;
-(void)enteredForeground;

-(void) clearRx;

-(void) sendData:(uint8_t*) bytes count:(NSInteger) count;
-(void) flushData;

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
@property (nonatomic) id<BLEServiceDataDelegate> dataDelegate;

-(NSString*) characteristicNameFor:(CBCharacteristic*) characteristic;

@end
