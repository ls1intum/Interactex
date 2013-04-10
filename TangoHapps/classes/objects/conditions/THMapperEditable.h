//
//  THMapperEditable.h
//  TangoHapps
//
//  Created by Juan Haladjian on 12/11/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THProgrammingElementEditable.h"

@class THLinearFunction;

@interface THMapperEditable : THProgrammingElementEditable

@property (nonatomic) float min;
@property (nonatomic) float max;
@property (nonatomic) float value;
@property (nonatomic) THLinearFunction * function;

@end
