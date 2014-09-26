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

#import "IFI2CGenericViewController.h"
#import "IFI2CRegister.h"
#import "IFI2CComponent.h"

@implementation IFI2CGenericViewController

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

-(void) updateTitle{
    //self.navigationItem.title = [self titleString];
    //self.navigationController.navigationBar.topItem.title = [self titleString];
}

-(void) updateRegisterText{
    
    //self.registerTextField.text = [NSString stringWithFormat:@"%d",self.reg.number];
}

-(void) updateSizeText{
    
    //self.sizeTextField.text = [NSString stringWithFormat:@"%d",self.reg.size];
}

-(void) updateValueLabel{

    //self.valueLabel.text = [IFHelper valueAsBracketedStringForI2CRegister:self.reg];
}

-(NSInteger) address{
    return [self.addressTextField.text integerValue];
}

-(NSInteger) registerNumber{
    return [self.registerTextField.text integerValue];
}

-(NSInteger) registerSize{
    return [self.sizeTextField.text integerValue];
}

- (IBAction)startSwitchChanged:(id)sender {
    if(self.startSwitch.on){
        [self.firmata sendI2CStartReadingAddress:self.address reg:self.registerNumber size:self.registerSize];
    } else {
        [self.firmata sendI2CStopReadingAddress:self.address];
    }    
}

-(void) I2CDeviceAddress:(NSInteger)address reg:(NSInteger) reg startedNotifyingSize:(NSInteger)size{
    
    [self.firmata sendI2CStartReadingAddress:address reg:reg size:size];
    
    [self updateValueLabel];
}

- (IBAction)sendTapped:(id)sender {
    
    NSInteger value = self.sendTextField.text.integerValue;
    
    uint8_t buf[2];
    [BLEHelper valueAsTwo7bitBytes:value buffer:buf];
    [self.firmata sendI2CWriteToAddress:self.address reg:self.registerNumber bytes:buf numBytes:2];
    
}

-(void) viewWillAppear:(BOOL)animated{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newI2cDataAvailable:) name:kNotificationNewI2CData object:nil];
    
    [self reloadUI];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void) viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNewI2CData object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

-(void) newI2cDataAvailable:(NSNotification*) notification{
    NSString * text = notification.object;
    self.valueLabel.text = text;
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

-(void) closeNumberPad{
    [self.addressTextField resignFirstResponder];
    [self.registerTextField resignFirstResponder];
    [self.sendTextField resignFirstResponder];
    [self.sizeTextField resignFirstResponder];
    
    [self updateSizeText];
}

#pragma mark - Scrolling up when textFild appears

-(void)keyboardWillShow:(NSNotification*) notification {
    
    if(self.sizeTextField.editing){
        NSDictionary* userInfo = [notification userInfo];
        
        CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        float diff = self.sizeTextField.frame.origin.y + self.sizeTextField.frame.size.height - keyboardSize.height;
        keyboardHeight = diff + 40;
        
        [self moveScrollView:YES];
    }
}

-(void)keyboardWillHide:(NSNotification*) notification {
    
    if(self.sizeTextField.editing){
        
        [self moveScrollView:NO];
    }
}

-(void)moveScrollView:(BOOL)movedUp {
    
    CGPoint contentOffset = ((UIScrollView*) self.view).contentOffset;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = self.view.frame;
    
    if (movedUp) {
        
        rect.origin.y -= keyboardHeight;
        rect.size.height += keyboardHeight;
        
    } else {
        
        rect.origin.y += keyboardHeight;
        rect.size.height -= keyboardHeight;
    }
    
    self.view.frame = rect;
    
    ((UIScrollView*) self.view).contentOffset = contentOffset;
    
    [UIView commitAnimations];
}

@end
