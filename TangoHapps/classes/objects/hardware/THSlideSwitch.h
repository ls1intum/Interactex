//
//  THSwitch.h
//  TangoHapps
//
//  Created by Juan Haladjian on 10/11/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THHardwareComponent.h"
#import "THSwitch.h"

@interface THSlideSwitch : THSwitch
{
}

@property (nonatomic) BOOL on;

-(void) switchOn;
-(void) switchOff;
-(void) toggle;

@end
