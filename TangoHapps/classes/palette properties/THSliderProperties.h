//
//  THSliderProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 12/9/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//


@interface THSliderProperties : TFEditableObjectProperties

@property (weak, nonatomic) IBOutlet UISlider *valueSlider;
@property (weak, nonatomic) IBOutlet UISlider *minSlider;
@property (weak, nonatomic) IBOutlet UISlider *maxSlider;

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;

- (IBAction)valueChanged:(id)sender;
- (IBAction)minChanged:(id)sender;
- (IBAction)maxChanged:(id)sender;

@end
