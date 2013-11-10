//
//  GMPHelper.h
//  GMPDemo
//
//  Created by Juan Haladjian on 11/10/13.
//  Copyright (c) 2013 Technical University Munich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMPHelper : NSObject

+(void) valueAsTwo7bitBytes:(NSInteger) value buffer:(uint8_t[2]) buf;

@end
