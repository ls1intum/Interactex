//
//  THTimer.h
//  TangoHapps
//
//  Created by Juan Haladjian on 2/21/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THTrigger.h"

typedef enum{
    kTimerTypeOnce,
    kTimerTypeAlways
}THTimerType;

@interface THTimer : THTrigger
{
    NSTimer * _timer;
}

@property (nonatomic) double frequency;
@property (nonatomic) THTimerType type;

-(void) start;
-(void) stop;

@end
