//
//  THiSwitchEditableProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 10/4/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THEditableObjectProperties.h"

@interface THiSwitchEditableProperties : THEditableObjectProperties
@property (weak, nonatomic) IBOutlet UISwitch *onSwitch;
- (IBAction)onSwitchChanged:(id)sender;

@end
