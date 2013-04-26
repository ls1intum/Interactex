//
//  THVibrationBoard.h
//  TangoHapps
//
//  Created by Juan Haladjian on 4/12/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THClotheObject.h"

@interface THVibrationBoard : THClotheObject

@property (nonatomic) BOOL on;
@property (nonatomic) NSInteger frequency;

@property (nonatomic) THElementPin * minusPin;
@property (nonatomic) THElementPin * digitalPin;

-(void) turnOn;
-(void) turnOff;

@end
