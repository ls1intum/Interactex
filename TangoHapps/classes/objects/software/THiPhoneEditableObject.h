//
//  THiPhoneEditableObject.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/19/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//


@class THiPhone;
@class THView;
@class THViewEditableObject;

@interface THiPhoneEditableObject : TFEditableObject{
    
}

+(id) iPhoneWithDefaultView;

-(void) removeFromSuperview;
-(void) addToView:(UIView*) aView;

@property (nonatomic, strong) THViewEditableObject * currentView;
@property (nonatomic) THIPhoneType type;

@end
