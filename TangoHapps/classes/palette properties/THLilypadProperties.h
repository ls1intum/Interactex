//
//  THLilypadProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/14/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//


@interface THLilypadProperties : TFEditableObjectProperties
{
    NSMutableArray * _pinViews;
    float _currentY;
}
@property (weak, nonatomic) IBOutlet UIScrollView *containerView;


@end
