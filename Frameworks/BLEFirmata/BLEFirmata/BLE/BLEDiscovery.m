
#import "BLEDiscovery.h"

@implementation BLEDiscovery

#pragma mark Init

static BLEDiscovery * sharedInstance;

+(BLEDiscovery*) sharedInstance {
    @synchronized(self) {
        if (sharedInstance == NULL)
            sharedInstance = [[self alloc] init];
    }
    
    return(sharedInstance);
}

-(id) init {
    self = [super init];
    if (self) {
		pendingInit = YES;
		centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];

		self.foundPeripherals = [[NSMutableArray alloc] init];
	}
    return self;
}

#pragma mark Restoring

-(void) loadSavedDevices {
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

-(void) addSavedDevice:(CFUUIDRef) uuid {
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

-(void) removeSavedDevice:(CFUUIDRef) uuid {
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

-(void) centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals {
	CBPeripheral * peripheral;
	
	for (peripheral in peripherals) {
		[central connectPeripheral:peripheral options:nil];
	}
	[_discoveryDelegate discoveryDidRefresh];
}


-(void) centralManager:(CBCentralManager *)central didRetrievePeripheral:(CBPeripheral *)peripheral {
	[central connectPeripheral:peripheral options:nil];
	[_discoveryDelegate discoveryDidRefresh];
}


-(void) centralManager:(CBCentralManager *)central didFailToRetrievePeripheralForUUID:(CFUUIDRef)UUID error:(NSError *)error {

	[self removeSavedDevice:UUID];
}

#pragma mark Discovery

-(void) startScanningForAnyUUID{
	NSDictionary	*options	= [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    
	[centralManager scanForPeripheralsWithServices:nil options:options];
}

-(void) startScanningForUUIDString:(NSString *)uuidString {
	NSArray			*uuidArray	= [NSArray arrayWithObjects:[CBUUID UUIDWithString:uuidString], nil];
	NSDictionary	*options	= [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];

	[centralManager scanForPeripheralsWithServices:uuidArray options:options];
}

-(void) stopScanning {
	[centralManager stopScan];
}


-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
	if (![self.foundPeripherals containsObject:peripheral]) {
		[self.foundPeripherals addObject:peripheral];
        [self.discoveryDelegate peripheralDiscovered:peripheral];
	}
}


#pragma mark Connection/Disconnection

-(void) connectPeripheral:(CBPeripheral*)peripheral {
	if (![peripheral isConnected]) {
        _currentPeripheral = peripheral;
		[centralManager connectPeripheral:peripheral options:nil];
	}
}

-(void) disconnectCurrentPeripheral {
	[centralManager cancelPeripheralConnection:self.currentPeripheral];
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
	_connectedService = [[BLEService alloc] initWithPeripheral:peripheral];
	[_connectedService start];

    [self.peripheralDelegate bleServiceDidConnect:_connectedService];
    _currentPeripheral = peripheral;
}

-(void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Attempted connection to peripheral %@ failed: %@", [peripheral name], [error localizedDescription]);
}

-(void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    [self.peripheralDelegate bleServiceDidDisconnect:self.connectedService];
    
    _connectedService = nil;
    _currentPeripheral = nil;
	[_discoveryDelegate discoveryDidRefresh];
}

-(void) clearDevices {

    [self.foundPeripherals removeAllObjects];
    [self.connectedService reset];
    _connectedService = nil;
}

-(void) centralManagerDidUpdateState:(CBCentralManager *)central {
    static CBCentralManagerState previousState = -1;
    
    NSLog(@"new state: %d",central.state);
    
	switch ([centralManager state]) {
		case CBCentralManagerStatePoweredOff:
		{
            [self clearDevices];
            [self.discoveryDelegate discoveryDidRefresh];
            
            [self.discoveryDelegate discoveryStatePoweredOff];
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
			[self.discoveryDelegate discoveryDidRefresh];
			break;
		}
            
		case CBCentralManagerStateResetting: {
			[self clearDevices];
            [self.discoveryDelegate discoveryDidRefresh];
            [self.peripheralDelegate bleServiceDidReset];
            
			pendingInit = YES;
			break;
		}
        default:
            break;
	}
    
    previousState = [centralManager state];
}
@end
