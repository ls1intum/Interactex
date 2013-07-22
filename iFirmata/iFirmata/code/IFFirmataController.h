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

typedef struct{
    uint64_t supportedModes;
    uint8_t analogChannel;
} PinInfo;

@protocol IFFirmataControllerDelegate <NSObject>

-(void) didUpdatePins;

@end

@interface IFFirmataController : NSObject <BLEServiceDelegate> {
    NSInteger parse_count;
    NSInteger parse_command_len;
    
    uint8_t parse_buf[4096];
    PinInfo pinInfo[128];
        
    unsigned int rx_count;
    //unsigned int tx_count;
    
    NSTimer * timer;
    
    NSString * rx;
    
    BOOL ready;
    BOOL startedSysex;
}

@property (nonatomic, readonly) NSInteger numDigitalPins;
@property (nonatomic, readonly) NSInteger numAnalogPins;
@property (nonatomic, readonly) NSInteger numPins;

@property (nonatomic, strong) NSMutableArray * digitalPins;
@property (nonatomic, strong) NSMutableArray * analogPins;
@property (nonatomic, weak) BLEService * bleService;
@property (nonatomic, weak) id<IFFirmataControllerDelegate> delegate;

-(void) start;
-(void) stop;
-(void) sendPinModeForPin:(IFPin*) pin;
-(void) sendFirmwareRequest;

@end
