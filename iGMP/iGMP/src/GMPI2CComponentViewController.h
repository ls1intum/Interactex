/*
GMPI2CComponentViewController.h
iGMP

Created by Juan Haladjian on 31/07/2013.

iGMP is an App to control an Arduino board over Bluetooth 4.0. iGMP uses the GMP protocol (based on Firmata): www.firmata.org

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany, 
	
Contacts:
juan.haladjian@cs.tum.edu
k.zhang@utwente.nl
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
It has been created with funding from EIT ICT, as part of the activity "Connected Textiles".


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import <UIKit/UIKit.h>

#import "GMPI2CRegisterViewController.h"

@class GMPI2CComponent;
@class GMPI2CRegister;
@class GMPI2CComponentViewController;

@protocol GMPI2CComponentDelegate <NSObject>

-(void) i2cComponentRemoved:(GMPI2CComponent*) component;
-(void) i2cComponent:(GMPI2CComponent*) component wroteData:(NSString*) data toRegister:(GMPI2CRegister*) reg;
-(void) i2cComponent:(GMPI2CComponent*) component startedNotifyingRegister:(GMPI2CRegister*) reg;
-(void) i2cComponent:(GMPI2CComponent*) component stoppedNotifyingRegister:(GMPI2CRegister*) reg;

-(void) i2cComponent:(GMPI2CComponent*) component addedRegister:(GMPI2CRegister*) reg;
-(void) i2cComponent:(GMPI2CComponent*) component removedRegister:(GMPI2CRegister*) reg;
@end

@interface GMPI2CComponentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, GMPI2CRegisterDelegate, UIActionSheetDelegate>
{    
    UIColor * defaultButtonColor;
}

@property (nonatomic, weak) GMPI2CComponent * component;
@property (nonatomic, weak) id<GMPI2CComponentDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) GMPI2CRegister *removingRegister;
@property (strong, nonatomic) NSIndexPath *removingRegisterPath;

- (IBAction)removeTapped:(id)sender;
- (IBAction) addRegisterTapped:(id)sender;

@end
