//
//  THSwitch.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/14/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THClotheObject.h"

@interface THSwitch : THClotheObject


@property (nonatomic, readonly) THElementPin * minusPin;
@property (nonatomic, readonly) THElementPin * digitalPin;
@property (nonatomic, readonly) THElementPin * plusPin;

@end
