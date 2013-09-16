//
//  THInvocationConnectionProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/16/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THInvocationConnectionProperties.h"
#import "THInvocationConnectionLine.h"

@implementation THInvocationConnectionProperties

-(NSString*) title{
    return @"Connection";
}

-(void) updateButtonText{
    
    THInvocationConnectionLine * connectionLine = (THInvocationConnectionLine*) self.editableObject;
    if(connectionLine.action.firstParam){
        [self.propertyButton setTitle:connectionLine.action.firstParam.description forState:UIControlStateNormal];
    } else {
        [self.propertyButton setTitle:@"parameter missing!" forState:UIControlStateNormal];
    }
}

-(void) reloadState{
    
    [self updateButtonText];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)propertyButtonPressed:(id)sender {
    
}

@end
