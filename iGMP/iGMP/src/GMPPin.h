//
//  IFPin.h
//  iFirmata
//
//  Created by Juan Haladjian on 6/27/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMP.h"

@class GMPPin;


typedef enum{
    kGMPPinTypeDigital,
    kGMPPinTypeAnalog,
} GMPPinType;

@protocol IFPinDelegate <NSObject>

-(void) pin:(GMPPin*) pin changedMode:(GMPPinMode) newMode;
-(void) pin:(GMPPin*) pin changedValue:(NSInteger) newValue;

@end

@interface GMPPin : NSObject <NSCoding, NSCopying>

@property (nonatomic) NSInteger number;
@property (nonatomic) GMPPinMode mode;
@property (nonatomic) NSInteger value;//only for output
@property (nonatomic) GMPPinType type;//only for output


//@property (nonatomic) IGMPinType type;
@property (nonatomic) uint8_t supportedModes;
@property (nonatomic) BOOL supportsPwm;//only for digitals
@property (nonatomic) BOOL updatesValues;//only for analog

//+(id) pinWithNumber:(NSInteger) number type:(GMPPinType) type mode:(GMPPinMode) mode;
-(id) initWithNumber:(NSInteger) number;


@end
