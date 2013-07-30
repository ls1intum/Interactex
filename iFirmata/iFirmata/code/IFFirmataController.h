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

@class IFFirmataController;

@protocol IFFirmataControllerDelegate <NSObject>

-(void) firmataDidUpdatePins:(IFFirmataController*) firmataController;
-(void) firmata:(IFFirmataController*) firmataController didUpdateTitle:(NSString*) title;

@end

@interface IFFirmataController : NSObject <BLEServiceDataDelegate> {
    NSInteger parse_count;
    NSInteger parse_command_len;
    
    uint8_t parse_buf[4096];
    PinInfo pinInfo[128];
    
    BOOL startedSysex;
}

@property (nonatomic, readonly) NSInteger numDigitalPins;
@property (nonatomic, readonly) NSInteger numAnalogPins;
@property (nonatomic, readonly) NSInteger numPins;

@property (nonatomic, strong) NSMutableArray * digitalPins;
@property (nonatomic, strong) NSMutableArray * analogPins;
@property (nonatomic, weak) BLEService * bleService;
@property (nonatomic, weak) id<IFFirmataControllerDelegate> delegate;

@property (nonatomic, strong) NSString* firmataName;

-(void) start;
-(void) stop;
-(void) sendPinModeForPin:(IFPin*) pin;
-(void) sendFirmwareRequest;
-(void) stopReportingAnalogPins;

@end
