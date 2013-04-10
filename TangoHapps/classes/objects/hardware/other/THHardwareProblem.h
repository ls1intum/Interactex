//
//  THHardwareProblem.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/8/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THElementPinEditable;

@interface THHardwareProblem : NSObject

@property (nonatomic) THElementPinEditable * pin;

@end


@interface THHardwareProblemNotConnected : THHardwareProblem

//@property (nonatomic) THElementPinEditable * pin;

@end

@interface THHardwareProblemConnectedWrong : THHardwareProblem

//@property (nonatomic) THElementPinEditable * pin;

@end