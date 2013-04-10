//
//  THMapper.h
//  TangoHapps
//
//  Created by Juan Haladjian on 12/11/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THProgrammingElement.h"

@class THLinearFunction;

@interface THMapper : THProgrammingElement

@property (nonatomic) float min;
@property (nonatomic) float max;
@property (nonatomic) float value;
@property (nonatomic, strong) THLinearFunction * function;

@end
