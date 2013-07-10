//
//  IFHelper.m
//  iFirmata
//
//  Created by Juan Haladjian on 6/27/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "IFHelper.h"


@implementation IFHelper

+(BOOL) isPinPWM:(NSInteger) pinNumber{
    return YES;
}

+(NSString *)UUIDToString:(CFUUIDRef) uuid{
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    return (__bridge_transfer NSString *)string;
}

+(NSInteger) Data:(NSData*) data toArray:(Byte**) bytes{
    (*bytes) = (Byte*)malloc(data.length);
    memcpy(*bytes, data.bytes, data.length);
    
    return data.length;
}

+(NSString*) DataToString:(NSData*) data{
    NSString * string = @"";
    
    NSInteger length = data.length;
    Byte * array;
    [self Data:data toArray:&array];
    for (int i = 0 ; i < length; i++) {
        string = [string stringByAppendingFormat:@" %d",array[i]];
    }
    return string;
}

@end
