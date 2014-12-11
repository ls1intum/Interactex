/*
THClientHelper.m
Interactex Designer

Created by Juan Haladjian on 05/10/2013.

Interactex Designer is a configuration tool to easily setup, simulate and connect e-Textile hardware with smartphone functionality. Interactex Client is an app to store and replay projects made with Interactex Designer.

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
The first version of the software was designed and implemented as part of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was founded by Telekom Innovation Laboratories Berlin. It has been extended with funding from EIT ICT, as part of the activity "Connected Textiles".

Interactex is built using the Tango framework developed by TU Munich.

In the Interactex software, we use the GHUnit (a test framework for iOS developed by Gabriel Handford) and cocos2D libraries (a framework for building 2D games and graphical applications developed by Zynga Inc.). 
www.cocos2d-iphone.org
github.com/gabriel/gh-unit

Interactex also implements the Firmata protocol. Its software serial library is based on the original Arduino Firmata library.
www.firmata.org

All hardware part graphics in Interactex Designer are reproduced with kind permission from Fritzing. Fritzing is an open-source hardware initiative to support designers, artists, researchers and hobbyists to work creatively with interactive electronics.
www.frizting.org

Martijn ten Bhömer from TU Eindhoven contributed PureData support. Contact: m.t.bhomer@tue.nl.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

#import "THClientHelper.h"

@implementation THClientHelper

+(float) Constrain:(float) value min:(float) minValue max:(float) maxValue{
    value = MAX(value,minValue);
    value = MIN(value,maxValue);
    return value;
}

+(float) LinearMapping:(float)value min:(float) min max:(float) max retMin:(float) retMin retMax:(float) retMax{
    float a = (retMax - retMin) / (max - min);
    float b = retMin - (a * min);
    return a * value + b;
}

+(BOOL) canConvertParam:(TFDataType) type1 toType:(TFDataType) type2{
    return (type1 == kDataTypeAny || type2 == kDataTypeAny || type1 == type2 || (type1 == kDataTypeFloat && type2 == kDataTypeInteger) || (type2 == kDataTypeFloat && type1 == kDataTypeInteger));
    
}

+(void) MakeCallTo:(NSString*) number{
    if (number) {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:number];
        NSURL * url = [NSURL URLWithString:phoneNumber];
        
        if([[UIApplication sharedApplication] canOpenURL:url]){
            [[UIApplication sharedApplication] openURL:url];
        } else {
            NSLog(@"Call cannot be made. Does your device support making calls?");
        }
    } else {
        NSLog(@"Call cannot be made. This contact does not have a number.");
    }
    
}

+(void) valueAsTwo7bitBytes:(NSInteger) value buffer:(uint8_t[2]) buf {
    buf[0] = value & 0b01111111;
    buf[1] = value >> 7 & 0b01111111;
}

/*
+(IFPinType) THPinTypeToIFPinType:(THPinType) type{
    if(type == kPintypeDigital){
        return IFPinTypeDigital;
    } else if(type == kPintypeAnalog){
        return IFPinTypeAnalog;
    }
    
    NSAssert(FALSE, @"wrong parameter to method THPinTypeToIFPinType");
    return IFPinTypeDigital;
}
*/

@end
