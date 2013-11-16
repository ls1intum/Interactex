//
//  THBoard.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/12/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THBoard.h"
#import "THPin.h"
#import "THElementPin.h"
#import "THHardwareComponent.h"

@implementation THBoard

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        
        self.pins = [decoder decodeObjectForKey:@"pins"];
        self.i2cComponents = [decoder decodeObjectForKey:@"i2cComponents"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.pins forKey:@"pins"];
    [coder encodeObject:self.i2cComponents forKey:@"i2cComponents"];
}

-(id)copyWithZone:(NSZone *)zone {
    THBoard * copy = [super copyWithZone:zone];
    
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:self.pins.count];
    for (THPin * pin in self.pins) {
        THPin * copy = [pin copy];
        [array addObject:copy];
    }
    
    copy.pins = array;
    
    for (id<THI2CProtocol> i2cComponent in self.i2cComponents) {
        [copy addI2CComponent:i2cComponent];
    }
    
    return copy;
}

#pragma mark - SCL SDA

-(THBoardPin*) sclPin{
    NSLog(@"Warning, THBoard subclasses should implement method sclPin");
    return nil;
}

-(THBoardPin*) sdaPin{
    NSLog(@"Warning, THBoard subclasses should implement method sdaPin");
    return  nil;
}

#pragma mark - Pins

-(void) attachPin:(THElementPin*) object atPin:(NSInteger) pinNumber{
    THBoardPin * pin = [self.pins objectAtIndex:pinNumber];
    [pin attachPin:object];
    
    if([object.hardware conformsToProtocol:@protocol(THI2CProtocol)] && (pin.supportsSCL || pin.supportsSDA)){
        if((pin.supportsSCL && [self.sdaPin isClotheObjectAttached:object.hardware]) ||
           (pin.supportsSDA && [self.sclPin isClotheObjectAttached:object.hardware])) {
            
            THElementPin<THI2CProtocol> * i2cObject = (THElementPin<THI2CProtocol>*)object.hardware;
            [self addI2CComponent:i2cObject];
        }
    }
}

-(NSInteger) pinIdxForPin:(NSInteger) pinNumber ofType:(THPinType) type{
    return -1;
}

-(THBoardPin*) digitalPinWithNumber:(NSInteger) number{
    return nil;
}
-(THBoardPin*) analogPinWithNumber:(NSInteger) number{
    return nil;
}



#pragma mark - I2C Components

-(void) addI2CComponent:(id<THI2CProtocol>) component{
    [self.i2cComponents addObject:component];
}

-(void) removeI2CComponent:(id<THI2CProtocol>) component{
    [self.i2cComponents removeObject:component];
}

-(id<THI2CProtocol>) I2CComponentWithAddress:(NSInteger) address{
    
    for (id<THI2CProtocol> component in self.i2cComponents) {
        if(component.i2cComponent.address == address){
            return component;
        }
    }
    return nil;
}

@end
