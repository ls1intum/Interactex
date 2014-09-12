/*
IFI2CRegisterViewController.h
iFirmata

Created by Juan Haladjian on 08/01/2013.

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

@class IFI2CRegister;
@class IFI2CGenericViewController;
/*
@protocol IFI2CGenericDelegate <NSObject>

-(void) I2CDeviceAddress:(NSInteger)address reg:(NSInteger) reg wroteData:(NSString *)data;

-(void) I2CDeviceAddress:(NSInteger)address reg:(NSInteger) reg startedNotifyingSize:(NSInteger)size;
    
@end*/

@interface IFI2CGenericViewController : UIViewController <UIActionSheetDelegate>
{
    UIColor * defaultButtonColor;
    NSInteger keyboardHeight;
}

//@property (weak, nonatomic) id<IFI2CGenericDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISwitch *startSwitch;
@property (weak, nonatomic) IBOutlet UITextField *registerTextField;
@property (weak, nonatomic) IBOutlet UITextField *sendTextField;
@property (weak, nonatomic) IBOutlet UITextField *sizeTextField;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@property (weak, nonatomic) NSArray * i2cComponents;
@property (weak, nonatomic) IFFirmata * firmata;

- (IBAction)startSwitchChanged:(id)sender;
- (IBAction)sendTapped:(id)sender;

@property (nonatomic) NSInteger address;
@property (nonatomic) NSInteger registerNumber;
@property (nonatomic) NSInteger registerSize;

@end
