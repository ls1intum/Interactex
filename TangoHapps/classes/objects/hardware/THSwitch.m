//
//  THSwitch.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/14/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THSwitch.h"
#import "THElementPin.h"

@implementation THSwitch

@dynamic minusPin;
@dynamic plusPin;
@dynamic digitalPin;

-(id) init{
    self = [super init];
    if(self){
        
        THElementPin * pin1 = [THElementPin pinWithType:kElementPintypePlus];
        pin1.hardware = self;
        THElementPin * pin2 = [THElementPin pinWithType:kElementPintypeMinus];
        pin2.hardware = self;
        THElementPin * pin3 = [THElementPin pinWithType:kElementPintypeDigital];
        pin3.hardware = self;
        pin3.defaultBoardPinMode = kPinModeDigitalInput;
        
        [self.pins addObject:pin1];
        [self.pins addObject:pin2];
        [self.pins addObject:pin3];
        
        self.isInputObject = YES;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    self.isInputObject = YES;
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
}

-(id)copyWithZone:(NSZone *)zone
{
    THSwitch * copy = [super copyWithZone:zone];
    return copy;    
}

#pragma mark - Methods

-(THElementPin*) plusPin{
    return [self.pins objectAtIndex:0];
}

-(THElementPin*) minusPin{
    return [self.pins objectAtIndex:1];
}

-(THElementPin*) digitalPin{
    return [self.pins objectAtIndex:2];
}


@end
