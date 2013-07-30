//
//  THBluetoothHelper.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/9/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "BLEHelper.h"

@implementation BLEHelper


+(NSInteger) Data:(NSData*) data toArray:(Byte**) bytes{
    
    (*bytes) = (Byte*)malloc(data.length);
    memcpy(*bytes, data.bytes, data.length);
    
    return data.length;
}

+(NSString *)UUIDToString:(CFUUIDRef) uuid{
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    return (__bridge_transfer NSString *)string;
}

/*
+(NSData*) hexToBytes :(NSString*) string{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= string.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [string substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}
*/

+(NSData*) StringToData:(NSString*) string{
    
    Byte array[string.length];
    int count = 0;
    int prevIdx = 0;
    for (int i = 0 ; i < string.length; i++) {
        if([string characterAtIndex:i] == ' '){
            
            NSRange range = NSMakeRange(prevIdx, i - prevIdx);
            NSString* substr = [string substringWithRange:range];
            NSInteger value = [substr integerValue];
            if(value >= 0 && value <= 255){
                array[count++] = (uint8_t)value;
                prevIdx = i+1;
            }
        }
    }
    
    NSRange range = NSMakeRange(prevIdx, string.length - prevIdx);
    NSString* substr = [string substringWithRange:range];
    NSInteger value = [substr integerValue];
    if(value >= 0 && value <= 255){
        array[count++] = (uint8_t)value;
    }
    
    return [NSData dataWithBytes:array length:count];
}

+(NSString*) DataToString:(NSData*) data{
    
    Byte * array;
    NSInteger length = [BLEHelper Data:data toArray:&array];
    
    NSString * string = @"";
    
    for (int i = 0 ; i < length; i++) {
        string = [string stringByAppendingFormat:@" %d",array[i]];
    }
    return string;
}

@end
