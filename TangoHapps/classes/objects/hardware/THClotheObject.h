//
//  THSensor.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/7/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THPin.h"
#import "THBoardPin.h"

@class THClothe;
@class IFI2CComponent;

@interface THClotheObject : TFSimulableObject <THPinDelegate>
{
    
}

@property (nonatomic, strong) NSMutableArray * pins;
@property (nonatomic) BOOL isInputObject;
@property (nonatomic, strong) IFI2CComponent * i2cComponent;

-(void) handlePin:(THPin*) pin changedValueTo:(NSInteger) newValue;

@end
