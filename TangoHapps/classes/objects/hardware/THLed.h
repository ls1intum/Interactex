//
//  Led.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THClotheObject.h"

@class THElementPin;

@interface THLed : THClotheObject
{
}

@property (nonatomic) BOOL onAtStart;
@property (nonatomic) BOOL on;
@property (nonatomic) NSInteger intensity;

@property (nonatomic) THElementPin * minusPin;
@property (nonatomic) THElementPin * digitalPin;

-(void) turnOn;
-(void) turnOff;
-(void) varyIntensity:(NSInteger) di;

@end
