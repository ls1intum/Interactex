
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "BLEService.h"

@protocol BLEDiscoveryDelegate <NSObject>
- (void) discoveryDidRefresh;
- (void) discoveryStatePoweredOff;
- (void) peripheralDiscovered:(CBPeripheral*) peripheral;
@end


@interface BLEDiscovery : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
{
	CBCentralManager    *centralManager;
	BOOL				pendingInit;
}

+(instancetype) sharedInstance;

-(void) startScanningForUUIDString:(NSString *)uuidString;
-(void) stopScanning;

-(void) connectPeripheral:(CBPeripheral*)peripheral;
-(void) disconnectCurrentPeripheral;

@property (nonatomic, weak) id<BLEDiscoveryDelegate>  discoveryDelegate;
@property (nonatomic, weak) id<BLEServiceDelegate> peripheralDelegate;

@property (nonatomic, strong) NSMutableArray * foundPeripherals;
@property (nonatomic, readonly) BLEService * connectedService;
@property (nonatomic, readonly) CBPeripheral * currentPeripheral;

@end
