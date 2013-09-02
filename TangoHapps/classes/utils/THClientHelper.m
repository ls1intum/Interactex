//
//  THClientHelper.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/29/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

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
    NSString *phoneNumber = [@"tel://" stringByAppendingString:number];
    NSURL * url = [NSURL URLWithString:phoneNumber];
    
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    } else {
        NSLog(@"Call cannot be made. Does your device support making calls?");
    }
}

+(IFPinType) THPinTypeToIFPinType:(THPinType) type{
    if(type == kPintypeDigital){
        return IFPinTypeDigital;
    } else if(type == kPintypeAnalog){
        return IFPinTypeAnalog;
    }
    
    NSAssert(FALSE, @"wrong parameter to method THPinTypeToIFPinType");
    return IFPinTypeDigital;
}


@end
