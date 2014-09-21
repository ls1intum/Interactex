//
//  THiBeaconProperties.m
//  TangoHapps
//
//  Created by Guven Candogan on 16/09/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THiBeaconProperties.h"
#import "THiBeaconEditable.h"

@interface THiBeaconProperties ()

@end

@implementation THiBeaconProperties

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    [super viewDidUnload];
}

- (IBAction)uuidTextChanged:(id)sender {
    THiBeaconEditable * ibeacon = (THiBeaconEditable*) self.editableObject;
    
    ibeacon.uuid = [[NSUUID UUID] initWithUUIDString:self.uuidText.text];
    //ibeacon.uuid = [[NSUUID UUID] initWithString:self.uuidText.text];
    [self updateUUIDText];
    
}

-(void) updateUUIDText{
    THiBeaconEditable * ibeacon = (THiBeaconEditable*) self.editableObject;
    self.uuidText.text = [ibeacon.uuid UUIDString];
}


-(void) reloadState{
    [self updateUUIDText];
}

@end
