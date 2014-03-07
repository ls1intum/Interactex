/*
 BLEDiscovery.m
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

#import "BLEDiscovery.h"

@implementation BLEDiscovery

@synthesize supportedCharacteristicUUIDs = _supportedCharacteristicUUIDs;
@synthesize supportedServiceUUIDs = _supportedServiceUUIDs;

#pragma mark Init

-(NSMutableArray*) supportedServiceUUIDs{
    
    if(!_supportedServiceUUIDs){
        
        _supportedServiceUUIDs =  [NSMutableArray array];
        for (int i = 0; i < kBleNumSupportedServices; i++) {
            
            CBUUID * service = [CBUUID UUIDWithString:kBleSupportedServices[i]];
            [_supportedServiceUUIDs addObject:service];
        }
    }
    
    return _supportedServiceUUIDs;
}

-(NSMutableArray*) supportedCharacteristicUUIDs{
    if(!_supportedCharacteristicUUIDs){
        
        _supportedCharacteristicUUIDs = [NSMutableArray array];
        for (int i = 0; i < kBleNumSupportedServices; i++) {
            CBUUID * rxCharacteristic = [CBUUID UUIDWithString:kBleCharacteristics[i][0]];
            CBUUID * txCharacteristic = [CBUUID UUIDWithString:kBleCharacteristics[i][1]];
            NSArray * characteristics = [NSArray arrayWithObjects:rxCharacteristic,txCharacteristic, nil];
            [_supportedCharacteristicUUIDs addObject:characteristics];
            
        }
    }
    
    return _supportedCharacteristicUUIDs;
}

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
    [self.foundPeripherals removeAllObjects];
}

-(void) startScanningForSupportedUUIDs{
    
	NSArray			*uuidArray	= [self supportedServiceUUIDs];
	NSDictionary	*options	= [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    
	[centralManager scanForPeripheralsWithServices:uuidArray options:options];
    
    [self.foundPeripherals removeAllObjects];
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

    [self.peripheralDelegate bleServiceDidConnect:_connectedService];
    _currentPeripheral = peripheral;
    
	[_connectedService start];
}

-(void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Attempted connection to peripheral %@ failed: %@", [peripheral name], [error localizedDescription]);
}

-(void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    _connectedService = nil;
    _currentPeripheral = nil;
	[_discoveryDelegate discoveryDidRefresh];
    
    [self.peripheralDelegate bleServiceDidDisconnect:self.connectedService];
}

-(void) clearDevices {

    [self.foundPeripherals removeAllObjects];
    [self.connectedService stop];
    _connectedService = nil;
}

-(void) centralManagerDidUpdateState:(CBCentralManager *)central {
    static CBCentralManagerState previousState = -1;
    
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
