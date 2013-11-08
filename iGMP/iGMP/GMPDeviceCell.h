//
//  IFDeviceCell.h
//  iFirmata
//
//  Created by Juan Haladjian on 7/26/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMPDeviceCell;


@interface GMPDeviceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *uiidLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
