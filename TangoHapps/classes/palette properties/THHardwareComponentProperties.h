//
//  THHardwareComponentProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 12/03/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THEditableObjectProperties.h"

@interface THHardwareComponentProperties : THEditableObjectProperties <UITextFieldDelegate>{
    
    float keyboardHeight;
}
@property (weak, nonatomic) IBOutlet UIButton *autorouteButton;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
- (IBAction)nameChanged:(id)sender;
- (IBAction)autorouteTapped:(id)sender;

@end
