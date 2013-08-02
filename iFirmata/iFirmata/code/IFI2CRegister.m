//
//  IFI2CRegister.m
//  iFirmata
//
//  Created by Juan Haladjian on 8/1/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "IFI2CRegister.h"

@implementation IFI2CRegister

-(void) setValues:(NSInteger *)values withSize:(NSInteger) size{
    for (int i = 0; i < size; i++) {
        _values[i] = values[i];
    }
    self.size = size;
}

-(NSInteger*) values{
    return (NSInteger*)&_values;
}

@end
