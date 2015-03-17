//
//  THActivityRecognition.h
//  TangoHapps
//
//  Created by Juan Haladjian on 16/03/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THProgrammingElement.h"
#import "THAccelerometerData.h"

#define kActivityRecognitionNumSamples 30

typedef enum : NSUInteger {
    kActivityStateStanding,
    kActivityStateWalking,
    kActivityStateRunning,
    kActivityStateUnconscious
} ActivityState;

@interface THActivityRecognition : THProgrammingElement {
    
    THAccelerometerData* buffer[kActivityRecognitionNumSamples];
    NSInteger count;
}

-(void) addSample:(THAccelerometerData*) sample;
@end
