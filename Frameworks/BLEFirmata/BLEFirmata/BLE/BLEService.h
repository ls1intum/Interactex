#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


#define SEND_BUFFER_SIZE 512
#define RECEIVE_BUFFER_SIZE 512
#define TX_BUFFER_SIZE 16


#define kBleNumSupportedServices 2

extern NSString * const kBleSupportedServices[kBleNumSupportedServices];
extern NSString * const kBleCharacteristics[kBleNumSupportedServices][2];

/*
extern NSString *kBleServiceUUIDString;
extern NSString *kRxCharacteristicUUIDString;
extern NSString *kRxCountCharacteristicUUIDString; 
extern NSString *kRxClearCharacteristicUUIDString;
extern NSString *kTxCharacteristicUUIDString;

extern NSString *kBleServiceEnteredBackgroundNotification;
extern NSString *kBleServiceEnteredForegroundNotification;
*/

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
-(void) dataReceived:(Byte*) buffer lenght:(NSInteger) length;

@optional
-(void) bleServiceIsReady:(BLEService *)service;
-(void) updatedValueForCharacteristic:(CBCharacteristic *)characteristic;
@end

typedef enum{
    BLEReceiveBufferStateNormal,
    BLEReceiveBufferStateParsingLength,
    BLEReceiveBufferStateParsingData,
    BLEReceiveBufferStateParsingCrc1,
    BLEReceiveBufferStateParsingCrc2
} BLEReceiveBufferState;

@interface BLEService : NSObject <CBPeripheralDelegate> {
    CBService			*bleService;
    
    /*
    //CBUUID              *bdUUID;
    CBUUID              *rxUUID;
    CBUUID              *rxCountUUID;
    CBUUID              *rxClearUUID;
    CBUUID              *txUUID;
    */
     
    NSTimer * timer;
    
    uint8_t sendBuffer[SEND_BUFFER_SIZE];
    
    uint8_t receiveBuffer[RECEIVE_BUFFER_SIZE];
    
    int receiveDataStart;
    int receiveDataCurrentIndex;
    
    int receiveDataCount;
    int receiveDataLength;
    
    uint8_t firstCrcByte;
    uint8_t secondCrcByte;
    BLEReceiveBufferState parsingState;
    
    int sendBufferStart;
    int sendBufferCount;
    NSTimeInterval lastTimeFlushed;
    
}

@property (nonatomic, readonly) CBCharacteristic * rxCharacteristic;
@property (nonatomic, readonly) CBCharacteristic * txCharacteristic;

@property (nonatomic, readonly) CBUUID* uuid;

@property (nonatomic, readonly) NSString* tx;
@property (nonatomic, readonly) NSString* rx;

@property (nonatomic) NSArray * currentCharacteristicUUIDs;

@property (nonatomic, readonly) CBPeripheral *peripheral;
@property (nonatomic) id<BLEServiceDelegate> delegate;
@property (nonatomic) id<BLEServiceDataDelegate> dataDelegate;

+(NSMutableArray*) supportedServiceUUIDs;
+(NSMutableArray*) supportedCharacteristicUUIDs;

-(NSString*) characteristicNameFor:(CBCharacteristic*) characteristic;

-(id) initWithPeripheral:(CBPeripheral *)peripheral;
-(void) start;
-(void) reset;
-(void) disconnect;

-(void) enteredBackground;
-(void) enteredForeground;

-(void) sendData:(uint8_t*) bytes count:(NSInteger) count;
-(void) sendDataWithCRC:(uint8_t*) bytes count:(NSInteger) count;
-(void) flushData;

-(void) updateRx;
-(void) updateTx;
-(void) updateCharacteristic:(CBCharacteristic*) characteristic;

-(void) writeToTx:(NSData*) data;

@end
