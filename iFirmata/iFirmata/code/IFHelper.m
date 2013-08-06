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
    if(!reg.notifies || reg.value.length <= 0){
        return @"";
    }
    
    uint8_t* bytes = (uint8_t*)reg.value.bytes;
    
    NSString * string = @"[";
    for (int i = 0; i < reg.value.length-1; i++) {
        string = [string stringByAppendingFormat:@"%d, ", bytes[i]];
    }
    return [string stringByAppendingFormat:@"%d]", bytes[reg.value.length-1]];
}

@end
