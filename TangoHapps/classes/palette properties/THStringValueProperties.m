//
//  THStringValueProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/5/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THStringValueProperties.h"
#import "THStringValueEditable.h"

@implementation THStringValueProperties

-(NSString*) title{
    return @"String Value";
}

-(void) updateString{
    
    THStringValueEditable * value = (THStringValueEditable*) self.editableObject;
    self.textField.text = value.value;
}

-(void) reloadState{
    
    [self updateString];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.textField resignFirstResponder];
    
    return YES;
}

- (IBAction)finishedEditing:(id)sender {
    
    THStringValueEditable * value = (THStringValueEditable*) self.editableObject;
    value.value = self.textField.text;
}

@end
