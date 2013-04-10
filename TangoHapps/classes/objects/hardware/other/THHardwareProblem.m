//
//  THHardwareProblem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/8/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THHardwareProblem.h"
#import "THElementPinEditable.h"
#import "THElementPin.h"

@implementation THHardwareProblem

-(NSString*) description{
    return @"Hardware Problem";
}
@end

@implementation THHardwareProblemNotConnected

-(NSString*) description{
    return [NSString stringWithFormat:@"%@ from %@ not connected",self.pin.shortDescription,self.pin.hardware];
}

@end

@implementation THHardwareProblemConnectedWrong

-(NSString*) description{
    return [NSString stringWithFormat:@"%@ cannot be connected to %@",self.pin,self.pin.attachedToPin];
}

@end