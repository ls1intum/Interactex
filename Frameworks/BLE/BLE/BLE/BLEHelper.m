/*
BLEHelper.m
BLE

Created by Juan Haladjian on 10/09/2012.

BLE is a library used to send and receive data from/to a device over Bluetooth 4.0.

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany

Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
It has been created with funding from EIT ICT, as part of the activity "Connected Textiles".


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "BLEHelper.h"
#import <CoreBluetooth/CoreBluetooth.h>

@implementation BLEHelper


+(NSInteger) Data:(NSData*) data toArray:(uint8_t**) bytes{
    
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
    free(array);
    
    return string;
}

+(void) valueAsTwo7bitBytes:(NSInteger) value buffer:(uint8_t[2]) buf {
    buf[0] = value & 0b01111111;
    buf[1] = value >> 7 & 0b01111111;
}

@end
