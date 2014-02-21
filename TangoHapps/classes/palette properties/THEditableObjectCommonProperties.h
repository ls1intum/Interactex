//
//  THEditableObjectCommonProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 21/02/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THEditableObjectProperties.h"

@interface THEditableObjectCommonProperties : THEditableObjectProperties <UITextFieldDelegate>
{
    float keyboardHeight;
}

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
- (IBAction)finishedEditing:(id)sender;

@end
