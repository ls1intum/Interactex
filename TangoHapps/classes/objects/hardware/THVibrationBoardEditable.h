//
//  THVibrationBoardEditable.h
//  TangoHapps
//
//  Created by Juan Haladjian on 4/12/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THClotheObjectEditableObject.h"

@interface THVibrationBoardEditable : THClotheObjectEditableObject{
    CCSprite * _lightSprite;
}

@property (nonatomic) BOOL onAtStart;
@property (nonatomic, readonly) BOOL on;
@property (nonatomic) NSInteger frequency;

@property (nonatomic) THElementPinEditable * minusPin;
@property (nonatomic) THElementPinEditable * digitalPin;

- (void)turnOn;
- (void)turnOff;

@end