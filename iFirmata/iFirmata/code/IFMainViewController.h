//
//  MainViewController.h
//  iFirmata
//
//  Created by Juan Haladjian on 6/27/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEDiscovery.h"

@class IFFirmataController;

extern const NSInteger IFRefreshHeaderHeight;
extern const NSInteger IFDiscoveryTime;

@interface IFMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, BLEDiscoveryDelegate>
{    
    NSInteger secondsRemaining;
    NSTimer* timer;
    
    BOOL isRefreshing;
   // BOOL isDragging;
}


@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *refreshView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *refreshingLabel;
@property (weak, nonatomic) IBOutlet UIButton *stopRefreshingButton;

- (IBAction)stopRefreshingPushed:(id)sender;

@end
