
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "BleService.h"


@protocol LeDiscoveryDelegate <NSObject>
- (void) discoveryDidRefresh;
- (void) discoveryStatePoweredOff;
- (void) peripheralDiscovered:(CBPeripheral*) peripheral;
@end


@interface LeDiscovery : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
{
	CBCentralManager    *centralManager;
	BOOL				pendingInit;
}

+ (id) sharedInstance;

- (void) startScanningForUUIDString:(NSString *)uuidString;
- (void) stopScanning;

- (void) connectPeripheral:(CBPeripheral*)peripheral;
- (void) disconnectPeripheral:(CBPeripheral*)peripheral;


@property (nonatomic, assign) id<LeDiscoveryDelegate>  discoveryDelegate;
@property (nonatomic, assign) id<BleServiceDelegate> peripheralDelegate;

@property (retain, nonatomic) NSMutableArray * foundPeripherals;
@property (retain, nonatomic) NSMutableArray * connectedServices;
@end
