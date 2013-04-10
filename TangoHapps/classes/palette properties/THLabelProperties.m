//
//  THLabelProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/14/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THLabelProperties.h"
#import "THLabel.h"

@implementation THLabelProperties
@synthesize textField;

-(NSString*) title{
    return @"Label";
}

- (IBAction)textEntered:(id)sender{
    
    THLabel * label = (THLabel*)self.editableObject;
    label.text = self.textField.text;
}

-(void) reloadState{   
    THLabel * label = (THLabel*) self.editableObject;
    self.textField.text = label.text;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


@end
