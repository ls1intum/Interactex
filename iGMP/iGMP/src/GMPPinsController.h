//
//  IFFirmata.h
//  iFirmata
//
//  Created by Juan Haladjian on 6/28/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMP.h"

#define GMPMaxNumPins 128

@class GMPPinsController;
@class GMPI2CComponent;
@class GMPI2CRegister;
@class GMP;
@class BLEService;

@protocol GMPControllerPinsDelegate <NSObject>


-(void) pinsControllerDidUpdateDigitalPins:(GMPPinsController*) firmataController;
-(void) pinsControllerDidUpdateAnalogPins:(GMPPinsController*) firmataController;
-(void) pinsControllerDidUpdateI2CComponents:(GMPPinsController*) firmataController;

-(void) pinsController:(GMPPinsController*) pinsController didUpdateFirmwareName:(NSString*) firmwareName;

@end

@interface GMPPinsController : NSObject <GMPControllerDelegate> {
    
    GMPPinCapability pinCapabilities[GMPMaxNumPins];
    NSInteger numDigitalPins;
    NSInteger numAnalogPins;
    NSInteger numPins;
}

@property (nonatomic, strong) NSMutableArray * digitalPins;
@property (nonatomic, strong) NSMutableArray * analogPins;
@property (nonatomic, strong) NSMutableArray * i2cComponents;

@property (nonatomic, strong) GMP * gmpController;
@property (nonatomic, weak) id<GMPControllerPinsDelegate> delegate;

@property (nonatomic, strong) NSString* firmwareName;

-(void) reset;

//stop reporting
-(void) stopReportingAnalogPins;
-(void) stopReportingI2CComponents;
-(void) stopReportingI2CComponent:(GMPI2CComponent*) component;

//i2c
-(void) addI2CComponent:(GMPI2CComponent*) component;
-(void) removeI2CComponent:(GMPI2CComponent*) component;
-(void) addI2CRegister:(GMPI2CRegister*) reg toComponent:(GMPI2CComponent*) component;
-(void) removeI2CRegister:(GMPI2CRegister*) reg fromComponent:(GMPI2CComponent*) component;

@end
