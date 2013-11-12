//
//  IFHelper.h
//  iFirmata
//
//  Created by Juan Haladjian on 6/27/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GMPI2CRegister;

@interface GMPHelper : NSObject

+(BOOL) isPinPWM:(NSInteger) pinNumber;

+(NSString*) valueAsBracketedStringForI2CRegister:(GMPI2CRegister*) reg;

+(void) valueAsTwo7bitBytes:(NSInteger) value buffer:(uint8_t[2]) buf;

@end
