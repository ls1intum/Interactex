//
//  THClientSceneSelectionViewController.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/25/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THClientGridView.h"

@class LoadingBezel;
@class THClientFakeSceneDataSource;

@interface THClientSceneSelectionViewController : UIViewController <THClientGridViewDataSource, THClientGridViewDelegate, UINavigationControllerDelegate>
{
    NSMutableArray * _scenes;
    LoadingBezel * _bezel;
    THClientFakeSceneDataSource * _fakeScenesSource;
}

@end
