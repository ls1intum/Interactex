//
//  THiPhoneView.h
//  TangoHapps
//
//  Created by Juan Haladjian on 10/29/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THView.h"

@interface THView : TFSimulableObject{

}

@property (nonatomic, strong) UIView * view;
@property (nonatomic, strong) THView * superview;
@property (nonatomic, strong) NSMutableArray * subviews;

@property (nonatomic) float width;
@property (nonatomic) float height;
@property (nonatomic) float opacity;
@property (nonatomic) CGPoint position;
@property (nonatomic, strong) UIColor * backgroundColor;

-(void) addSubview:(THView*) object;
-(void) removeSubview:(THView*) object;

-(void) removeFromSuperview;
-(void) addToView:(UIView*) aView;


@end
