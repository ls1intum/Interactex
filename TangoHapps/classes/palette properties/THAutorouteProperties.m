//
//  THAutorouteProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 15/01/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THAutorouteProperties.h"
#import "THHardwareComponentEditableObject.h"

@implementation THAutorouteProperties

-(NSString*) title{
    return @"Wiring";
}


-(void) reloadState{
}

- (IBAction)autorouteTapped:(id)sender {
    THHardwareComponentEditableObject * object = (THHardwareComponentEditableObject*) self.editableObject;
    [object autoroute];
}

@end
