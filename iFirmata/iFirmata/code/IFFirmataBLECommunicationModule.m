//
//  IFFirmataBLECommunicationModule.m
//  BLEFirmata
//
//  Created by Juan Haladjian on 10/21/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "IFFirmataBLECommunicationModule.h"
#import "BLEService.h"
#import "IFFirmata.h"

@implementation IFFirmataBLECommunicationModule

-(void) sendData:(uint8_t*) bytes count:(NSInteger) count{
    [self.bleService sendData:bytes count:count];
}


-(void) didReceiveData:(uint8_t *)buffer lenght:(NSInteger)length{
    [self.firmataController didReceiveData:buffer lenght:length];
}

-(void) setBleService:(BLEService *)bleService{
    if(bleService != self.bleService){
        _bleService = bleService;
        self.usesFillBytes = (self.bleService.deviceType == kBleDeviceTypeKroll);
    }
}

@end
