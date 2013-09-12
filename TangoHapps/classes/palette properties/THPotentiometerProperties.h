//
//  THPotentiometerProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 1/7/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THEditableObjectProperties.h"

@interface THPotentiometerProperties : THEditableObjectProperties

@property (weak, nonatomic) IBOutlet UISegmentedControl *behaviorControl;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UISlider *minSlider;
@property (weak, nonatomic) IBOutlet UISlider *maxSlider;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

- (IBAction)minChanged:(id)sender;
- (IBAction)maxChanged:(id)sender;
- (IBAction)behaviorChanged:(id)sender;

@end
