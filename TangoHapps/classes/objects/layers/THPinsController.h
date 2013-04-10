//
//  THPinsController.h
//  TangoHapps
//
//  Created by Juan Haladjian on 10/26/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <UIKit/UIKit.h>

extern float const kPinsControllerMinHeight;

@interface THPinsController : UIScrollView
{
    NSMutableArray * _containerViews;
    float _currentY;
}

-(void) prepareToDie;

@end
