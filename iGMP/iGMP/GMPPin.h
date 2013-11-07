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

@protocol IFPinDelegate <NSObject>

-(void) pin:(GMPPin*) pin changedMode:(GMPPinMode) newMode;
-(void) pin:(GMPPin*) pin changedValue:(NSInteger) newValue;

@end

@interface GMPPin : NSObject <NSCoding, NSCopying>

@property (nonatomic) NSInteger number;
/*
@property (nonatomic) IFPinType type;
@property (nonatomic) IFPinMode mode;
@property (nonatomic) BOOL supportsPwm;//only for digitals
@property (nonatomic) NSInteger value;//only for output
@property (nonatomic) BOOL updatesValues;//only for analog

@property (nonatomic) uint64_t supportedModes;

+(id) pinWithNumber:(NSInteger) number type:(IFPinType) type mode:(IFPinMode) mode;
-(id) initWithNumber:(NSInteger) number type:(IFPinType) type mode:(IFPinMode) mode;
*/

@end
