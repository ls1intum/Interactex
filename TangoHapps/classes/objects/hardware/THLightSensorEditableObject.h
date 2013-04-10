//
//  THLightSensorEditableObject.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/12/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THClotheObjectEditableObject.h"

@interface THLightSensorEditableObject : THClotheObjectEditableObject
{
    CCSprite * _lightSprite;
    float _lightTouchDownIntensity;
}

@property (nonatomic, readonly) NSInteger light;
@property (nonatomic) NSInteger isDown;

@property (nonatomic, readonly) THElementPinEditable * minusPin;
@property (nonatomic, readonly) THElementPinEditable * analogPin;
@property (nonatomic, readonly) THElementPinEditable * plusPin;

@end
