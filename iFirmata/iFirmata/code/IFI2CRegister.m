//
//  IFI2CRegister.m
//  iFirmata
//
//  Created by Juan Haladjian on 8/1/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "IFI2CRegister.h"

@implementation IFI2CRegister

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:self.number forKey:@"number"];
    [aCoder encodeInt:self.size forKey:@"size"];
    [aCoder encodeInt:self.numBytes forKey:@"numBytes"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        self.number = [aDecoder decodeIntegerForKey:@"number"];
        self.size = [aDecoder decodeIntegerForKey:@"size"];
        self.numBytes = [aDecoder decodeIntegerForKey:@"numBytes"];
    }
    return self;
}

@end
