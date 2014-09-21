//
//  IFI2CViewController.h
//  iFirmata
//
//  Created by Juan Haladjian on 15/07/14.
//  Copyright (c) 2014 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IFI2CComponent;
@class IFI2CComponentProxy;
@class IFI2CGenericViewController;
@class IFFirmata;

@interface IFI2CLSM303ViewController : UIViewController

- (IBAction)startTapped:(id)sender;
- (IBAction)stopTapped:(id)sender;

@property (weak, nonatomic) IFI2CComponentProxy * component;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak,nonatomic) IFFirmata * firmata;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@end
