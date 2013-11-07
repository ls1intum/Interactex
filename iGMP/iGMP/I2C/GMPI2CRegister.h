//
//  IFI2CRegister.h
//  iFirmata
//
//  Created by Juan Haladjian on 8/1/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IFMaxI2CRegisterSize 128

@interface GMPI2CRegister : NSObject <NSCoding>
{
    NSInteger _values[IFMaxI2CRegisterSize];
}

@property (nonatomic) NSInteger number;
@property (nonatomic) NSInteger numElements;
@property (nonatomic) NSInteger sizePerElement;

@property (strong, nonatomic) NSData * value;
@property (nonatomic) BOOL notifies;

@end
