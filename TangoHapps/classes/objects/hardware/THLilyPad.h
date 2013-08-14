//
//  THLilyPad.h
//  TangoHapps
//
//  Created by Juan Haladjian on 10/11/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLilypadNumberOfPins 22

@class THBoardPin;
@class THElementPin;
@class IFI2CComponent;

@interface THLilyPad : TFSimulableObject
{
}

@property (nonatomic, readonly) NSInteger numberOfDigitalPins;
@property (nonatomic, readonly) NSInteger numberOfAnalogPins;
@property (nonatomic) NSMutableArray * pins;
@property (nonatomic, readonly) NSMutableArray * analogPins;
@property (nonatomic, readonly) NSMutableArray * digitalPins;
@property (nonatomic, readonly) NSMutableArray * i2cComponents;

@property (nonatomic, readonly) THBoardPin * minusPin;
@property (nonatomic, readonly) THBoardPin * plusPin;

@property (nonatomic, readonly) THBoardPin * sclPin;//analog 5
@property (nonatomic, readonly) THBoardPin * sdaPin;//analog 4

-(NSArray*) objectsAtPin:(NSInteger) pin;
-(void) attachPin:(THElementPin*) object atPin:(NSInteger) pin;

-(NSInteger) pinIdxForPin:(NSInteger) pinNumber ofType:(THPinType) type;
-(THBoardPin*) digitalPinWithNumber:(NSInteger) number;
-(THBoardPin*) analogPinWithNumber:(NSInteger) number;

-(NSInteger) realIdxForPin:(THBoardPin*) pin;
-(THBoardPin*) pinWithRealIdx:(NSInteger) pinNumber;

-(void) addI2CCOmponent:(IFI2CComponent*) component;
-(void) removeI2CCOmponent:(IFI2CComponent*) component;
-(IFI2CComponent*) I2CComponentWithAddress:(NSInteger) address;

@end
