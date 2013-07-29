//
//  IFCharacteristicsViewController.h
//  iFirmata
//
//  Created by Juan Haladjian on 6/30/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLEService;

@interface IFCharacteristicsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;

@end
