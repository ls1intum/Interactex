/*
LeDiscovery.m
Interactex Designer

Created by Juan Haladjian on 05/10/2013.

Interactex Designer is a configuration tool to easily setup, simulate and connect e-Textile hardware with smartphone functionality. Interactex Client is an app to store and replay projects made with Interactex Designer.

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
The first version of the software was designed and implemented as part of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was founded by Telekom Innovation Laboratories Berlin. It has been extended with funding from EIT ICT, as part of the activity "Connected Textiles".

Interactex is built using the Tango framework developed by TU Munich.

In the Interactex software, we use the GHUnit (a test framework for iOS developed by Gabriel Handford) and cocos2D libraries (a framework for building 2D games and graphical applications developed by Zynga Inc.). 
www.cocos2d-iphone.org
github.com/gabriel/gh-unit

Interactex also implements the Firmata protocol. Its software serial library is based on the original Arduino Firmata library.
www.firmata.org

All hardware part graphics in Interactex Designer are reproduced with kind permission from Fritzing. Fritzing is an open-source hardware initiative to support designers, artists, researchers and hobbyists to work creatively with interactive electronics.
www.frizting.org


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

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
