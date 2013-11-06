//
//  THBluetoothHelper.h
//  TangoHapps
//
//  Created by Juan Haladjian on 10/9/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBUUID;

@interface BLEHelper : NSObject

+(NSInteger) Data:(NSData*) data toArray:(uint8_t**) bytes;

+(NSString *)UUIDToString:(CBUUID*) uuid;

+(NSData*) StringToData:(NSString*) string;

+(NSString*) DataToString:(NSData*) data;

@end
