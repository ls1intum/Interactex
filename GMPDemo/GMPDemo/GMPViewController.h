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

@interface GMPViewController : UIViewController <BLEDiscoveryDelegate, BLEServiceDelegate, GMPControllerDelegate>
{
    BOOL reportingDigital;
    BOOL reportingAnalog;
}
@property (weak, nonatomic) IBOutlet UIButton *digitalReportButton;
@property (weak, nonatomic) IBOutlet UIButton *analogReportButton;
@property (weak, nonatomic) IBOutlet UIButton *connectionButton;

- (IBAction)reconnectTapped:(id)sender;

- (IBAction)sendFirmwareTapped:(id)sender;
- (IBAction)sendModesTapped:(id)sender;
- (IBAction)sendHighTapped:(id)sender;
- (IBAction)sendLOWTapped:(id)sender;

- (IBAction)sendDigitalReadTapped:(id)sender;
- (IBAction)sendAnalogReadTapped:(id)sender;


- (IBAction)sendI2CReadTapped:(id)sender;
- (IBAction)sendI2CWriteTapped:(id)sender;

- (IBAction)sendI2CStartReadingTapped:(id)sender;

- (IBAction)sendI2CStopTapped:(id)sender;
- (IBAction)sendResetTapped:(id)sender;
- (IBAction)startDigitalReadTapped:(id)sender;
- (IBAction)startAnalogReadTapped:(id)sender;
- (IBAction)sendAnalogOutputTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *textField;

@property (nonatomic, strong) GMP * gmpController;
@property (nonatomic, strong) GMPDelegate * gmpDelegate;

@end
