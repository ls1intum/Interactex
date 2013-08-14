//
//  THLilyPad.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/11/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THLilyPad.h"
#import "THBoardPin.h"
#import "IFI2CComponent.h"
#import "THHardwareComponent.h"
#import "THElementPin.h"

@implementation THLilyPad
@dynamic minusPin;
@dynamic plusPin;
@dynamic sclPin;
@dynamic sdaPin;

-(void) load{    
    _numberOfDigitalPins = 14;
    _numberOfAnalogPins = 6;
}

-(void) setPwmPins{
    for (int i = 0; i < kLilypadNumPwmPins; i++) {
        NSInteger pinIdx = kLilypadPwmPins[i];
        THBoardPin * boardpin = [self digitalPinWithNumber:pinIdx];
        boardpin.isPWM = YES;
    }
}

-(void) loadPins{
    for (int i = 0; i <= 4; i++) {
        THBoardPin * pin = [THBoardPin pinWithPinNumber:i andType:kPintypeDigital];
        [_pins addObject:pin];
    }
    
    THBoardPin * minusPin = [THBoardPin pinWithPinNumber:-1 andType:kPintypeMinus];
    [_pins addObject:minusPin];
    
    THBoardPin * plusPin = [THBoardPin pinWithPinNumber:-1 andType:kPintypePlus];
    [_pins addObject:plusPin];
    
    for (int i = 7; i <= 15; i++) {
        THBoardPin * pin = [THBoardPin pinWithPinNumber:i-2 andType:kPintypeDigital];
        [_pins addObject:pin];
    }
    
    for (int i = 16; i < kLilypadNumberOfPins; i++) {
        THBoardPin * pin = [THBoardPin pinWithPinNumber:i-16 andType:kPintypeAnalog];
        [_pins addObject:pin];
    }
    
    [self setPwmPins];
}

-(id) init{
    self = [super init];
    if(self){
        
        _pins = [NSMutableArray array];
        _i2cComponents = [NSMutableArray array];
        
        [self load];
        [self loadPins];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    _pins = [decoder decodeObjectForKey:@"pins"];
    [self load];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:_pins forKey:@"pins"];
}

-(id)copyWithZone:(NSZone *)zone {
    THLilyPad * copy = [super copyWithZone:zone];
    
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:_pins.count];
    for (THPin * pin in _pins) {
        THPin * copy = [pin copy];
        [array addObject:copy];
    }
    copy.pins = array;
    
    return copy;
}

#pragma mark - Pins

-(NSMutableArray*) analogPins{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:self.numberOfAnalogPins];
    for (int i = 0; i < self.numberOfAnalogPins; i++) {
        THBoardPin * pin = [self analogPinWithNumber:i];
        [array addObject:pin];
    }
    return array;
}

-(NSMutableArray*) digitalPins{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:self.numberOfDigitalPins];
    for (int i = 0; i < self.numberOfDigitalPins; i++) {
        THBoardPin * pin = [self digitalPinWithNumber:i];
        [array addObject:pin];
    }
    return array;
}

-(THBoardPin*) minusPin{
    return [_pins objectAtIndex:5];
}

-(THBoardPin*) plusPin{
    return [_pins objectAtIndex:6];
}

-(THBoardPin*) sclPin{
    return [self analogPinWithNumber:5];
}

-(THBoardPin*) sdaPin{
    return [self analogPinWithNumber:4];
}

/*
-(BOOL) supportsSCL{
    return (self.type == kPintypeAnalog && self.number == 5);
}

-(BOOL) supportsSDA{
    return (self.type == kPintypeAnalog && self.number == 4);
}*/

-(NSInteger) realIdxForPin:(THBoardPin*) pin{
    
    if(pin.type == kPintypeDigital){
        return pin.number;
    } else {
        return pin.number + self.numberOfDigitalPins;
    }
}

-(THBoardPin*) pinWithRealIdx:(NSInteger) pinNumber{
    NSInteger pinidx;
    
    if(pinNumber <= self.numberOfDigitalPins){
        return [self digitalPinWithNumber:pinNumber];
    } else {
        return [self analogPinWithNumber:pinNumber - self.numberOfDigitalPins];
    }
    return [self.pins objectAtIndex:pinidx];
}

-(NSInteger) pinIdxForPin:(NSInteger) pinNumber ofType:(THPinType) type{
    if(type == kPintypeDigital){
        if(pinNumber <= 4) {
            return pinNumber;
        } else if(pinNumber <= self.numberOfDigitalPins){
            return pinNumber + 2;
        }
        
        return pinNumber;
    } else if(type == kPintypeAnalog){
        if(pinNumber >= 0 && pinNumber <= 5){
            return pinNumber + 16;
        }
    } else if(type == kPintypeMinus){
        return 5;
    } else if(type == kPintypePlus){
        return 6;
    }
    
    return -1;
}

-(THBoardPin*) digitalPinWithNumber:(NSInteger) number{
    NSInteger idx = [self pinIdxForPin:number ofType:kPintypeDigital];
    if(idx >= 0){
        return [_pins objectAtIndex:idx];
    }
    return nil;
}

-(THBoardPin*) analogPinWithNumber:(NSInteger) number{
    
    NSInteger idx = [self pinIdxForPin:number ofType:kPintypeAnalog];
    if(idx >= 0){
        return [_pins objectAtIndex:idx];
    }
    return nil;
}

-(NSArray*) objectsAtPin:(NSInteger) pinNumber{
    THBoardPin * pin = _pins[pinNumber];
    return pin.attachedElementPins;
}

-(void) attachPin:(THElementPin*) object atPin:(NSInteger) pinNumber{
    THBoardPin * pin = [_pins objectAtIndex:pinNumber];
    [pin attachPin:object];
    
    if(object.hardware.i2cComponent && (pin.supportsSCL || pin.supportsSDA)){
        
        if((pin.supportsSCL && [self.sdaPin isClotheObjectAttached:object.hardware]) ||
           (pin.supportsSDA && [self.sclPin isClotheObjectAttached:object.hardware])) {
            
            [self addI2CCOmponent:object.hardware.i2cComponent];
            
        }
    }
}

#pragma mark - I2C Components

-(void) addI2CCOmponent:(IFI2CComponent*) component{
    [self.i2cComponents addObject:component];
}

-(void) removeI2CCOmponent:(IFI2CComponent*) component{
    [self.i2cComponents removeObject:component];
}

-(IFI2CComponent*) I2CComponentWithAddress:(NSInteger) address{

    for (IFI2CComponent * component in self.i2cComponents) {
        if(component.address == address){
            return component;
        }
    }
    return nil;
}

#pragma mark - Other

-(NSString*) description{
    return @"lilypad";
}

-(void) prepareToDie{
    for (THBoardPin * pin in self.pins) {
        [pin prepareToDie];
    }
    _pins = nil;
    [super prepareToDie];
}

@end
