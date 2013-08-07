//
//  THSimulableWorldController.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/24/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THClientProject;
@class THClientRealScene;

@interface THSimulableWorldController : NSObject

@property (nonatomic, strong) THClientProject * currentProject;
@property (nonatomic, strong) THClientRealScene * currentScene;

+(THSimulableWorldController *)sharedInstance;

-(THClientProject*) newProject;

@end