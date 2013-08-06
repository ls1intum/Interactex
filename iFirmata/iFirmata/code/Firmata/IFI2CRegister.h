//
//  IFI2CRegister.h
//  iFirmata
//
//  Created by Juan Haladjian on 8/1/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>


#define IFMaxI2CRegisterSize 128

@interface IFI2CRegister : NSObject <NSCoding>
{
    NSInteger _values[IFMaxI2CRegisterSize];
}

@property (nonatomic) NSInteger number;
@property (nonatomic) NSInteger size;
@property (nonatomic) NSInteger numBytes;
@property (strong, nonatomic) NSData * value;
@property (nonatomic) BOOL notifies;

@end
