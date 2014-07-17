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
@class IFI2CRegisterViewController;

@protocol IFGenericI2CDelegate <NSObject>

-(void) I2CDevice:(IFI2CComponent*) component wroteData:(NSString*) data;/*
-(void) I2CDeviceStarted:(IFI2CComponent*) component;
-(void) I2CDeviceStopped:(IFI2CComponent*) component;*/

@end

@interface IFI2CViewController : UIViewController

- (IBAction)startTapped:(id)sender;
- (IBAction)stopTapped:(id)sender;

@property (weak, nonatomic) IFI2CComponentProxy * component;
@property (weak, nonatomic) id<IFGenericI2CDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
