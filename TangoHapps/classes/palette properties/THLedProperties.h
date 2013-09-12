//
//  THLedProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/9/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THEditableObjectProperties.h"

@interface THLedProperties : THEditableObjectProperties
{
    
    
}

@property (weak, nonatomic) IBOutlet UILabel *intensityLabel;
@property (weak, nonatomic) IBOutlet UISlider *intensitySlider;
@property (weak, nonatomic) IBOutlet UISwitch *onSwitch;

- (IBAction)onChanged:(id)sender;
- (IBAction)intensityChanged:(id)sender;

@end
