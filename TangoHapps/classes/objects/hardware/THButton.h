//
//  THButton.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/14/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THSwitch.h"

@interface THButton : THSwitch
{
}

@property (nonatomic) BOOL isDown;

-(void) handleStartedPressing;
-(void) handleStoppedPressing;


@end
