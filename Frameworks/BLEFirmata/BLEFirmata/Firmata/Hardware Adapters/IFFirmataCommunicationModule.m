//
//  IFFirmataCommunicationModule.m
//  BLEFirmata
//
//  Created by Juan Haladjian on 10/21/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "IFFirmataCommunicationModule.h"

@implementation IFFirmataCommunicationModule

-(void) sendData:(uint8_t*) bytes count:(NSInteger) count{
    NSLog(@"Dont call sendData on IFFirmataCommunicationModule Superclass");
}

@end
