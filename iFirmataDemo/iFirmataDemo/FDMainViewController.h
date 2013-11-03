//
//  FDMainViewController.h
//  iFirmataDemo
//
//  Created by Juan Haladjian on 10/21/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEDiscovery.h"
#import "IFFirmataController.h"

@interface FDMainViewController : UIViewController <BLEDiscoveryDelegate, BLEServiceDelegate, IFFirmataControllerDelegate>

@property (nonatomic) BOOL on;

@property (nonatomic, weak) CBPeripheral * availablePeripheral;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (strong, nonatomic) IFFirmataController *firmataController;

- (IBAction)sendTapped:(id)sender;
- (IBAction)connectTapped:(id)sender;

- (IBAction)sendFirmwareTapped:(id)sender;
- (IBAction)sendCapabilitiesTapped:(id)sender;

@end
