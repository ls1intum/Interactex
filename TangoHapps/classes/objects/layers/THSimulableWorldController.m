//
//  THSimulableWorldController.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/24/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THSimulableWorldController.h"
#import "THClientProject.h"
#import "THClientRealScene.h"

@implementation THSimulableWorldController

static THSimulableWorldController* _sharedInstance = nil;

+(THSimulableWorldController *)sharedInstance {
    @synchronized(self)
    {
        if (_sharedInstance == NULL)
            _sharedInstance = [[self alloc] init];
    }
    
    return(_sharedInstance);
}

-(THClientProject*) newProject{
    self.currentProject = [THClientProject emptyProject];
    return self.currentProject;
}

@end
