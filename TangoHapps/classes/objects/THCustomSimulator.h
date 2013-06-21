//
//  THCustomSimulator.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/29/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFSimulator.h"

@class THPinsController;

typedef enum{
    kSimulatorStateNormal,
    kSimulatorStatePins
} THSimulatorState;

@interface THCustomSimulator : TFSimulator
{
    THPinsController * _pinsController;
}

@property (nonatomic, readonly) THSimulatorState state;

-(void) addPinsController;
-(void) removePinsController;

@end
