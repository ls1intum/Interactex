//
//  THElementPinEditable.h
//  TangoHapps
//
//  Created by Juan Haladjian on 10/14/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THPinEditable.h"

@class THBoardPinEditable;
@class THHardwareComponentEditableObject;
@class THWire;

typedef enum{
    kElementPinStateNormal,
    kElementPinStateProblem,
}THElementPinState ;

@interface THElementPinEditable : THPinEditable {
}

@property (nonatomic) THElementPinType type;
@property (nonatomic,readonly) THBoardPinEditable * attachedToPin;
@property (nonatomic,readonly) BOOL connected;
@property (nonatomic, weak) THHardwareComponentEditableObject * hardware;
@property (nonatomic) THElementPinState state;
@property (nonatomic, readonly) NSString * shortDescription;
@property (nonatomic, readonly) THPinMode defaultBoardPinMode;

-(void) attachToPin:(THPinEditable*) pinEditable animated:(BOOL) animated;
-(void) dettachFromPin;

@end
