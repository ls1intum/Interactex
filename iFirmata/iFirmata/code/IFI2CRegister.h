//
//  IFI2CRegister.h
//  iFirmata
//
//  Created by Juan Haladjian on 8/1/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFI2CRegister : NSObject
{
    NSInteger _values[IFMaxI2CRegisterSize];
}

@property (nonatomic) NSInteger number;
@property (nonatomic) NSInteger size;
@property (nonatomic) NSInteger numBytes;
@property (nonatomic, readonly) NSInteger * values;
@property (nonatomic) BOOL notifies;

-(void) setValues:(NSInteger *)values withSize:(NSInteger) size;

@end
