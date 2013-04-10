//
//  THiPhoneProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/9/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THiPhoneProperties.h"
#import "THiPhoneEditableObject.h"

@implementation THiPhoneProperties

-(NSString*) title{
    return @"iPhone";
}

- (IBAction)typeSegmentChanged:(UISegmentedControl*)sender {
    
    THiPhoneEditableObject * iPhone = (THiPhoneEditableObject*) self.editableObject;
    iPhone.type = (THIPhoneType) sender.selectedSegmentIndex;
}

-(void) updateiPhoneType{
    THiPhoneEditableObject * iPhone = (THiPhoneEditableObject*) self.editableObject;
    self.typeSegment.selectedSegmentIndex = iPhone.type;
}

-(void) reloadState{
    [self updateiPhoneType];
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
    [self setTypeSegment:nil];
    [super viewDidUnload];
}

@end
