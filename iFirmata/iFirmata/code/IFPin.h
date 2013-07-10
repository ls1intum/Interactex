//
//  IFPin.h
//  iFirmata
//
//  Created by Juan Haladjian on 6/27/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IFPin;

@protocol IFPinDelegate <NSObject>

-(void) pin:(IFPin*) pin changedMode:(IFPinMode) newMode;
-(void) pin:(IFPin*) pin changedValue:(NSInteger) newValue;

@end

@interface IFPin : NSObject

@property (nonatomic) NSInteger number;
@property (nonatomic) IFPinType type;
@property (nonatomic) IFPinMode mode;
@property (nonatomic) BOOL supportsPwm;//only for digitals
@property (nonatomic) NSInteger value;//only for output
@property (nonatomic, weak) id<IFPinDelegate> delegate;//only for output
@property (nonatomic) uint8_t analogChannel;
@property (nonatomic) uint64_t supportedModes;

+(id) pinWithNumber:(NSInteger) number type:(IFPinType) type mode:(IFPinMode) mode;
-(id) initWithNumber:(NSInteger) number type:(IFPinType) type mode:(IFPinMode) mode;

@end
