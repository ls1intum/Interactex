//
//  THiPhoneButtonProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/9/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THEditableObjectProperties.h"

@interface THiPhoneButtonProperties : THEditableObjectProperties <UITextFieldDelegate>
{
}

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *captionText;

- (IBAction)textEntered:(id)sender;

@end
