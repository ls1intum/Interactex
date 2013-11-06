//
//  IFFirmata.h
//  iFirmata
//
//  Created by Juan Haladjian on 6/28/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFPin.h"
#import "IFFirmata.h"

typedef struct{
    uint64_t supportedModes;
    uint8_t analogChannel;
} PinInfo;

#define IFPinInfoBufSize 128

@class IFPinsController;
@class IFI2CComponent;
@class IFI2CRegister;
@class IFFirmata;
@class BLEService;

@protocol IFFirmataControllerPinsDelegate <NSObject>

-(void) firmataDidUpdateDigitalPins:(IFPinsController*) firmataController;
-(void) firmataDidUpdateAnalogPins:(IFPinsController*) firmataController;
-(void) firmataDidUpdateI2CComponents:(IFPinsController*) firmataController;

-(void) firmata:(IFPinsController*) firmataController didUpdateTitle:(NSString*) title;

@end

@interface IFPinsController : NSObject <IFFirmataControllerDelegate> {
    
    PinInfo pinInfo[IFPinInfoBufSize];
    
    NSInteger numDigitalPins;
    NSInteger numAnalogPins;
    NSInteger numPins;
}

@property (nonatomic, strong) NSMutableArray * digitalPins;
@property (nonatomic, strong) NSMutableArray * analogPins;
@property (nonatomic, strong) NSMutableArray * i2cComponents;

//@property (nonatomic, weak) BLEService * bleService;
@property (nonatomic, strong) IFFirmata * firmataController;
@property (nonatomic, weak) id<IFFirmataControllerPinsDelegate> delegate;

@property (nonatomic, strong) NSString* firmataName;

-(void) reset;

//stop reporting
-(void) stopReportingAnalogPins;
-(void) stopReportingI2CComponents;
-(void) stopReportingI2CComponent:(IFI2CComponent*) component;

//i2c
-(void) addI2CComponent:(IFI2CComponent*) component;
-(void) removeI2CComponent:(IFI2CComponent*) component;
-(void) addI2CRegister:(IFI2CRegister*) reg toComponent:(IFI2CComponent*) component;
-(void) removeI2CRegister:(IFI2CRegister*) reg fromComponent:(IFI2CComponent*) component;

@end
