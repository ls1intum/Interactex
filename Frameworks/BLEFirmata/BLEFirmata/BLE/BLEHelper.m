//
//  THBluetoothHelper.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/9/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "BLEHelper.h"
#import <CoreBluetooth/CoreBluetooth.h>

@implementation BLEHelper


+(NSInteger) Data:(NSData*) data toArray:(Byte**) bytes{
    
    (*bytes) = (Byte*)malloc(data.length);
    memcpy(*bytes, data.bytes, data.length);
    
    return data.length;
}

+(NSString *)UUIDToString:(CBUUID*) uuid{

    NSData *data = [uuid data];
    
    NSUInteger bytesToConvert = [data length];
    const unsigned char *uuidBytes = [data bytes];
    NSMutableString *outputString = [NSMutableString stringWithCapacity:16];
    
    for (NSUInteger currentByteIndex = 0; currentByteIndex < bytesToConvert; currentByteIndex++)
    {
        switch (currentByteIndex)
        {
            case 3:
            case 5:
            case 7:
            case 9:[outputString appendFormat:@"%02x-", uuidBytes[currentByteIndex]]; break;
            default:[outputString appendFormat:@"%02x", uuidBytes[currentByteIndex]];
        }
        
    }
    
    return outputString.uppercaseString;
}

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
