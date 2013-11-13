//
//  IFI2CComponent.h
//  iFirmata
//
//  Created by Juan Haladjian on 7/31/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GMPI2CRegister;

@interface GMPI2CComponent : NSObject <NSCoding>

@property (copy, nonatomic) NSString * name;
@property (nonatomic) NSInteger address;

@property (strong, nonatomic) NSMutableArray * registers;

-(void) addRegister:(GMPI2CRegister*) reg;
-(void) removeRegister:(GMPI2CRegister *)reg;

-(GMPI2CRegister*) registerWithNumber:(NSInteger) number;

@end
