//
//  THiPhoneButtonProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/9/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THiPhoneButtonProperties.h"
#import "THiPhoneButtonEditableObject.h"

@implementation THiPhoneButtonProperties

-(NSString*) title{
    return @"Button";
}

- (IBAction)textEntered:(id)sender{
    
    THiPhoneButtonEditableObject * iPhoneButton = (THiPhoneButtonEditableObject*) self.editableObject;
    iPhoneButton.text = self.captionText.text;
}

-(void) reloadState{
    THiPhoneButtonEditableObject * iPhoneButton = (THiPhoneButtonEditableObject*) self.editableObject;
    
    self.captionText.text = iPhoneButton.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.captionText resignFirstResponder];
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.captionText.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCaptionText:nil];
    
    [super viewDidUnload];
}

@end
