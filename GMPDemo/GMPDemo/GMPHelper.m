//
//  GMPHelper.m
//  GMPDemo
//
//  Created by Juan Haladjian on 11/10/13.
//  Copyright (c) 2013 Technical University Munich. All rights reserved.
//

#import "GMPHelper.h"

@implementation GMPHelper

+(void) valueAsTwo7bitBytes:(NSInteger) value buffer:(uint8_t[2]) buf {
    buf[0] = value & 0b01111111;
    buf[1] = value >> 7 & 0b01111111;
}

@end
