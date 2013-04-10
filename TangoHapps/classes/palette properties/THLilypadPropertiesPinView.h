//
//  THLilypadPropertiesPinView.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/14/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THBoardPinEditable;
extern float const kLilypadPropertyInnerPadding;

@interface THLilypadPropertiesPinView : UIView {
    UISegmentedControl * _segmentedControl;
    UIView * _modeView;
}

@property (nonatomic,weak) THBoardPinEditable * pin;

@end
