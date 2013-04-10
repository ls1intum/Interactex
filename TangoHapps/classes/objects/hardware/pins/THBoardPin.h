//
//  THHardwarePin.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/9/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THPin.h"

@class THSimulableObject;
@class THElementPin;
@class THPin;

@protocol THPinDelegate <NSObject>
-(void) handlePin:(THPin*) pin changedValueTo:(NSInteger) newValue;
@end

@interface THBoardPin : THPin {
    
}

@property (nonatomic) NSInteger currentValue;
@property (nonatomic) NSInteger number;
@property (nonatomic) THPinType type;
@property (nonatomic) THPinMode mode;
@property (nonatomic, readonly) NSMutableArray * attachedPins;
@property (nonatomic) BOOL hasChanged;
@property (nonatomic, readonly) BOOL acceptsManyPins;
@property (nonatomic) BOOL isPWM;

+(id) pinWithPinNumber:(NSInteger) pinNumber andType:(THPinType) type;
-(id) initWithPinNumber:(NSInteger) pinNumber andType:(THPinType) type;

-(void) attachPin:(THElementPin*) pin;
-(void) deattachPin:(THElementPin*) pin;

@end
