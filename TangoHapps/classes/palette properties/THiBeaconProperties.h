//
//  THiBeaconProperties.h
//  TangoHapps
//
//  Created by Guven Candogan on 16/09/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THEditableObjectProperties.h"

@interface THiBeaconProperties : THEditableObjectProperties
@property (weak, nonatomic) IBOutlet UITextField *uuidText;
- (IBAction)uuidTextChanged:(id)sender;
@end
