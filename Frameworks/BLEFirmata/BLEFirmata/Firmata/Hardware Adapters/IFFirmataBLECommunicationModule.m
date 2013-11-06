//
//  IFFirmataBLECommunicationModule.m
//  BLEFirmata
//
//  Created by Juan Haladjian on 10/21/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "IFFirmataBLECommunicationModule.h"
#import "BLEService.h"

@implementation IFFirmataBLECommunicationModule

-(void) sendData:(uint8_t*) bytes count:(NSInteger) count{
    [self.bleService sendData:bytes count:count];
}


@end
