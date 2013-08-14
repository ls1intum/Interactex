//
//  THSwitchEditableObject.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/14/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THHardwareComponentEditableObject.h"

@interface THSwitchEditableObject : THHardwareComponentEditableObject

//-(void) loadExtension;

@property (nonatomic, readonly) THElementPinEditable * minusPin;
@property (nonatomic, readonly) THElementPinEditable * digitalPin;
@property (nonatomic, readonly) THElementPinEditable * plusPin;

@end
