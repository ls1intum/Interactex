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
    [self setUuidText:nil];
    [super viewDidUnload];
}

- (IBAction)uuidTextChanged:(id)sender {
    NSString * newUuid = [NSString stringWithString:self.uuidText.text];
    THiBeaconEditable * ibeacon = (THiBeaconEditable*) self.editableObject;
    NSUUID *uuid =[[NSUUID alloc] initWithUUIDString:newUuid];
    
    if(uuid){
        ibeacon.uuid = uuid;
        [self updateUUIDText];
    } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The UUID format is invalid, Please enter a valid UUID" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
    }
    
    
    
    //ibeacon.uuid = [[NSUUID alloc] initWithUUIDString:self.uuidText.text];
    //NSUUID *uuid =[[NSUUID alloc] initWithUUIDString:newtext];
    // NSUUID *uuid =[[NSUUID alloc] initWithUUIDString:@"F7826DA6-4FA2-4E98-8024-BC5B71E0893E"];
    //NSUUID *uuid =[[NSUUID alloc] initWithUUIDString:@"10D39AE7-020E-4467-9CB2-DD36366F899D"];
   // NSUUID *uuid =[[NSUUID alloc] initWithUUIDString:[NSString stringWithFormat:@"%@",self.uuidText.text]];
    //ibeacon.uuid = uuid;
    //ibeacon.uuid = [[NSUUID UUID] initWithString:self.uuidText.text];
    //[self updateUUIDText];
    
}

-(void) updateUUIDText{
    THiBeaconEditable * ibeacon = (THiBeaconEditable*) self.editableObject;
    //self.uuidText.text = [ibeacon.uuid UUIDString];
    self.uuidText.text = [NSString stringWithString:[ibeacon.uuid UUIDString]];
}


-(void) reloadState{
    [self updateUUIDText];
}

-(NSString*) title{
    return @"iBeacon";
}
@end
