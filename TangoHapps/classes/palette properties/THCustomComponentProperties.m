//
//  THHardwareComponentProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 12/03/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THCustomComponentProperties.h"
#import "THCustomComponentEditable.h"

@implementation THCustomComponentProperties


-(NSString*) title {
    return @"Hardware Component";
}

-(void) reloadState {
    [self updateNameTextField];
    [self updateCodeTextView];
}

-(void) updateNameTextField {
    
    THCustomComponentEditable * customComponent = (THCustomComponentEditable*) self.editableObject;
    self.nameTextField.text = customComponent.name;
}

-(void) updateCodeTextView {
    
    THCustomComponentEditable * customComponent = (THCustomComponentEditable*) self.editableObject;
    self.codeTextView.text = customComponent.code;
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


- (IBAction)editingFinished:(id)sender {
    
    THCustomComponentEditable * customComponent = (THCustomComponentEditable*) self.editableObject;
    BOOL exists = [[THDirector sharedDirector] doesComponentExistWithName:self.nameTextField.text];
    if(!exists){
        customComponent.name = self.nameTextField.text;
    }
}

@end
