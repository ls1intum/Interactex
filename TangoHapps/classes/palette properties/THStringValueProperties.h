//
//  THStringValueProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/5/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "TFEditableObjectProperties.h"

@interface THStringValueProperties : TFEditableObjectProperties <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)finishedEditing:(id)sender;

@end
