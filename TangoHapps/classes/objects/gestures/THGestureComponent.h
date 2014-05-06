//
//  THGestureComponent.h
//  TangoHapps
//
//  Created by Timm Beckmann on 06.05.14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THPin.h"
#import "THBoardPin.h"

@class THGesture;
@class THI2CComponent;

@interface THGestureComponent : TFSimulableObject <THPinDelegate>

@property (nonatomic, strong) NSMutableArray * pins;
@property (nonatomic) BOOL isInputObject;

-(void) handlePin:(THPin*) pin changedValueTo:(NSInteger) newValue;

@end