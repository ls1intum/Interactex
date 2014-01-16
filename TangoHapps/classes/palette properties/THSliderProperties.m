/*
THSliderProperties.m
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

#import "THSliderProperties.h"
#import "THSliderEditableObject.h"

@implementation THSliderProperties

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSString *)title {
    return @"Slider";
}

-(void) updateMinLabel{
    
    THSliderEditableObject *slider = (THSliderEditableObject*) self.editableObject;
    self.minLabel.text = [NSString stringWithFormat:@"%.2f",slider.min];
}

-(void) updateMaxLabel{
    
    THSliderEditableObject *slider = (THSliderEditableObject*) self.editableObject;
    self.maxLabel.text = [NSString stringWithFormat:@"%.2f",slider.max];
}

-(void) updateValueLabel{
    
    THSliderEditableObject *slider = (THSliderEditableObject*) self.editableObject;
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f",slider.value];
}

-(void) updateMinSlider{
    
    THSliderEditableObject *slider = (THSliderEditableObject*) self.editableObject;
    self.minSlider.value = slider.min;
}

-(void) updateMaxSlider{
    
    THSliderEditableObject *slider = (THSliderEditableObject*) self.editableObject;
    self.maxSlider.value = slider.max;
}

-(void) updateValueSlider{
    
    THSliderEditableObject *slider = (THSliderEditableObject*) self.editableObject;
    self.valueSlider.value = slider.value;
}

-(void) reloadState{
    
    [self updateMinLabel];
    [self updateMaxLabel];
    [self updateValueLabel];
    [self updateMinSlider];
    [self updateMaxSlider];
    [self updateValueSlider];
}

- (IBAction)valueChanged:(id)sender {
    THSliderEditableObject *slider = (THSliderEditableObject*) self.editableObject;
    slider.value = self.valueSlider.value;
    
    [self updateValueLabel];
}

- (IBAction)minChanged:(id)sender {
    
    THSliderEditableObject *slider = (THSliderEditableObject*) self.editableObject;
    slider.min = self.minSlider.value;
    self.valueSlider.minimumValue = slider.min;
    self.maxSlider.minimumValue = slider.min;
    [self updateMinLabel];
}

- (IBAction)maxChanged:(id)sender {
    
    THSliderEditableObject *slider = (THSliderEditableObject*) self.editableObject;
    slider.max = self.maxSlider.value;
    self.valueSlider.maximumValue = slider.max;
    self.minSlider.maximumValue = slider.max;
    [self updateMaxLabel];
}

#pragma Mark - View Lifecycle

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
    [self setValueSlider:nil];
    [self setMinSlider:nil];
    [self setMaxSlider:nil];
    [self setValueLabel:nil];
    [self setMinLabel:nil];
    [self setMaxLabel:nil];
    [super viewDidUnload];
}
@end
