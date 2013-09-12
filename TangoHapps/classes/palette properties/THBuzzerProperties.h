//
//  THBuzzerProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THEditableObjectProperties.h"

@interface THBuzzerProperties : THEditableObjectProperties
{
    float f;
    int a;
    NSObject *object;
}


@property (weak, nonatomic) IBOutlet UISlider *frequencySlider;
@property (weak, nonatomic) IBOutlet UILabel *frequencyLabel;

- (IBAction)frequencySliderChanged:(id)sender;

- (IBAction)testTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UISwitch *onSwitch;
- (IBAction)onChanged:(id)sender;

@end
