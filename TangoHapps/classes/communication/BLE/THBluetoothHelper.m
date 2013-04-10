//
//  THBluetoothHelper.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/9/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THBluetoothHelper.h"

@implementation THBluetoothHelper

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

    NSInteger length = data.length;
    Byte * array;
    [self Data:data toArray:&array];
     for (int i = 0 ; i < length; i++) {
         
         string = [string stringByAppendingFormat:@" %d",array[i]];
     }
    return string;
}

@end
