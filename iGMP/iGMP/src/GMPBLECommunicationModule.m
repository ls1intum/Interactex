//
//  GMPBLECommunicationModule.m
//  iGMP
//
//  Created by Juan Haladjian on 11/7/13.
//  Copyright (c) 2013 Technical University Munich. All rights reserved.
//

#import "GMPBLECommunicationModule.h"
#import "GMP.h"
@implementation GMPBLECommunicationModule

-(void) sendData:(uint8_t*) bytes count:(NSInteger) count{
    [self.bleService sendData:bytes count:count];
}

-(void) didReceiveData:(uint8_t *)buffer lenght:(NSInteger)length{
    [self.gmpController didReceiveData:buffer lenght:length];
}

@end
