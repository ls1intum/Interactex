//
//  IFI2CComponent.h
//  iFirmata
//
//  Created by Juan Haladjian on 7/31/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IFI2CRegister;

@interface IFI2CComponent : NSObject <NSCoding>

@property (copy, nonatomic) NSString * name;
@property (nonatomic) NSInteger address;

@property (strong, nonatomic) NSMutableArray * registers;

-(void) addRegister:(IFI2CRegister*) reg;
-(void) removeRegister:(IFI2CRegister *)reg;

-(IFI2CRegister*) registerWithNumber:(NSInteger) number;

@end
