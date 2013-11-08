//
//  GMPBLECommunicationModule.h
//  iGMP
//
//  Created by Juan Haladjian on 11/7/13.
//  Copyright (c) 2013 Technical University Munich. All rights reserved.
//

#import "GMPCommunicationModule.h"

@class GMP;

@interface GMPBLECommunicationModule : GMPCommunicationModule <BLEServiceDataDelegate>

@property (nonatomic, weak) BLEService * bleService;
@property (nonatomic, weak) GMP * gmpController;

-(void) sendData:(uint8_t*) bytes count:(NSInteger) count;

@end
