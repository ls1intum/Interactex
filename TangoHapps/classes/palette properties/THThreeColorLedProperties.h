//
//  THThreeColorLedProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 1/8/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THEditableObjectProperties.h"

@interface THThreeColorLedProperties : THEditableObjectProperties

@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;

@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;

- (IBAction)redChanged:(id)sender;
- (IBAction)greenChanged:(id)sender;
- (IBAction)blueChanged:(id)sender;

@end
