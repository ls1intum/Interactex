#import "LeDiscovery.h"


@implementation LeDiscovery

#pragma mark Init

+ (id) sharedInstance {
	static LeDiscovery * this = nil;

	if (!this)
		this = [[LeDiscovery alloc] init];

	return this;
}


- (id) init {
    self = [super init];
    if (self) {
		pendingInit = YES;
		centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];

		_foundPeripherals = [[NSMutableArray alloc] init];
		_connectedServices = [[NSMutableArray alloc] init];
	}
    return self;
}

#pragma mark Restoring

- (void) loadSavedDevices {
	NSArray	*storedDevices	= [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];

	if (![storedDevices isKindOfClass:[NSArray class]]) {
        NSLog(@"No stored array to load");
        return;
    }
     
    for (id deviceUUIDString in storedDevices) {
        
        if (![deviceUUIDString isKindOfClass:[NSString class]])
            continue;
        
        CFUUIDRef uuid = CFUUIDCreateFromString(NULL, (CFStringRef)deviceUUIDString);
        if (!uuid)
            continue;
        
        [centralManager retrievePeripherals:[NSArray arrayWithObject:(__bridge id)uuid]];
        CFRelease(uuid);
    }
}

- (void) addSavedDevice:(CFUUIDRef) uuid {
	NSArray			*storedDevices	= [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
	NSMutableArray	*newDevices		= nil;
	CFStringRef		uuidString		= NULL;

	if (![storedDevices isKindOfClass:[NSArray class]]) {
        NSLog(@"Can't find/create an array to store the uuid");
        return;
    }

    newDevices = [NSMutableArray arrayWithArray:storedDevices];
    
    uuidString = CFUUIDCreateString(NULL, uuid);
    if (uuidString) {
        [newDevices addObject:(__bridge NSString*)uuidString];
        CFRelease(uuidString);
    }
    /* Store */
    [[NSUserDefaults standardUserDefaults] setObject:newDevices forKey:@"StoredDevices"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) removeSavedDevice:(CFUUIDRef) uuid {
	NSArray			*storedDevices	= [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
	NSMutableArray	*newDevices		= nil;
	CFStringRef		uuidString		= NULL;

	if ([storedDevices isKindOfClass:[NSArray class]]) {
		newDevices = [NSMutableArray arrayWithArray:storedDevices];

		uuidString = CFUUIDCreateString(NULL, uuid);
		if (uuidString) {
			[newDevices removeObject:(__bridge NSString*)uuidString];
            CFRelease(uuidString);
        }
		/* Store */
		[[NSUserDefaults standardUserDefaults] setObject:newDevices forKey:@"StoredDevices"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void) centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals {
	CBPeripheral * peripheral;
	
	for (peripheral in peripherals) {
		[central connectPeripheral:peripheral options:nil];
	}
	[_discoveryDelegate discoveryDidRefresh];
}


- (void) centralManager:(CBCentralManager *)central didRetrievePeripheral:(CBPeripheral *)peripheral {
	[central connectPeripheral:peripheral options:nil];
	[_discoveryDelegate discoveryDidRefresh];
}


- (void) centralManager:(CBCentralManager *)central didFailToRetrievePeripheralForUUID:(CFUUIDRef)UUID error:(NSError *)error {

	[self removeSavedDevice:UUID];
}

#pragma mark Discovery

- (void) startScanningForUUIDString:(NSString *)uuidString {
	NSArray			*uuidArray	= [NSArray arrayWithObjects:[CBUUID UUIDWithString:uuidString], nil];
	NSDictionary	*options	= [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];

	[centralManager scanForPeripheralsWithServices:uuidArray options:options];

}


- (void) stopScanning {
	[centralManager stopScan];
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
	if (![_foundPeripherals containsObject:peripheral]) {
		[_foundPeripherals addObject:peripheral];
        [self.discoveryDelegate peripheralDiscovered:peripheral];
	}
}


#pragma mark Connection/Disconnection

- (void) connectPeripheral:(CBPeripheral*)peripheral {
	if (![peripheral isConnected]) {
		[centralManager connectPeripheral:peripheral options:nil];
	}
}

- (void) disconnectPeripheral:(CBPeripheral*)peripheral {
	[centralManager cancelPeripheralConnection:peripheral];
}

- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
	BleService	*service	= nil;
	
	service = [[BleService alloc] initWithPeripheral:peripheral];
	[service start];

	if (![_connectedServices containsObject:service])
		[_connectedServices addObject:service];

	if ([_foundPeripherals containsObject:peripheral])
		[_foundPeripherals removeObject:peripheral];

    [_peripheralDelegate bleServiceDidConnect:service];
}

- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Attempted connection to peripheral %@ failed: %@", [peripheral name], [error localizedDescription]);
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
	BleService	*service = nil;

	for (service in _connectedServices) {
		if (service.peripheral == peripheral) {
			[_connectedServices removeObject:service];
            [_peripheralDelegate bleServiceDidDisconnect:service];
			break;
		}
	}

	[_discoveryDelegate discoveryDidRefresh];
}

- (void) clearDevices {
    BleService	*service;
    [_foundPeripherals removeAllObjects];
    
    for (service in _connectedServices) {
        [service reset];
    }
    [_connectedServices removeAllObjects];
}


- (void) centralManagerDidUpdateState:(CBCentralManager *)central {
    static CBCentralManagerState previousState = -1;
    
    NSLog(@"new state: %d",central.state);
    
	switch ([centralManager state]) {
		case CBCentralManagerStatePoweredOff:
		{
            [self clearDevices];
            [_discoveryDelegate discoveryDidRefresh];
            
            if (previousState != -1) {
                [_discoveryDelegate discoveryStatePoweredOff];
            }
			break;
		}
            
		case CBCentralManagerStateUnauthorized: {
			break;
		}
            
		case CBCentralManagerStateUnknown: {
			break;
		}
            
		case CBCentralManagerStatePoweredOn: {
			pendingInit = NO;
			[self loadSavedDevices];
			[centralManager retrieveConnectedPeripherals];
			[_discoveryDelegate discoveryDidRefresh];
			break;
		}
            
		case CBCentralManagerStateResetting: {
			[self clearDevices];
            [_discoveryDelegate discoveryDidRefresh];
            [_peripheralDelegate bleServiceDidReset];
            
			pendingInit = YES;
			break;
		}
        default:
            break;
	}
    
    previousState = [centralManager state];
}
@end
