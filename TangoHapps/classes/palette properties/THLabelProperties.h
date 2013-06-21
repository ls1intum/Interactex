//
//  THLabelProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/14/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "TFEditableObjectProperties.h"

@interface THLabelProperties : TFEditableObjectProperties

@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)textEntered:(id)sender;

@end
