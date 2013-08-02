//
//  IFHelper.m
//  iFirmata
//
//  Created by Juan Haladjian on 6/27/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "IFHelper.h"
#import "IFI2CRegister.h"

@implementation IFHelper

+(BOOL) isPinPWM:(NSInteger) pinNumber{
    return YES;
}

+(NSString*) valueAsBracketedStringForI2CRegister:(IFI2CRegister*) reg{
    if(reg.numBytes <= 0){
        return @"";
    }
    
    NSString * string = @"[";
    for (int i = 0; i < reg.numBytes-1; i++) {
        string = [NSString stringWithFormat:@"%d, ", reg.values[i]];
    }
    return [NSString stringWithFormat:@"%d]", reg.values[reg.numBytes-1]];
}

@end
