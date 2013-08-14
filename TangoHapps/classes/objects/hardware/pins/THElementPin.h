//
//  THElementPin.h
//  TangoHapps
//
//  Created by Juan Haladjian on 10/15/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//
#import "THPin.h"
#import "THBoardPin.h"

@class THHardwareComponent;

@interface THElementPin : THPin


@property (nonatomic) THElementPinType type;
@property (nonatomic,readonly) THBoardPin * attachedToPin;
@property (nonatomic,readonly) BOOL connected;
@property (nonatomic, weak) THHardwareComponent * hardware;
@property (nonatomic, readonly) NSString * shortDescription;
@property (nonatomic) THPinMode defaultBoardPinMode;

+(id) pinWithType:(THElementPinType) type;
-(id) initWithType:(THElementPinType) type;

-(void) attachToPin:(THBoardPin*) pin;
-(void) deattach;

@end
