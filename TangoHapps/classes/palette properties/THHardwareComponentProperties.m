//
//  THHardwareComponentProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 12/03/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THHardwareComponentProperties.h"
#import "THHardwareComponentEditableObject.h"

@implementation THHardwareComponentProperties


-(NSString*) title {
    return @"Hardware Component";
}

-(void) reloadState {
    [self updateNameTextField];
    
    THEditor * editor = (THEditor*) [THDirector sharedDirector].currentLayer;
    THProject * project = [THDirector sharedDirector].currentProject;
    
    if(editor.isLilypadMode && project.boards.count > 0){
        
        self.autorouteButton.enabled = YES;
        
    } else {
        
        self.autorouteButton.enabled = NO;
    }
}

-(void) updateNameTextField {
    
    THHardwareComponentEditableObject * object = (THHardwareComponentEditableObject*) self.editableObject;
    self.nameTextField.text = object.objectName;
}

-(IBAction) finishedEditing:(id)sender {
    THHardwareComponentEditableObject * object = (THHardwareComponentEditableObject*) self.editableObject;
    object.objectName = self.nameTextField.text;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Methods

- (IBAction)nameChanged:(id)sender {
    THHardwareComponentEditableObject * object = (THHardwareComponentEditableObject*) self.editableObject;
    object.objectName = self.nameTextField.text;
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)autorouteTapped:(id)sender {
    THHardwareComponentEditableObject * object = (THHardwareComponentEditableObject*) self.editableObject;
    [object autoroute];
}

/*
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
*/

@end
