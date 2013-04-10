//
//  THElementPinEditable.h
//  TangoHapps
//
//  Created by Juan Haladjian on 10/14/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THPinEditable.h"

@class THBoardPinEditable;
@class THClotheObjectEditableObject;

typedef enum{
    kElementPinStateNormal,
    kElementPinStateProblem,
}THElementPinState ;

@interface THElementPinEditable : THPinEditable {
}

-(void) attachToPin:(THPinEditable*) pinEditable animated:(BOOL) animated;
-(void) deattach;

@property (nonatomic) THElementPinType type;
@property (nonatomic,readonly) THBoardPinEditable * attachedToPin;
@property (nonatomic,readonly) BOOL connected;
@property (nonatomic, weak) THClotheObjectEditableObject * hardware;
@property (nonatomic) THElementPinState state;
@property (nonatomic, readonly) NSString * shortDescription;
@property (nonatomic, readonly) THPinMode defaultBoardPinMode;

@end
