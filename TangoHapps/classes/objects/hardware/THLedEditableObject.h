//
//  THLedEditableObject.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/19/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THClotheObjectEditableObject.h"

@interface THLedEditableObject : THClotheObjectEditableObject {
    CCSprite * _lightSprite;
}
@property (nonatomic) BOOL onAtStart;
@property (nonatomic, readonly) BOOL on;
@property (nonatomic) NSInteger intensity;

@property (nonatomic) THElementPinEditable * minusPin;
@property (nonatomic) THElementPinEditable * digitalPin;

- (void)turnOn;
- (void)turnOff;

-(void) varyIntensity:(NSInteger) di;

@end
