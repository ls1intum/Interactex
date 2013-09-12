//
//  THBoolValueProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/5/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THEditableObjectProperties.h"

@interface THBoolValueProperties : THEditableObjectProperties
@property (weak, nonatomic) IBOutlet UISwitch *valueSwitch;
- (IBAction)valueChanged:(id)sender;

@end
