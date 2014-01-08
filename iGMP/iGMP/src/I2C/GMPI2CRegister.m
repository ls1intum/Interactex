//
//  IFI2CRegister.m
//  iFirmata
//
//  Created by Juan Haladjian on 8/1/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "GMPI2CRegister.h"

@implementation GMPI2CRegister

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:self.number forKey:@"number"];
    [aCoder encodeInt:self.numElements forKey:@"numElements"];
    [aCoder encodeInt:self.sizePerElement forKey:@"sizePerElement"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        self.number = [aDecoder decodeIntegerForKey:@"number"];
        self.numElements = [aDecoder decodeIntegerForKey:@"numElements"];
        self.sizePerElement = [aDecoder decodeIntegerForKey:@"sizePerElement"];
    }
    return self;
}

@end
