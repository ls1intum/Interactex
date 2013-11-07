//
//  GMPDelegate.m
//  iFirmata
//
//  Created by Juan Haladjian on 6/28/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "GMPDelegate.h"
#import "GMP.h"

@implementation GMPDelegate

#pragma mark - Firmata Message Handles

-(void) gmpController:(GMP*) gmpController didReceiveFirmwareName: (NSString*) name{
    NSLog(@"firmware name: %@",name);
}

-(void) gmpController:(GMP*) gmpController didReceiveCapabilityResponseForPin:(pin_t) pin{
    NSLog(@"capaility received: %d %d",pin.index,pin.capability);
}

-(void) gmpController:(GMP*) gmpController didReceivePinStateResponseForPin:(NSInteger) pin state:(NSInteger) state{
    NSLog(@"state received: %d %d",pin,state);
}

-(void) gmpController:(GMP*) gmpController didReceiveDigitalMessageForPin:(NSInteger) pin value:(NSInteger) value{
    
    NSLog(@"digital message: %d %d",pin,value);
}

-(void) gmpController:(GMP*) gmpController didReceiveI2CReply:(uint8_t*) buffer length:(NSInteger) length{
    
}


@end
