/*
THThreeColorLedProperties.m
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

#import "THThreeColorLedProperties.h"
#import "THThreeColorLedEditable.h"

@implementation THThreeColorLedProperties

-(NSString *)title {
    return @"Potentiometer";
}

-(void) updateRedLabel{
    THThreeColorLedEditable * led = (THThreeColorLedEditable*) self.editableObject;
    self.redLabel.text = [NSString stringWithFormat:@"%ld",(long)led.red];
}

-(void) updateGreenLabel{
    THThreeColorLedEditable * led = (THThreeColorLedEditable*) self.editableObject;
    self.greenLabel.text = [NSString stringWithFormat:@"%ld",(long)led.green];
}

-(void) updateBlueLabel{
    THThreeColorLedEditable * led = (THThreeColorLedEditable*) self.editableObject;
    self.blueLabel.text = [NSString stringWithFormat:@"%ld",(long)led.blue];
}

-(void) updateRedSlider{
    THThreeColorLedEditable * led = (THThreeColorLedEditable*) self.editableObject;
    self.redSlider.value = led.red;
}

-(void) updateGreenSlider{
    THThreeColorLedEditable * led = (THThreeColorLedEditable*) self.editableObject;
    self.greenSlider.value = led.green;
}

-(void) updateBlueSlider{
    THThreeColorLedEditable * led = (THThreeColorLedEditable*) self.editableObject;
    self.blueSlider.value = led.blue;
}

- (IBAction)redChanged:(id)sender {
    THThreeColorLedEditable * led = (THThreeColorLedEditable*) self.editableObject;
    led.red = self.redSlider.value;
    [self updateRedLabel];
}

- (IBAction)greenChanged:(id)sender {
    THThreeColorLedEditable * led = (THThreeColorLedEditable*) self.editableObject;
    led.green = self.greenSlider.value;
    [self updateGreenLabel];
}

- (IBAction)blueChanged:(id)sender {
    THThreeColorLedEditable * led = (THThreeColorLedEditable*) self.editableObject;
    led.blue = self.blueSlider.value;
    [self updateBlueLabel];
}

-(void) reloadState{
    [self updateRedLabel];
    [self updateGreenLabel];
    [self updateBlueLabel];
    [self updateRedSlider];
    [self updateGreenSlider];
    [self updateBlueSlider];
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

@end
