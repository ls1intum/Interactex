//
//  THBoardPinEditableObject.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/9/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THPinEditable.h"

@class THElementPinEditable;
@class THBoardPin;

@interface THBoardPinEditable : THPinEditable {
}

-(id) initWithPin:(THBoardPin*) pin;

-(void) attachPin:(THElementPinEditable*) pinEditable;
-(void) deattachPin:(THElementPinEditable*) pinEditable;

@property (nonatomic,readonly) NSMutableArray * attachedPins;
@property (nonatomic) NSInteger number;
@property (nonatomic) THPinType type;
@property (nonatomic, readonly) THPinMode mode;
@property (nonatomic) NSInteger value;
@property (nonatomic, readonly) BOOL acceptsManyPins;
@property (nonatomic) BOOL isPWM;
@property (nonatomic) BOOL supportsSCL;
@property (nonatomic) BOOL supportsSDA;

@end
