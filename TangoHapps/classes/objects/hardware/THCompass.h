//
//  THCompass.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/20/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THClotheObject.h"

@class IFI2CComponent;

@interface THCompass : THClotheObject

@property (nonatomic) NSInteger accelerometerX;
@property (nonatomic) NSInteger accelerometerY;
@property (nonatomic) NSInteger accelerometerZ;
@property (nonatomic) NSInteger heading;

@end
