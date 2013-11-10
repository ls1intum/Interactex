//
//  GMPAppDelegate.h
//  iGMP
//
//  Created by Juan Haladjian on 11/6/13.
//  Copyright (c) 2013 Technical University Munich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMPPinsController;

@interface GMPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GMPPinsController *gmpController;

@end
