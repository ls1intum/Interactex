//
//  IFDeviceMenuViewController.h
//  iFirmata
//
//  Created by Juan Haladjian on 6/30/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CBPeripheral;
@class GMPPinsController;

@interface GMPDeviceMenuViewController : UIViewController
{
    
}

@property (weak, nonatomic) IBOutlet UIButton *firmataButton;
@property (weak, nonatomic) IBOutlet UIButton *characteristicsButton;

@property (nonatomic, strong) CBPeripheral * currentPeripheral;

@end
