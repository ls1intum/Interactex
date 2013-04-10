//
//  THElementPin.h
//  TangoHapps
//
//  Created by Juan Haladjian on 10/15/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//
#import "THPin.h"

@class THClotheObject;
@class THBoardPin;

@interface THElementPin : THPin


@property (nonatomic) THElementPinType type;

+(id) pinWithType:(THElementPinType) type;
-(id) initWithType:(THElementPinType) type;

-(void) attachToPin:(THBoardPin*) pin;
-(void) deattach;

@property (nonatomic,readonly) THBoardPin * attachedToPin;
@property (nonatomic,readonly) BOOL connected;
@property (nonatomic, weak) THClotheObject * hardware;
@property (nonatomic, readonly) NSString * shortDescription;
@property (nonatomic) THPinMode defaultBoardPinMode;

@end
