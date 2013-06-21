//
//  THiPhoneObjectPropertiesViewController.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/19/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "TFEditableObjectProperties.h"
#import "THColorPicker.h"

@interface THiPhoneViewProperties : TFEditableObjectProperties <THColorPickerDelegate>
{
    int pickingColor;
    THColorPicker *colorPicker;
    UIPopoverController *colorPickerPopover;
}

@property (weak, nonatomic) IBOutlet UISlider * widthSlider;
@property (weak, nonatomic) IBOutlet UISlider * heightSlider;
@property (weak, nonatomic) IBOutlet UILabel * widthLabel;
@property (weak, nonatomic) IBOutlet UILabel * heightLabel;

- (IBAction)widthChanged:(id)sender;
- (IBAction)heightChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *colorLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeColorButton;
- (IBAction)changeColorTapped:(id)sender;

@end
