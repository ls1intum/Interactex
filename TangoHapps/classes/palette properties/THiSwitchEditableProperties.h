//
//  THiSwitchEditableProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 10/4/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "TFEditableObjectProperties.h"

@interface THiSwitchEditableProperties : TFEditableObjectProperties
@property (weak, nonatomic) IBOutlet UISwitch *onSwitch;
- (IBAction)onSwitchChanged:(id)sender;

@end
