//
//  IFFirmataBLECommunicationModule.h
//  BLEFirmata
//
//  Created by Juan Haladjian on 10/21/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "IFFirmataCommunicationModule.h"
#import "BLE.h"

@class IFFirmata;

@interface IFFirmataBLECommunicationModule : IFFirmataCommunicationModule <BLEServiceDataDelegate>

@property (nonatomic, weak) BLEService * bleService;
@property (nonatomic, weak) IFFirmata * firmataController;

-(void) sendData:(uint8_t*) bytes count:(NSInteger) count;

@end
