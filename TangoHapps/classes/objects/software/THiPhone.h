//
//  THiPhone.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/9/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THView;

@interface THiPhone : TFSimulableObject {
   
}

@property (nonatomic) CGPoint position;
@property (nonatomic) THIPhoneType type;
@property (nonatomic, strong) THView * currentView;

-(void) makeEmergencyCall;

-(void) removeFromSuperview;
-(void) addToView:(UIView*) aView;

@end

