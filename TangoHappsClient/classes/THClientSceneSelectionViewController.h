//
//  THClientSceneSelectionViewController.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/25/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THClientGridView.h"
#import "THClientConnectionViewController.h"

@class LoadingBezel;
@class THClientFakeSceneDataSource;

@interface THClientSceneSelectionViewController : UIViewController <THClientGridViewDataSource, THClientGridViewDelegate, UINavigationControllerDelegate, THClientConnectionControllerDelegate> {
    NSMutableArray * scenes;
    LoadingBezel * bezel;
    THClientFakeSceneDataSource * fakeScenesSource;
    
    NSTimer * installationProgressTimer;
    THClientGridItem * sceneBeingInstalled;
    BOOL finishedInstallingProject;
}

@end
