//
//  THiPhoneObjectPropertiesViewController.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/19/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THiPhoneViewProperties.h"
#import "THViewEditableObject.h"

@implementation THiPhoneViewProperties
@synthesize widthSlider;
@synthesize heightSlider;
@synthesize widthLabel;
@synthesize heightLabel;

-(NSString*) title{
    return @"View";
}

-(void) updateCanBeResized{
    
    THViewEditableObject * view = (THViewEditableObject*) self.editableObject;
    if(view.canBeResized){
        self.widthSlider.enabled = YES;
        self.heightSlider.enabled = YES;
    } else {
        self.widthSlider.enabled = NO;
        self.heightSlider.enabled = NO;
    }
}

-(void) updateMinMaxSizes{
    THViewEditableObject * iphoneObject = (THViewEditableObject*) self.editableObject;
    self.widthSlider.minimumValue = iphoneObject.minSize.width;
    self.heightSlider.minimumValue = iphoneObject.minSize.height;
    
    self.widthSlider.maximumValue = iphoneObject.maxSize.width;
    self.heightSlider.maximumValue = iphoneObject.maxSize.height;    
}

-(void) reloadState{
    
    THViewEditableObject * iphoneObject = (THViewEditableObject*) self.editableObject;
    self.widthSlider.value = iphoneObject.width;
    self.heightSlider.value = iphoneObject.height;
    [self updateValueLabels];
    [self updateColorLabels];
    [self updateCanBeResized];
    [self updateMinMaxSizes];
}

-(void)updateColorLabels {
    THViewEditableObject * iphoneObject = (THViewEditableObject*)self.editableObject;
    self.colorLabel.backgroundColor = iphoneObject.backgroundColor;
    self.changeColorButton.enabled = iphoneObject.canChangeBackgroundColor;
}

-(void)updateValueLabels {
    THViewEditableObject * iphoneObject = (THViewEditableObject*)self.editableObject;
    self.widthLabel.text = [NSString stringWithFormat:@"%.2f",iphoneObject.width];
    self.heightLabel.text = [NSString stringWithFormat:@"%.2f",iphoneObject.height];
}

- (IBAction)widthChanged:(id)sender {
    
    THViewEditableObject * iphoneObject = (THViewEditableObject*)self.editableObject;
    float width = self.widthSlider.value;
    iphoneObject.width = width;
    [self updateValueLabels];
}

- (IBAction)heightChanged:(id)sender {
    
    THViewEditableObject * iphoneObject = (THViewEditableObject*)self.editableObject;
    float height = self.heightSlider.value;
    iphoneObject.height = height;
    [self updateValueLabels];
}

- (void)presentColorPickerFromRect:(CGRect)rect {
    if(!colorPickerPopover){
        colorPicker = [[THColorPicker alloc] init];
        [colorPicker setDelegate:self];
        colorPickerPopover = [[UIPopoverController alloc] initWithContentViewController:colorPicker];
    }
    [colorPickerPopover presentPopoverFromRect:rect
                                        inView:self.view
                      permittedArrowDirections:UIPopoverArrowDirectionLeft
                                      animated:YES];
}

- (IBAction)changeColorTapped:(id)sender {
    
    [self presentColorPickerFromRect:self.changeColorButton.frame];
}

-(void)colorPicker:(THColorPicker *)picker
      didPickColor:(UIColor *)color {
    
    THViewEditableObject * iphoneObject = (THViewEditableObject*)self.editableObject;
    iphoneObject.backgroundColor = color;

    [self updateColorLabels];
    [colorPickerPopover dismissPopoverAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [self setWidthSlider:nil];
    [self setHeightSlider:nil];
    [self setWidthLabel:nil];
    [self setHeightLabel:nil];
    [self setChangeColorButton:nil];
    [self setColorLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
