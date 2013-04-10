//
//  THThreeColorLed.h
//  TangoHapps
//
//  Created by Juan Haladjian on 1/7/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THClotheObject.h"

@interface THThreeColorLed : THClotheObject

@property (nonatomic) BOOL onAtStart;
@property (nonatomic) BOOL on;

@property (nonatomic) NSInteger red;
@property (nonatomic) NSInteger green;
@property (nonatomic) NSInteger blue;

@property (nonatomic) THElementPin * minusPin;
@property (nonatomic) THElementPin * redPin;
@property (nonatomic) THElementPin * greenPin;
@property (nonatomic) THElementPin * bluePin;

-(void) turnOn;
-(void) turnOff;
-(void) varyIntensity:(NSInteger) di;

@end
