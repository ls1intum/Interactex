//
//  THBluetoothHelper.h
//  TangoHapps
//
//  Created by Juan Haladjian on 10/9/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEHelper : NSObject

+(NSInteger) Data:(NSData*) data toArray:(Byte**) bytes;

+(NSString *)UUIDToString:(CFUUIDRef) uuid;

+(NSData*) StringToData:(NSString*) string;

+(NSString*) DataToString:(NSData*) data;

@end
