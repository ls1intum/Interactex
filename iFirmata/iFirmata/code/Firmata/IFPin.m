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
