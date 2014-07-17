//
//  IFI2CComponentProxy.h
//  iFirmata
//
//  Created by Juan Haladjian on 15/07/14.
//  Copyright (c) 2014 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IFI2CComponent;

@interface IFI2CComponentProxy : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, weak) IFI2CComponent * component;

@end
