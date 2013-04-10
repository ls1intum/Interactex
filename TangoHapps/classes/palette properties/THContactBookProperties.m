//
//  THContactBookProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 12/13/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THContactBookProperties.h"
#import "THContactBookEditable.h"

@implementation THContactBookProperties

-(NSString *)title {
    return @"Contact Book";
}

-(void) reloadState{
    
    THContactBookEditable * contactBook = (THContactBookEditable*) self.editableObject;
    self.callSwitch.on = contactBook.showCallButton;
    self.previousSwitch.on = contactBook.showPreviousButton;
    self.nextSwitch.on = contactBook.showNextButton;
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

- (IBAction)callChanged:(id)sender {
    THContactBookEditable * contactBook = (THContactBookEditable*) self.editableObject;
    contactBook.showCallButton = self.callSwitch.on;
}

- (IBAction)previousChanged:(id)sender {
    THContactBookEditable * contactBook = (THContactBookEditable*) self.editableObject;
    contactBook.showPreviousButton = self.previousSwitch.on;
}

- (IBAction)nextChanged:(id)sender {
    THContactBookEditable * contactBook = (THContactBookEditable*) self.editableObject;
    contactBook.showNextButton = self.nextSwitch.on;
}

@end
