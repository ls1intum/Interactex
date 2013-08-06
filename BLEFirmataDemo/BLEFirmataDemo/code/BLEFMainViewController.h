//
//  BLEFMainViewController.h
//  BLEFirmataDemo
//
//  Created by Juan Haladjian on 8/6/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BLEFirmata.h"

@interface BLEFMainViewController : UIViewController <BLEDiscoveryDelegate, BLEServiceDelegate, BLEServiceDataDelegate>

{
    NSTimer * timer;
}

@property (strong, nonatomic) IFFirmataController * firmataController;
@property (weak, nonatomic) IBOutlet UILabel *connectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *receivedLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)startSendingTapped:(id)sender;

@end
