//
//  THPressureSensorEditableObject.m
//  TangoHapps
//
//  Created by Guven Candogan on 15/01/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THPressureSensorEditableObject.h"

@implementation THPressureSensorEditableObject

@dynamic pressure;

-(void) loadPressureSensor{
    self.sprite = [CCSprite spriteWithFile:@"pressureSensor.png"];
}

@end
