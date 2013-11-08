//
//  MainViewController.h
//  iFirmata
//
//  Created by Juan Haladjian on 6/27/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GMPDeviceCell.h"
#import <AudioToolbox/AudioToolbox.h>

@class GMPPinsController;

extern const NSInteger GMPRefreshHeaderHeight;
extern const NSInteger GMPDiscoveryTime;

@interface GMPMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, BLEDiscoveryDelegate, BLEServiceDelegate>
{    
    NSInteger secondsRemaining;
    NSTimer* refreshingTimer;
    
    BOOL shouldRefreshOnRelease;
    BOOL isRefreshing;
    BOOL isDisconnecting;
    
    NSIndexPath * connectingRow;
    
    NSTimer* connectingTimer;
    
    SystemSoundID pullDownSound;
    SystemSoundID pullUpSound;
    
    NSInteger refreshHeaderTop;
}


@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *refreshView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *refreshingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end
