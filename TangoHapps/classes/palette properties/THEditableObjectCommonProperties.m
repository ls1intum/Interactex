//
//  THEditableObjectCommonProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 21/02/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THEditableObjectCommonProperties.h"

@implementation THEditableObjectCommonProperties

-(NSString*) title {
    return @"Object";
}

-(void) updateNameTextField {
    
    TFEditableObject * object = (TFEditableObject*) self.editableObject;
    self.nameTextField.text = object.objectName;
}

-(void) reloadState {
    [self updateNameTextField];
}

-(void) viewDidLoad {
    [super viewDidLoad];
}

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction) finishedEditing:(id)sender {
    TFEditableObject * object = (TFEditableObject*) self.editableObject;
    object.objectName = self.nameTextField.text;
}


#pragma mark - Scrolling up when textFild

-(void)keyboardWillShow:(NSNotification*) notification {
    
    if(self.nameTextField.editing){
        NSDictionary* userInfo = [notification userInfo];
        CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        keyboardHeight = keyboardSize.width;
        
        [self moveScrollView:YES];
    }
}

-(void)keyboardWillHide:(NSNotification*) notification {
    
    if(self.nameTextField.editing){
        NSDictionary* userInfo = [notification userInfo];
        CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        keyboardHeight = keyboardSize.width;
        
        [self moveScrollView:NO];
    }
}

-(void)moveScrollView:(BOOL)movedUp {

    CGPoint contentOffset = self.scrollView.contentOffset;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = self.scrollView.frame;
    if (movedUp) {
        rect.origin.y -= keyboardHeight;
        rect.size.height += keyboardHeight;
    } else {

        rect.origin.y += keyboardHeight;
        rect.size.height -= keyboardHeight;
    }
    self.scrollView.frame = rect;

    self.scrollView.contentOffset = contentOffset;
    
    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated {

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

@end
