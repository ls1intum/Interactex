//
//  THVibrationBoardProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 4/12/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "TFEditableObjectProperties.h"

@interface THVibrationBoardProperties : TFEditableObjectProperties

@property (weak, nonatomic) IBOutlet UILabel *frequencyLabel;
@property (weak, nonatomic) IBOutlet UISlider *frequencySlider;

- (IBAction)frequencyChanged:(id)sender;

@end
