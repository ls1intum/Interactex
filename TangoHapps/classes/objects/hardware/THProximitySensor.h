//
//  THProximitySensor.h
//  TangoHapps
//
//  Created by Juan Haladjian on 20/06/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THHardwareComponent.h"

@interface THProximitySensor : THHardwareComponent

@property (nonatomic) NSInteger proximity;

@property (nonatomic, readonly) THElementPin * analogPin;
@property (nonatomic, readonly) THElementPin * plusPin;

@end
