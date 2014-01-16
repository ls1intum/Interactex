/*
IFI2CComponentViewController.h
iFirmata

Created by Juan Haladjian on 31/07/2013.

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

#import "IFI2CRegisterViewController.h"

@class IFI2CComponent;
@class IFI2CRegister;
@class IFI2CComponentViewController;

@protocol IFI2CComponentDelegate <NSObject>

-(void) i2cComponent:(IFI2CComponent*) component wroteData:(NSString*) data toRegister:(IFI2CRegister*) reg;
-(void) i2cComponent:(IFI2CComponent*) component startedNotifyingRegister:(IFI2CRegister*) reg;
-(void) i2cComponent:(IFI2CComponent*) component stoppedNotifyingRegister:(IFI2CRegister*) reg;

-(void) i2cComponent:(IFI2CComponent*) component addedRegister:(IFI2CRegister*) reg;
-(void) i2cComponent:(IFI2CComponent*) component removedRegister:(IFI2CRegister*) reg;
@end

@interface IFI2CComponentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, IFI2CRegisterDelegate, UIActionSheetDelegate>
{    
    UIColor * defaultButtonColor;
}

@property (nonatomic, weak) IFI2CComponent * component;
@property (nonatomic, weak) id<IFI2CComponentDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) IFI2CRegister *removingRegister;
@property (strong, nonatomic) NSIndexPath *removingRegisterPath;

- (IBAction)editTapped:(id)sender;

@end
