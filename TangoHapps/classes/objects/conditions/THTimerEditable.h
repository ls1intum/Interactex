//
//  THTimerEditable.h
//  TangoHapps
//
//  Created by Juan Haladjian on 2/21/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THTriggerEditable.h"
#import "THTimer.h"

@interface THTimerEditable : THTriggerEditable


@property (nonatomic) float frequency;
@property (nonatomic) THTimerType type;

-(void) start;
-(void) stop;

@end
