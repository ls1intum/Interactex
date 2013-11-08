//
//  GMPViewController.h
//  iGMP
//
//  Created by Juan Haladjian on 11/6/13.
//  Copyright (c) 2013 Technical University Munich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMP;
@class GMPDelegate;

@interface GMPViewController : UIViewController <BLEDiscoveryDelegate, BLEServiceDelegate>

- (IBAction)sendFirmwareTapped:(id)sender;
- (IBAction)sendModesTapped:(id)sender;
- (IBAction)sendGroupTapped:(id)sender;
- (IBAction)sendResetTapped:(id)sender;
- (IBAction)sendI2CTapped:(id)sender;
- (IBAction)sendI2CStopTapped:(id)sender;

@property (nonatomic, strong) GMP * gmpController;
@property (nonatomic, strong) GMPDelegate * gmpDelegate;

@end
