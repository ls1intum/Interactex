//
//  IFPin.m
//  iFirmata
//
//  Created by Juan Haladjian on 6/27/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "GMPPin.h"

@implementation GMPPin

/*
+(id) pinWithNumber:(NSInteger) number type:(IFPinType) type mode:(IFPinMode) mode{
    return [[GMPPin alloc] initWithNumber:number type:type mode:mode];
}*/

-(id) initWithNumber:(NSInteger) number{
    self = [super init];
    if(self){
        self.number = number;
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
        self.supportedModes = [decoder decodeIntForKey:@"supportedModes"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeInt:self.number forKey:@"number"];
    [coder encodeInt:self.type forKey:@"type"];
    [coder encodeInt:self.mode forKey:@"mode"];
    [coder encodeInt:self.supportedModes forKey:@"supportedModes"];
}

-(id)copyWithZone:(NSZone *)zone {
    GMPPin * copy = [super init];
    if(copy){
        
        copy.number = self.number;
        copy.type = self.type;
        copy.mode = self.mode;
        copy.supportedModes = self.supportedModes;
    }
    return copy;
}

#pragma mark - Methods

-(BOOL) supportsPwm{
    return NO;
}

@end
