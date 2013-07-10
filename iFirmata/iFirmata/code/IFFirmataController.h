//
//  IFFirmata.h
//  iFirmata
//
//  Created by Juan Haladjian on 6/28/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEService.h"
#import "IFPin.h"

@interface IFFirmataController : NSObject <BLEServiceDelegate, IFPinDelegate> {
    NSInteger parse_count;
    NSInteger parse_command_len;
    uint8_t parse_buf[4096];
    unsigned int rx_count;
    //unsigned int tx_count;
    
    NSTimer * timer;
}

@property (nonatomic) NSMutableArray * digitalPins;
@property (nonatomic) NSMutableArray * analogPins;
@property (nonatomic, weak) BLEService * bleService;

-(void) start;
-(void) stop;
-(void) sendPinModeForPin:(IFPin*) pin;

@end
