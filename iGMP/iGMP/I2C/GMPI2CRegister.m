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
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        self.number = [aDecoder decodeIntegerForKey:@"number"];
    }
    return self;
}

@end
