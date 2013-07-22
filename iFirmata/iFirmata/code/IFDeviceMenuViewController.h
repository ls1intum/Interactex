//
//  IFDeviceMenuViewController.h
//  iFirmata
//
//  Created by Juan Haladjian on 6/30/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEService.h"

@class CBPeripheral;
@class IFFirmataController;

@interface IFDeviceMenuViewController : UIViewController <BLEServiceDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UIButton *firmataButton;
@property (weak, nonatomic) IBOutlet UIButton *characteristicsButton;

@property (nonatomic, strong) CBPeripheral * currentPeripheral;
@property (nonatomic, strong) BLEService * bleService;
@property (nonatomic, strong) IFFirmataController * firmataController;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
