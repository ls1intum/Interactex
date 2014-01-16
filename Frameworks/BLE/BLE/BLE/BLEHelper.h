/*
BLEHelper.h
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

#import <Foundation/Foundation.h>

@class CBUUID;

@interface BLEHelper : NSObject

+(NSInteger) Data:(NSData*) data toArray:(uint8_t**) bytes;

+(NSString *)UUIDToString:(CBUUID*) uuid;

+(NSData*) StringToData:(NSString*) string;

+(NSString*) DataToString:(NSData*) data;

+(void) valueAsTwo7bitBytes:(NSInteger) value buffer:(uint8_t[2]) buf;

@end
