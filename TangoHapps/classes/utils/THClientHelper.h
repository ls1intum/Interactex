//
//  THClientHelper.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/29/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface THClientHelper : NSObject

+(float) Constrain:(float) value min:(float) minValue max:(float) maxValue;
+(float) LinearMapping:(float)value min:(float) min max:(float) max retMin:(float) retMin retMax:(float) retMax;
+(BOOL) canConvertParam:(TFDataType) type1 toType:(TFDataType) type2;
+(void) MakeCallTo:(NSString*) number;

@end
