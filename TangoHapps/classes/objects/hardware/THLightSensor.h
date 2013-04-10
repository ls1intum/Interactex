//
//  THLightSensor.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/12/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THClotheObject.h"

@interface THLightSensor : THClotheObject

@property (nonatomic) NSInteger light;

@property (nonatomic, readonly) THElementPin * minusPin;
@property (nonatomic, readonly) THElementPin * analogPin;
@property (nonatomic, readonly) THElementPin * plusPin;

@end
