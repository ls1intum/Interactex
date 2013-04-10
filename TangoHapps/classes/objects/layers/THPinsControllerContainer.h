//
//  THPinsControllerContainer.h
//  TangoHapps
//
//  Created by Juan Haladjian on 10/29/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <UIKit/UIKit.h>

extern float const kPinControllerContainerHeight;
extern float const kPinControllerPadding;
extern float const kPinControllerInnerPadding;

@class THBoardPinEditable;
@class THPinsControllerContainer;


@interface THPinsControllerContainer : UIView
{
    UISegmentedControl * _segmentedControl;
    UILabel * _valueLabel;
    UISlider * _slider;
}

@property (nonatomic,weak) THBoardPinEditable * pin;

-(void) prepareToDie;

@end
