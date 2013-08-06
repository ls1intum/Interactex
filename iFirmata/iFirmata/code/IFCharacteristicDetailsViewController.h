//
//  IFCharacteristicDetailsViewController.h
//  iFirmata
//
//  Created by Juan Haladjian on 6/30/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEService.h"

@interface IFCharacteristicDetailsViewController : UIViewController <UITextFieldDelegate, BLEServiceDataDelegate>
{
    float keyboardHeight;
}

@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;

@property (nonatomic, weak) CBCharacteristic * currentCharacteristic;
@property (nonatomic, weak) BLEService * bleService;

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UISegmentedControl *notifyControl;

@property (weak, nonatomic) IBOutlet UITextField *writeText;
@property (weak, nonatomic) IBOutlet UIButton *writeButton;

- (IBAction)readPushed:(id)sender;

- (IBAction)writePushed:(id)sender;
- (IBAction)textChanged:(id)sender;
- (IBAction)notifyChanged:(id)sender;
@end
