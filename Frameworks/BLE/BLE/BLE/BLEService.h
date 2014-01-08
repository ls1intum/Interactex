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
    BLEReceiveBufferStateNormal,
    BLEReceiveBufferStateParsingLength,
    BLEReceiveBufferStateParsingData,
    BLEReceiveBufferStateParsingCrc1,
    BLEReceiveBufferStateParsingCrc2
} BLEReceiveBufferState;



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
    
    uint8_t firstCrcByte;
    uint8_t secondCrcByte;
    BLEReceiveBufferState parsingState;
    
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

@property (nonatomic) BOOL shouldUseCRC;
@property (nonatomic) BOOL shouldUseTurnBasedCommunication;

+(NSMutableArray*) supportedServiceUUIDs;
+(NSMutableArray*) supportedCharacteristicUUIDs;

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
