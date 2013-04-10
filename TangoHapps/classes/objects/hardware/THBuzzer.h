//
//  THBuzzer.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THClotheObject.h"

@class THToneGenerator;

@interface THBuzzer : THClotheObject {
}

-(void) turnOn;
-(void) turnOff;
-(void) varyFrequency:(float) dt;

@property (nonatomic) BOOL on;
@property (nonatomic) float frequency;
@property (nonatomic) THElementPin * minusPin;
@property (nonatomic) THElementPin * digitalPin;

@end
