/*
THiPhoneViewProperties.m
Interactex Designer

Created by Juan Haladjian on 05/10/2013.

Interactex Designer is a configuration tool to easily setup, simulate and connect e-Textile hardware with smartphone functionality. Interactex Client is an app to store and replay projects made with Interactex Designer.

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
The first version of the software was designed and implemented as part of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was founded by Telekom Innovation Laboratories Berlin. It has been extended with funding from EIT ICT, as part of the activity "Connected Textiles".

Interactex is built using the Tango framework developed by TU Munich.

In the Interactex software, we use the GHUnit (a test framework for iOS developed by Gabriel Handford) and cocos2D libraries (a framework for building 2D games and graphical applications developed by Zynga Inc.). 
www.cocos2d-iphone.org
github.com/gabriel/gh-unit

Interactex also implements the Firmata protocol. Its software serial library is based on the original Arduino Firmata library.
www.firmata.org

All hardware part graphics in Interactex Designer are reproduced with kind permission from Fritzing. Fritzing is an open-source hardware initiative to support designers, artists, researchers and hobbyists to work creatively with interactive electronics.
www.frizting.org

Martijn ten Bhömer from TU Eindhoven contributed PureData support. Contact: m.t.bhomer@tue.nl.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

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

-(void) updateWidthSlider{
    
    THViewEditableObject * iphoneObject = (THViewEditableObject*) self.editableObject;
    self.widthSlider.value = iphoneObject.width;
}

-(void) updateHeightSlider{
    
    THViewEditableObject * iphoneObject = (THViewEditableObject*) self.editableObject;
    self.heightSlider.value = iphoneObject.height;
}

-(void) updateColorButtonState{
    
    THViewEditableObject * iphoneObject = (THViewEditableObject*) self.editableObject;
    self.changeColorButton.enabled = iphoneObject.canChangeBackgroundColor;
}

-(void) reloadState{
    
    [self updateWidthSlider];
    [self updateHeightSlider];
    [self updateValueLabels];
    [self updateColorLabels];
    [self updateCanBeResized];
    [self updateMinMaxSizes];
    [self updateColorButtonState];
}

-(void)updateColorLabels {
    THViewEditableObject * iphoneObject = (THViewEditableObject*)self.editableObject;
    self.colorLabel.backgroundColor = iphoneObject.backgroundColor;
}

-(void)updateValueLabels {
    THViewEditableObject * iphoneObject = (THViewEditableObject*)self.editableObject;
    self.widthLabel.text = [NSString stringWithFormat:@"%.2f",iphoneObject.width];
    self.heightLabel.text = [NSString stringWithFormat:@"%.2f",iphoneObject.height];
}

- (IBAction)widthChanged:(id)sender {
    
    THViewEditableObject * iphoneObject = (THViewEditableObject*)self.editableObject;
    float width = self.widthSlider.value;
    if([iphoneObject canResizeToWidth:width]){
        iphoneObject.width = width;
        [self updateValueLabels];
    } else {
        [self updateWidthSlider];
    }
    
}

- (IBAction)heightChanged:(id)sender {
    
    THViewEditableObject * iphoneObject = (THViewEditableObject*)self.editableObject;
    float height = self.heightSlider.value;
    if([iphoneObject canResizeToHeight:height]){
        iphoneObject.height = height;
        [self updateValueLabels];
    } else {
        [self updateHeightSlider];
    }
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
