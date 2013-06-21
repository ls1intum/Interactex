//
//  THTouchpadProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/22/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "TFEditableObjectProperties.h"

@interface THTouchpadProperties : TFEditableObjectProperties

@property (weak, nonatomic) IBOutlet UISlider *xMultiplierSlider;
@property (weak, nonatomic) IBOutlet UISlider *yMultiplierSlider;
@property (weak, nonatomic) IBOutlet UILabel *xMultiplierLabel;
@property (weak, nonatomic) IBOutlet UILabel *yMultiplierLabel;
- (IBAction)xMultiplierChanged:(id)sender;
- (IBAction)yMultiplierChanged:(id)sender;
 
@end
