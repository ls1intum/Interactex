//
//  THBoard.h
//  TangoHapps
//
//  Created by Juan Haladjian on 10/12/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "TFSimulableObject.h"
#import "THI2CProtocol.h"

@class THBoardPin;
@class THElementPin;

@interface THBoard : TFSimulableObject

@property (nonatomic) NSInteger numberOfDigitalPins;
@property (nonatomic) NSInteger numberOfAnalogPins;
@property (nonatomic, strong) NSMutableArray * pins;
@property (nonatomic, strong) NSMutableArray * i2cComponents;

@property (nonatomic, readonly) THBoardPin * minusPin;
@property (nonatomic, readonly) THBoardPin * plusPin;

@property (nonatomic, readonly) THBoardPin * sclPin;//analog 5
@property (nonatomic, readonly) THBoardPin * sdaPin;//analog 4

-(void) attachPin:(THElementPin*) object atPin:(NSInteger) pin;
-(NSInteger) pinIdxForPin:(NSInteger) pinNumber ofType:(THPinType) type;

-(THBoardPin*) digitalPinWithNumber:(NSInteger) number;
-(THBoardPin*) analogPinWithNumber:(NSInteger) number;

-(void) addI2CComponent:(id<THI2CProtocol>) component;
-(void) removeI2CComponent:(id<THI2CProtocol>) component;
-(id<THI2CProtocol>) I2CComponentWithAddress:(NSInteger) address;


@end
