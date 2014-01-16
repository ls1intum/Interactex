/*
IFCharacteristicDetailsViewController.h
iFirmata

Created by Juan Haladjian on 30/06/2013.

iFirmata is an App to control an Arduino board over Bluetooth 4.0. iFirmata uses the Firmata protocol: www.firmata.org

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
It has been created with funding from EIT ICT, as part of the activity "Connected Textiles".


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import <UIKit/UIKit.h>
#import "BLEService.h"

@interface IFCharacteristicDetailsViewController : UIViewController <UITextFieldDelegate, BLEServiceDataDelegate>
{
    float keyboardHeight;
}

@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;

@property (nonatomic, weak) CBCharacteristic * currentCharacteristic;
@property (nonatomic, weak) BLEService * bleService;

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UISegmentedControl *notifyControl;

@property (weak, nonatomic) IBOutlet UITextField *writeText;
@property (weak, nonatomic) IBOutlet UIButton *writeButton;

- (IBAction)readPushed:(id)sender;

- (IBAction)writePushed:(id)sender;
- (IBAction)textChanged:(id)sender;
- (IBAction)notifyChanged:(id)sender;
@end
