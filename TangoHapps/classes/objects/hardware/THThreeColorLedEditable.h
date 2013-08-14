//
//  THThreeColorLedEditable.h
//  TangoHapps
//
//  Created by Juan Haladjian on 1/7/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THHardwareComponentEditableObject.h"

@interface THThreeColorLedEditable : THHardwareComponentEditableObject{
    CCSprite * _lightSprite;
}

@property (nonatomic) BOOL onAtStart;
@property (nonatomic, readonly) BOOL on;


@property (nonatomic) NSInteger red;
@property (nonatomic) NSInteger green;
@property (nonatomic) NSInteger blue;

@property (nonatomic) THElementPinEditable * minusPin;
@property (nonatomic) THElementPinEditable * redPin;
@property (nonatomic) THElementPinEditable * greenPin;
@property (nonatomic) THElementPinEditable * bluePin;

- (void)turnOn;
- (void)turnOff;

@end
