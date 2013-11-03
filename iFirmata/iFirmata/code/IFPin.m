//
//  IFPin.m
//  iFirmata
//
//  Created by Juan Haladjian on 6/27/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "IFPin.h"

@implementation IFPin

+(id) pinWithNumber:(NSInteger) number type:(IFPinType) type mode:(IFPinMode) mode{
    return [[IFPin alloc] initWithNumber:number type:type mode:mode];
}

-(id) initWithNumber:(NSInteger) number type:(IFPinType) type mode:(IFPinMode) mode{
    self = [super init];
    if(self){
        self.number = number;
        self.type = type;
        self.mode = mode;
        if(_mode == IFPinModeInput){
            _value = 1;
        }
        if(self.type == IFPinTypeAnalog){
            self.analogChannel = 127;
        }
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self){
        self.number = [decoder decodeIntForKey:@"number"];
        self.type = [decoder decodeIntForKey:@"type"];
        self.mode = [decoder decodeIntForKey:@"mode"];
        
        self.analogChannel = [decoder decodeIntForKey:@"analogChannel"];
        self.supportedModes = [decoder decodeIntForKey:@"supportedModes"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeInt:self.number forKey:@"number"];
    [coder encodeInt:self.type forKey:@"type"];
    [coder encodeInt:self.mode forKey:@"mode"];
    [coder encodeInt:self.analogChannel forKey:@"analogChannel"];
    [coder encodeInt:self.supportedModes forKey:@"supportedModes"];
}

-(id)copyWithZone:(NSZone *)zone {
    IFPin * copy = [super init];
    if(copy){
        copy.number = self.number;
        copy.type = self.type;
        copy.mode = self.mode;
        copy.analogChannel = self.analogChannel;
        copy.supportedModes = self.supportedModes;
    }
    return copy;
}

#pragma mark - Methods

-(BOOL) supportsPwm{
    return (self.type == IFPinTypeDigital && (self.number == 3 || self.number == 5 || self.number == 6 || self.number == 9 || self.number == 10 || self.number == 11));
}

-(void) setMode:(IFPinMode)mode{
    if(mode != self.mode){
        _mode = mode;
    }
}

-(void) setValue:(NSInteger)value{
    if(value != _value){
        _value = value;
    }
    
}

@end
