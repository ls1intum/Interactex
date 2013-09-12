//
//  THContactBookProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 12/13/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THEditableObjectProperties.h"

@interface THContactBookProperties : THEditableObjectProperties

@property (weak, nonatomic) IBOutlet UISwitch *callSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *previousSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *nextSwitch;


- (IBAction)callChanged:(id)sender;
- (IBAction)previousChanged:(id)sender;
- (IBAction)nextChanged:(id)sender;

@end
