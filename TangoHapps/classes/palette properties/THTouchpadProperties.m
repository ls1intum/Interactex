//
//  THTouchpadProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/22/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THTouchpadProperties.h"
#import "THTouchPadEditableObject.h"
#import "THTouchpad.h"

@implementation THTouchpadProperties

@synthesize xMultiplierSlider;
@synthesize yMultiplierSlider;
@synthesize xMultiplierLabel;
@synthesize yMultiplierLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSString*) title{
    return @"Touchpad";
}

-(void) reloadState{
    [self resetLabels];
    [self resetSliders];
}

-(void) resetSliders{
    
    THTouchPadEditableObject * touchpad = (THTouchPadEditableObject*) self.editableObject;
    
    self.xMultiplierSlider.value = touchpad.xMultiplier;
    self.yMultiplierSlider.value = touchpad.yMultiplier;
}

-(void) resetLabels{
    [self resetLabelx];
    [self resetLabely];
}

-(void) resetLabelx{
    THTouchPadEditableObject * touchpad = (THTouchPadEditableObject*) self.editableObject;
    
    self.xMultiplierLabel.text = [NSString stringWithFormat:@"%d",(int) touchpad.xMultiplier];
}

-(void) resetLabely{
    THTouchPadEditableObject * touchpad = (THTouchPadEditableObject*) self.editableObject;
    
    self.yMultiplierLabel.text = [NSString stringWithFormat:@"%d",(int) touchpad.yMultiplier];
}

- (IBAction)xMultiplierChanged:(id)sender {
    THTouchPadEditableObject * touchpad = (THTouchPadEditableObject*) self.editableObject;
    touchpad.xMultiplier = self.xMultiplierSlider.value;
    
    [self resetLabelx];
}

- (IBAction)yMultiplierChanged:(id)sender {
    THTouchPadEditableObject * touchpad = (THTouchPadEditableObject*) self.editableObject;
    touchpad.yMultiplier = self.xMultiplierSlider.value;
    
    [self resetLabely];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setXMultiplierSlider:nil];
    [self setYMultiplierSlider:nil];
    [self setXMultiplierLabel:nil];
    [self setYMultiplierLabel:nil];
    
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


@end
