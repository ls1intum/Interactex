/*
GMPI2CRegisterViewController.h
iGMP

Created by Juan Haladjian on 08/01/2013.

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

@class GMPI2CRegister;
@class GMPI2CRegisterViewController;

@protocol GMPI2CRegisterDelegate <NSObject>

-(void) i2cRegister:(GMPI2CRegister*) reg changedNumber:(NSInteger) newNumber;
-(void) i2cRegister:(GMPI2CRegister*) reg wroteData:(NSString*) data;
-(void) i2cRegisterRemoved:(GMPI2CRegister*) reg;

-(void) i2cRegisterChangedNotifying:(GMPI2CRegister*) reg notifying:(BOOL) notifying;

@end

@interface GMPI2CRegisterViewController : UIViewController <UIActionSheetDelegate>
{
    UIColor * defaultButtonColor;
}

@property (weak, nonatomic) GMPI2CRegister * reg;
@property (weak, nonatomic) id<GMPI2CRegisterDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *readView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UITextField *registerTextField;
@property (weak, nonatomic) IBOutlet UITextField *sendTextField;
@property (weak, nonatomic) IBOutlet UITextField *sizeTextField;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

- (IBAction)startTapped:(id)sender;
- (IBAction)sendTapped:(id)sender;
- (IBAction)removeTapped:(id)sender;

@end
