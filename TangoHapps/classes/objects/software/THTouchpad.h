//
//  THTouchpad.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/22/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THiPhoneControl.h"

@interface THTouchpad : THiPhoneControl {
    UIPanGestureRecognizer * _panRecognizer;
    UITapGestureRecognizer * _tapRecognizer;
    UITapGestureRecognizer * _doubleTapRecognizer;
    UIPinchGestureRecognizer * _pinchRecognizer;
    UILongPressGestureRecognizer * _longPressRecognizer;
    
    float _oldDx;
    float _oldDy;
}

@property (nonatomic) float scale;
@property (nonatomic) float dx;
@property (nonatomic) float dy;

@property (nonatomic) float xMultiplier;
@property (nonatomic) float yMultiplier;

@end
