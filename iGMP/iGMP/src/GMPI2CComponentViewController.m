/*
GMPI2CComponentViewController.m
iGMP

Created by Juan Haladjian on 31/07/2013.

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

#import "GMPI2CComponentViewController.h"
#import "GMPI2CComponent.h"
#import "GMPI2CRegister.h"
#import "GMPI2CRegisterViewController.h"
#import "GMPHelper.h"

@implementation GMPI2CComponentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    CGRect frame = self.nameTextField.frame;
    frame.size.height = 40;
    self.nameTextField.frame = frame;
    
    frame = self.addressTextField.frame;
    frame.size.height = 40;
    self.addressTextField.frame = frame;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(closeNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.addressTextField.inputAccessoryView = numberToolbar;
    
    //[self.table reloadData];
}

-(void) reloadUI{
    
    if(![self.component.name isEqualToString:@"New I2C Component"]){
        self.nameTextField.text = self.component.name;
    }
    self.addressTextField.text = [NSString stringWithFormat:@"%d",self.component.address];
}

-(void) setComponent:(GMPI2CComponent *)component{
    if(_component != component){
        _component = component;
        [self reloadUI];
    }
}

-(void) viewWillAppear:(BOOL)animated{
    [self reloadUI];
    
    [self addRegisterObservers];
    
    if(self.table.indexPathForSelectedRow){
        [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:NO];
    }
}

-(void) viewDidAppear:(BOOL)animated{
    if(self.removingRegister){
        [self removeRegisterCellAnimated];
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    [self removeRegisterObservers];
}

#pragma mark - Register Observers

-(void) addRegisterObservers{
    for (GMPI2CRegister * reg in self.component.registers) {
        [reg addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
    }
}

-(void) removeRegisterObservers{
    for (GMPI2CRegister * reg in self.component.registers) {
        [reg removeObserver:self forKeyPath:@"value"];
    }
}

#pragma mark - Register Observers

-(NSString*) title{
    if(self.component){
        return self.component.name;
    } else return @"I2C Component";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addRegisterTapped:(id)sender {
    
    GMPI2CRegister * newRegister = [[GMPI2CRegister alloc] init];
    newRegister.number = 32;
    newRegister.numElements = 3;
    newRegister.sizePerElement = 2;
    
    [self.delegate i2cComponent:self.component addedRegister:newRegister];
    
    //[self.component addRegister:newRegister];
    
    [newRegister addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];

    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.component.registers.count-1 inSection:0];
    [self.table insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - Done Button on Numeric Keyboards

-(void) closeNumberPad{
    [self.addressTextField resignFirstResponder];
    
    self.component.address = [self.addressTextField.text integerValue];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.nameTextField){
        self.navigationController.navigationBar.topItem.title = self.nameTextField.text;
        self.component.name = self.nameTextField.text;
    }
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Table


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.component.registers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger idx = indexPath.row;
    
    UITableViewCell * cell = [self.table dequeueReusableCellWithIdentifier:@"i2cRegisterCell"];
    
    GMPI2CRegister * reg = [self.component.registers objectAtIndex:idx];
    cell.textLabel.text =  [NSString stringWithFormat:@"Register #%d", reg.number];
    cell.detailTextLabel.text = [GMPHelper valueAsBracketedStringForI2CRegister:reg];
    
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toI2CRegisterSegue"]){
        
        NSIndexPath * indexPath = [self.table indexPathForSelectedRow];
        NSInteger row = indexPath.row;
        GMPI2CRegister * reg = [self.component.registers objectAtIndex:row];
        
        GMPI2CRegisterViewController * viewController = (GMPI2CRegisterViewController*) segue.destinationViewController;
        viewController.reg = reg;
        viewController.delegate = self;
    }
}

#pragma mark - RegisterController delegate

-(NSIndexPath*) indexPathForRegister:(GMPI2CRegister*) reg{
    NSInteger row = [self.component.registers indexOfObject:reg];
    if(row>= 0 && row < self.component.registers.count){
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        return indexPath;
    }
    return nil;
}

-(void) i2cRegister:(GMPI2CRegister *)reg wroteData:(NSString *)data{
    [self.delegate i2cComponent:self.component wroteData:data toRegister:reg];
}

-(void) i2cRegister:(GMPI2CRegister*) reg changedNumber:(NSInteger) newNumber{
    NSIndexPath * indexPath = [self indexPathForRegister:reg];
    [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Register Observer

-(void) handleStartedNotifyingRegister:(GMPI2CRegister*) reg{
    
}

-(void) handleStoppedNotifyingRegister:(GMPI2CRegister*) reg{
    
    NSIndexPath * indexPath = [self indexPathForRegister:reg];
    [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


//called after view did appear when there is a component to remove
-(void) removeRegisterCellAnimated{
        
    [self.table scrollToRowAtIndexPath:self.removingRegisterPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.removingRegisterPath] withRowAnimation:UITableViewRowAnimationFade];
    
    self.removingRegister = nil;
    self.removingRegisterPath = nil;
}

-(void) i2cRegisterRemoved:(GMPI2CRegister *)reg{
    
    //[reg removeObserver:self forKeyPath:@"value"];
    
    NSInteger row = [self.component.registers indexOfObject:reg];
    self.removingRegisterPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    //[self.component removeRegister:reg];
    [self.delegate i2cComponent:self.component removedRegister:reg];
    
    self.removingRegister = reg;
}

-(void) i2cRegisterChangedNotifying:(GMPI2CRegister*) reg notifying:(BOOL) notifying{

    if(reg.notifies){
        [self.delegate i2cComponent:self.component startedNotifyingRegister:reg];
        [self handleStartedNotifyingRegister:reg];
    } else {
        [self.delegate i2cComponent:self.component stoppedNotifyingRegister:reg];
        [self handleStoppedNotifyingRegister:reg];
    }
}

#pragma mark - Remove ActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self.delegate i2cComponentRemoved:self.component];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)removeTapped:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Remove Component"
                                                    otherButtonTitles:nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [actionSheet showInView:[self view]];
}

#pragma mark - Value Observed

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"value"]){
        NSInteger idx = [self.component.registers indexOfObject:object];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

@end
