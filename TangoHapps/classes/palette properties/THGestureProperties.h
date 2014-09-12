//
//  THGestureProperties.h
//  TangoHapps
//
//  Created by Timm Beckmann on 18/04/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THEditableObjectProperties.h"

@interface THGestureProperties : THEditableObjectProperties

@property (weak, nonatomic) IBOutlet UILabel * scaleLabel;
@property (weak, nonatomic) IBOutlet UISlider *scaleSlider;
- (IBAction)scaleChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *stepperLabel;
@property (weak, nonatomic) IBOutlet UIStepper *outputStepper;
- (IBAction)outputChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
- (IBAction)nameChanged:(id)sender;

@end
