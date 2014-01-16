/*
IFI2CRegisterViewController.m
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

#import "IFI2CRegisterViewController.h"
#import "IFI2CRegister.h"

@implementation IFI2CRegisterViewController

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
          
    CGRect frame = self.registerTextField.frame;
    frame.size.height = IFTextFieldHeight;
    self.registerTextField.frame = frame;
    
    frame = self.sendTextField.frame;
    frame.size.height = IFTextFieldHeight;
    self.sendTextField.frame = frame;
    
    frame = self.sizeTextField.frame;
    frame.size.height = IFTextFieldHeight;
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

-(void) updateValueLabel{

    self.valueLabel.text = [IFHelper valueAsBracketedStringForI2CRegister:self.reg];
}

- (IBAction)startSwitchChanged:(id)sender {
    [self.reg removeObserver:self forKeyPath:@"notifies"];
    self.reg.notifies = self.startSwitch.on;
    [self.reg addObserver:self forKeyPath:@"notifies" options:NSKeyValueObservingOptionNew context:nil];
    
    [self updateValueLabel];
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

-(void) updateReadContinuouslySwitch{
    self.startSwitch.on = NO;
}

-(void) reloadUI{
    [self updateTitle];
    [self updateRegisterText];
    [self updateSizeText];
    [self updateValueLabel];
    [self updateReadContinuouslySwitch];
}

-(void) setRegister:(IFI2CRegister *)reg{
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
    
    [self checkUpdateNumber];
    
    self.reg.size = [self.sizeTextField.text integerValue];
    
    [self updateSizeText];
}

#pragma mark - Observing Value

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"value"]){
        [self updateValueLabel];
    } else if([keyPath isEqualToString:@"notifies"]){
        [self updateValueLabel];
    }
}

@end
