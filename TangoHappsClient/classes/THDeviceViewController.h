//
//  THDeviceViewController.h
//  TangoHapps
//
//  Created by Juan Haladjian on 20/07/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THDeviceSelectionDelegate <NSObject>

-(void) bleDeviceConnected:(BLEService*) service;
-(void) bleDeviceDisconnected:(BLEService*) service;

@end

@interface THDeviceViewController : UIViewController <BLEDiscoveryDelegate, BLEServiceDelegate>
{
    
    NSInteger secondsRemaining;
    NSTimer* refreshingTimer;
    
    BOOL shouldRefreshOnRelease;
    BOOL isRefreshing;
    BOOL isConnecting;
    BOOL shouldDisconnect;
    
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

@property (weak,nonatomic) id<THDeviceSelectionDelegate> delegate;

-(void) disconnect;

@end
