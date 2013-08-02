//
//  IFHelper.h
//  iFirmata
//
//  Created by Juan Haladjian on 6/27/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IFI2CRegister;

@interface IFHelper : NSObject

+(BOOL) isPinPWM:(NSInteger) pinNumber;

+(NSString*) valueAsBracketedStringForI2CRegister:(IFI2CRegister*) reg;

@end
