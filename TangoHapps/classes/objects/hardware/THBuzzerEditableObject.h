//
//  THBuzzerEditableObject.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/19/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THClotheObjectEditableObject.h"

@class THToneGenerator;

@interface THBuzzerEditableObject : THClotheObjectEditableObject
{
    CCAction * shakeAction;
    
    THToneGenerator * toneGenerator;
}

@property (nonatomic) BOOL on;
@property (nonatomic) BOOL onAtStart;
@property (nonatomic) float frequency;
@property (nonatomic) THElementPinEditable * minusPin;
@property (nonatomic) THElementPinEditable * digitalPin;

-(void) varyFrequency:(float) dt;
-(void) turnOn;
-(void) turnOff;

-(void) handleBuzzerOn;
-(void) handleBuzzerOff;

@end
