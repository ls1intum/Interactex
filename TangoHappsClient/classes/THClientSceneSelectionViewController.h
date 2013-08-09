//
//  THClientSceneSelectionViewController.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/25/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THClientGridView.h"
#import "THClientConnectionController.h"

@class LoadingBezel;
@class THClientFakeSceneDataSource;

const NSTimeInterval kMinInstallationDuration;
const float kIconInstallationUpdateFrequency;

@interface THClientSceneSelectionViewController : UIViewController <THClientGridViewDataSource, THClientGridViewDelegate, THClientConnectionControllerDelegate> {
    NSMutableArray * scenes;
    LoadingBezel * bezel;
    
    NSTimer * installationProgressTimer;
    THClientGridItem * gridItemBeingInstalled;
    NSTimeInterval timeWhenInstallationStarted;
    float installationUpdateRate;

    THClientScene * alreadyExistingSceneBeingInstalled;
}

@property (nonatomic, strong) THClientConnectionController * connectionController;

@property (nonatomic, strong) THClientFakeSceneDataSource * fakeScenesSource;

@end
