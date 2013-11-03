//
//  IFFirmataBLECommunicationModule.h
//  BLEFirmata
//
//  Created by Juan Haladjian on 10/21/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "IFFirmataCommunicationModule.h"

@class BLEService;

@interface IFFirmataBLECommunicationModule : IFFirmataCommunicationModule

@property (nonatomic, weak) BLEService * bleService;

-(void) sendDataWithCRC:(uint8_t*) bytes count:(NSInteger) count;
-(void) sendData:(uint8_t*) bytes count:(NSInteger) count;

@end
