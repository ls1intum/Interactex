//
//  THI2CProtocol.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/14/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THI2CComponent.h"

@protocol THI2CProtocol <NSObject>

-(void) setValuesFromBuffer:(uint8_t*) buffer length:(NSInteger) length;

@property (nonatomic, strong) THI2CComponent * i2cComponent;
@property (nonatomic) THI2CComponentType type;

@end
