//
//  THGestures.h
//  TangoHapps
//
//  Created by Timm Beckmann on 03/04/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THView;

@interface THGesture : TFSimulableObject {
    
}

@property (nonatomic) CGPoint position;
@property (nonatomic, strong) THView * currentView;

-(void) saveGesture;

-(void) removeFromSuperview;
-(void) addToView:(UIView*) aView;

@end

