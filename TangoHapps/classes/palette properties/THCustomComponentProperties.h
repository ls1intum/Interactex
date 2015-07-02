//
//  THCustomComponentProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 30/06/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THEditableObjectProperties.h"

@interface THCustomComponentProperties : THEditableObjectProperties

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextView *codeTextView;
- (IBAction)editingFinished:(id)sender;

@end
