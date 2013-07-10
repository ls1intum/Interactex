//
//  IFFirmataViewController.h
//  iFirmata
//
//  Created by Juan Haladjian on 6/27/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IFFirmataController;
@class CBPeripheral;

@interface IFFirmataViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    BOOL connected;
}

@property (nonatomic, weak) IFFirmataController * firmataController;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
