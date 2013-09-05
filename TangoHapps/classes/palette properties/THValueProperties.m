//
//  THValueProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/17/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THValueProperties.h"
#import "THNumberValueEditable.h"

@implementation THValueProperties

-(NSString *)title {
    return @"Value";
}

-(void) updateTextField{
    THNumberValueEditable * value = (THNumberValueEditable*) self.editableObject;
    self.valueTextField.text = [NSString stringWithFormat:@"%f",value.value];
}

- (IBAction)editingFinished:(id)sender {
    NSString * text = self.valueTextField.text;
    float val = text.floatValue;
    THNumberValueEditable * value = (THNumberValueEditable*) self.editableObject;
    value.value = val;
    [self updateTextField];
}

-(void) reloadState{
    [self updateTextField];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setValueTextField:nil];
    [super viewDidUnload];
}


@end
