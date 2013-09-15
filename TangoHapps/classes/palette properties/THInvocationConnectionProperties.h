//
//  THInvocationConnectionProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/16/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THEditableObjectProperties.h"

@interface THInvocationConnectionProperties : THEditableObjectProperties

@property (weak, nonatomic) IBOutlet UIButton *propertyButton;

- (IBAction)propertyButtonPressed:(id)sender;
@end
