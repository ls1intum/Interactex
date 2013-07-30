//
//  IFPinCell.h
//  iFirmata
//
//  Created by Juan Haladjian on 6/27/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IFPin;

@interface IFPinCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeControl;

@property (weak, nonatomic) IBOutlet UISegmentedControl * digitalControl;
@property (weak, nonatomic) IBOutlet UILabel * valueLabel;
@property (weak, nonatomic) IBOutlet UISlider * slider;
@property (weak, nonatomic) IBOutlet UISwitch *analogSwitch;
@property (weak, nonatomic) IBOutlet UILabel *analogValueLabel;


@property (nonatomic, strong) IFPin * pin;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier pin:(IFPin*) pin;
-(void) updateDigitalLabel;
-(void) updateAnalogLabel;

- (IBAction)segmentedControlChanged:(id)sender;
- (IBAction)analogSwitchChanged:(id)sender;


-(IBAction) digitalControlChanged:(UISegmentedControl*) sender;
-(IBAction) sliderChanged:(UISlider*) sender;

@end
