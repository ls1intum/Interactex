/*
GMPI2CRegisterViewController.m
iGMP

Created by Juan Haladjian on 08/01/2013.

iGMP is an App to control an Arduino board over Bluetooth 4.0. iGMP uses the GMP protocol (based on Firmata): www.firmata.org

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany, 
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
It has been created with funding from EIT ICT, as part of the activity "Connected Textiles".


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "GMPI2CRegisterViewController.h"
#import "GMPI2CRegister.h"

@implementation GMPI2CRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    defaultButtonColor = [self.startButton titleColorForState:UIControlStateNormal];
          
    CGRect frame = self.registerTextField.frame;
    frame.size.height = GMPTextFieldHeight;
    self.registerTextField.frame = frame;
    
    frame = self.sendTextField.frame;
    frame.size.height = GMPTextFieldHeight;
    self.sendTextField.frame = frame;
    
    frame = self.sizeTextField.frame;
    frame.size.height = GMPTextFieldHeight;
    self.sizeTextField.frame = frame;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(closeNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.registerTextField.inputAccessoryView = numberToolbar;
    self.sendTextField.inputAccessoryView = numberToolbar;
    self.sizeTextField.inputAccessoryView = numberToolbar;
    
    self.valueLabel.layer.cornerRadius = 5.0f;
    self.valueLabel.layer.borderWidth = 1.0f;
    
    self.readView.layer.cornerRadius = 5.0f;
    self.readView.layer.borderWidth = 1.0f;
    
}

-(NSString*) titleString{
    return [NSString stringWithFormat:@"Register: #%d",self.reg.number];
}

-(void) updateTitle{
    self.navigationItem.title = [self titleString];
    //self.navigationController.navigationBar.topItem.title = [self titleString];
}

-(void) updateRegisterText{
    
    self.registerTextField.text = [NSString stringWithFormat:@"%d",self.reg.number];
}

-(void) updateSizeText{
    
    //self.sizeTextField.text = [NSString stringWithFormat:@"%d",self.reg.size];
}

-(void) updateStartButton{
    if(self.reg.notifies){
        [self.startButton setTitle:@"Stop" forState:UIControlStateNormal];
        [self.startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else{
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.startButton setTitleColor:defaultButtonColor forState:UIControlStateNormal];
    }
}

-(void) updateValueLabel{

    self.valueLabel.text = [GMPHelper valueAsBracketedStringForI2CRegister:self.reg];
}

- (IBAction)startTapped:(id)sender {
    
    self.reg.notifies = !self.reg.notifies;
    [self.delegate i2cRegisterChangedNotifying:self.reg notifying:self.reg.notifies];
}

- (IBAction)sendTapped:(id)sender {
    [self.delegate i2cRegister:self.reg wroteData:self.sendTextField.text];
}

-(void) viewWillAppear:(BOOL)animated{
    
    [self.reg addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
    [self.reg addObserver:self forKeyPath:@"notifies" options:NSKeyValueObservingOptionNew context:nil];
    [self reloadUI];
}

-(void) viewWillDisappear:(BOOL)animated{
    
    [self.reg removeObserver:self forKeyPath:@"value"];
    [self.reg removeObserver:self forKeyPath:@"notifies"];
}

-(void) reloadUI{
    [self updateTitle];
    [self updateRegisterText];
    [self updateSizeText];
    [self updateStartButton];
    [self updateValueLabel];
}

-(void) setRegister:(GMPI2CRegister *)reg{
    if(_reg != reg){
        _reg = reg;
        [self reloadUI];
    }
}

-(NSString*) title{
    if(self.reg){
        return [self titleString];
    } else return @"I2C Register";
}

-(void) checkUpdateNumber{
    NSInteger regNumber = [self.registerTextField.text integerValue];
    if(self.reg.number != regNumber){
        self.reg.number = regNumber;
        [self.delegate i2cRegister:self.reg changedNumber:regNumber];
        [self updateTitle];
    }
    [self updateRegisterText];

}

-(void) closeNumberPad{
    [self.registerTextField resignFirstResponder];
    [self.sendTextField resignFirstResponder];
    [self.sizeTextField resignFirstResponder];
    [self.numberTextField resignFirstResponder];
    
    [self checkUpdateNumber];
    
    self.reg.numElements = [self.sizeTextField.text integerValue];
    
    [self updateSizeText];
}

#pragma mark - Observing Value

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"value"]){
        [self updateValueLabel];
    } else if([keyPath isEqualToString:@"notifies"]){
        [self updateStartButton];
        [self updateValueLabel];
    }
}

#pragma mark - Remove ActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self.delegate i2cRegisterRemoved:self.reg];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)removeTapped:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Remove Register"
                                                    otherButtonTitles:nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [actionSheet showInView:[self view]];
}

@end
