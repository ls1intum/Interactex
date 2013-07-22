//
//  THBluetoothHelper.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/9/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "BLEHelper.h"

@implementation BLEHelper

+(float) BytesToFloat:(NSData*) data{
    
    int16_t value	= 0;
    [data getBytes:&value length:sizeof(value)];
    return (CGFloat)value / 10.0f;
}

+(NSInteger) Data:(NSData*) data toArray:(Byte**) bytes{
    
    (*bytes) = (Byte*)malloc(data.length);
    memcpy(*bytes, data.bytes, data.length);
    
    return data.length;
}

+(NSString*) DataToString:(NSData*) data{
    NSString * string = @"";

    Byte * array;
    [self Data:data toArray:&array];
     for (int i = 0 ; i < data.length; i++) {
         
         string = [string stringByAppendingFormat:@" %d",array[i]];
     }
    return string;
}

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

@end
