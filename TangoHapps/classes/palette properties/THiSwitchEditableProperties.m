//
//  THiSwitchEditableProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/4/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THiSwitchEditableProperties.h"
#import "THiSwitchEditableObject.h"

@implementation THiSwitchEditableProperties

-(NSString *)title
{
    return @"Switch";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setOnSwitch:nil];
    [super viewDidUnload];
}

-(void) reloadState{
    
    THiSwitchEditableObject * iswitch = (THiSwitchEditableObject*) self.editableObject;
    self.onSwitch.on = iswitch.on;
}

- (IBAction)onSwitchChanged:(id)sender {
    THiSwitchEditableObject * iswitch = (THiSwitchEditableObject*) self.editableObject;
    iswitch.on = self.onSwitch.on;
}

@end
