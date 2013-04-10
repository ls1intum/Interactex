//
//  THLinearFunction.h
//  TangoHapps
//
//  Created by Juan Haladjian on 12/11/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THLinearFunction : NSObject

@property (nonatomic) float a;
@property (nonatomic) float b;


+(id) functionWithA:(float) a b:(float) b;
-(id) initWithA:(float) a b:(float) b;
-(float) evaluate:(float) x;

@end
