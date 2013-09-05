//
//  THBoolValueProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/5/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THBoolValueProperties.h"
#import "THBoolValueEditable.h"

@implementation THBoolValueProperties


-(NSString*) title{
    return @"Bool Value";
}

-(void) updateSwitch{
    
    THBoolValueEditable * value = (THBoolValueEditable*) self.editableObject;
    self.valueSwitch.on = value.value;
}

-(void) reloadState{
    
    [self updateSwitch];
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

- (IBAction)valueChanged:(id)sender {
    
    THBoolValueEditable * value = (THBoolValueEditable*) self.editableObject;
    value.value = self.valueSwitch.on;
}

@end
