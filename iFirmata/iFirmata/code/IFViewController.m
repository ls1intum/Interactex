/*
IFViewController.m
iFirmata

Created by Juan Haladjian on 27/06/2013.

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

#import "IFViewController.h"
#import "IFPinCell.h"
#import "IFPin.h"
#import "IFPinsController.h"
#import "IFI2CComponentCell.h"
#import "AppDelegate.h"
#import "IFI2CComponent.h"
#import "IFFirmataCommunicationModule.h"
#import "IFFirmataBLECommunicationModule.h"
#import "IFI2CRegister.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "IFI2CComponentProxy.h"
#import "IFI2CGenericViewController.h"

@implementation IFViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(void) viewDidLoad {
    
    [super viewDidLoad];
    
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.firmataPinsController = appDelegate.firmataController;
    
    //[self loadPersistedObjects];
}

-(void) viewWillAppear:(BOOL)animated{
    
    IFFirmataBLECommunicationModule * commModule = [[IFFirmataBLECommunicationModule alloc] init];
    commModule.bleService = [BLEDiscovery sharedInstance].connectedService;
    
    self.firmataPinsController.firmataController.communicationModule = commModule;
    [BLEDiscovery sharedInstance].connectedService.dataDelegate = commModule;
    commModule.firmataController = self.firmataPinsController.firmataController;
    
    if(self.firmataPinsController.analogPins.count == 0 && self.firmataPinsController.digitalPins.count == 0){

        if([BLEDiscovery sharedInstance].currentPeripheral.state == CBPeripheralStateConnected){
            [self.firmataPinsController.firmataController sendFirmwareRequest];
        }
    }
    
    [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:NO];
}

-(void) viewWillDisappear:(BOOL)animated{
    [self persistObjects];
    goingToI2CScene = NO;
    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self.firmataPinsController reset];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

/*
-(void) loadPersistedObjects{
        
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:IFDefaultsI2CComponents];
    if(data){
        self.firmataPinsController.i2cComponents = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}*/

-(void) persistObjects{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self.firmataPinsController.i2cComponents];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:IFDefaultsI2CComponents];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setFirmataPinsController:(IFPinsController *)firmataController{
    if(_firmataPinsController != firmataController){
        _firmataPinsController = firmataController;
        _firmataPinsController.delegate = self;
    }
}

#pragma mark FirmataDelegate

-(void) firmataDidUpdateDigitalPins:(IFPinsController *)firmataController{
    [self.table reloadData];
    
    //NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:0];
    //[self.table reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void) firmataDidUpdateAnalogPins:(IFPinsController *)firmataController{
    [self.table reloadData];
    
    //NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:1];
    //[self.table reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

-(void) firmataDidUpdateI2CComponents:(IFPinsController *)firmataController{
    
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:2];
    [self.table reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void) firmata:(IFPinsController *)firmataController didUpdateTitle:(NSString *)title{
    self.title = title;
}

#pragma mark TableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == kTableGroupIdxI2C){
        if(indexPath.row == self.firmataPinsController.i2cComponents.count){
            [self performSegueWithIdentifier:@"toGenericI2CComponent" sender:self];
        } else {
            
            [self performSegueWithIdentifier:@"toI2CDeviceSegue" sender:self];
        }
    }
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 2 && indexPath.row < self.firmataPinsController.i2cComponents.count){
        return YES;
    }
    return NO;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        IFI2CComponent * component = [self.firmataPinsController.i2cComponents objectAtIndex:indexPath.row];
        //[component removeObserver:self forKeyPath:@"value"];
        //[component removeObserver:self forKeyPath:@"notifies"];
        
        IFI2CComponentCell * cell = (IFI2CComponentCell*) [self.table cellForRowAtIndexPath:indexPath];
        [cell removeComponentObservers];
        
        self.firmataPinsController.delegate = nil;
        [self.firmataPinsController removeI2CComponent:component];
        self.firmataPinsController.delegate = self;
        
        [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0) {
        return @"Digital";
    } else if(section == 1){
        return @"Analog";
    } else if(section == 2){
        return @"I2C";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return self.firmataPinsController.digitalPins.count;
    } else if(section == 1){
        return self.firmataPinsController.analogPins.count;
    } else {
        return self.firmataPinsController.i2cComponentProxies.count;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == kTableGroupIdxI2C){
        return 96;
    } else {
        return 64;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell;
    
    if(indexPath.section == 0 || indexPath.section == 1){
        NSInteger pinNumber = indexPath.row;
        BOOL digital = (indexPath.section == 0);
        IFPin * pin = (digital ? [self.firmataPinsController.digitalPins objectAtIndex:pinNumber] : [self.firmataPinsController.analogPins objectAtIndex:pinNumber]);
        
        if(digital){
            cell = [self.table dequeueReusableCellWithIdentifier:@"digitalCell"];
        } else {
            cell = [self.table dequeueReusableCellWithIdentifier:@"analogCell"];
        }
        
        ((IFPinCell*)cell).pin = pin;
    } else if(indexPath.section == 2){
        
        NSInteger idx = indexPath.row;
        
        IFI2CComponentProxy * component = [self.firmataPinsController.i2cComponentProxies objectAtIndex:idx];
        cell = [self.table dequeueReusableCellWithIdentifier:@"i2cCell"];
        
        if(idx < self.firmataPinsController.i2cComponentProxies.count){
            ((IFI2CComponentCell*) cell).component = component;
        } else {
            
        }
    }
    
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"toI2CDeviceSegue"]){
        IFI2CLSM303ViewController * viewController = segue.destinationViewController;
        
        IFI2CComponentCell * cell = (IFI2CComponentCell*) [self.table cellForRowAtIndexPath:self.table.indexPathForSelectedRow];
        viewController.component = cell.component;
        viewController.firmata = self.firmataPinsController.firmataController;
        
        
    } else if([segue.identifier isEqualToString:@"toGenericI2CComponent"]){
        IFI2CGenericViewController * viewController = segue.destinationViewController;
        viewController.firmata = self.firmataPinsController.firmataController;
    }
    
}

#pragma mark - Generic Register Observer

-(void) I2CDeviceAddress:(NSInteger)address reg:(NSInteger) reg wroteData:(NSString *)data{//1
    
    NSInteger value = data.integerValue;
    
    uint8_t buf[2];
    [BLEHelper valueAsTwo7bitBytes:value buffer:buf];
    [self.firmataPinsController.firmataController sendI2CWriteToAddress:address reg:reg bytes:buf numBytes:2];
    
}

-(void) I2CDeviceAddress:(NSInteger)address reg:(NSInteger) reg startedNotifyingSize:(NSInteger)size{
    
    [self.firmataPinsController.firmataController sendI2CStartReadingAddress:address reg:reg size:size];
}

#pragma mark - i2cComponent Delegate

-(void) i2cComponent:(IFI2CComponent*) component wroteData:(NSString*) data toRegister:(IFI2CRegister*) reg{
    NSInteger value = data.integerValue;
    
    uint8_t buf[2];
    [BLEHelper valueAsTwo7bitBytes:value buffer:buf];
    [self.firmataPinsController.firmataController sendI2CWriteToAddress:component.address reg:reg.number bytes:buf numBytes:2];
}

-(void) i2cComponent:(IFI2CComponent*) component startedNotifyingRegister:(IFI2CRegister*) reg{
    [self.firmataPinsController.firmataController sendI2CStartReadingAddress:component.address reg:reg.number size:reg.size];
}

-(void) i2cComponent:(IFI2CComponent*) component stoppedNotifyingRegister:(IFI2CRegister*) reg{//2
    [self.firmataPinsController.firmataController sendI2CStopReadingAddress:component.address];
}

-(void) i2cComponent:(IFI2CComponent *)component addedRegister:(IFI2CRegister *)reg{
    [self.firmataPinsController addI2CRegister:reg toComponent:component];
}

-(void) i2cComponent:(IFI2CComponent *)component removedRegister:(IFI2CRegister *)reg{
    [self.firmataPinsController removeI2CRegister:reg fromComponent:component];
}

#pragma mark - Additional Options

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 0){
        self.table.editing = !self.table.editing;
        
        if(self.table.editing){
            NSInteger numRows = [self.table numberOfRowsInSection:2];
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:numRows-1 inSection:2];
            [self.table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
}

-(void) resetFirmata{
    
     [self.firmataPinsController.firmataController sendResetRequest];
     [self.firmataPinsController reset];
     [self.firmataPinsController.firmataController sendFirmwareRequest];
}
/*
-(void) addI2CComponent {
    
    IFI2CComponent * component = [[IFI2CComponent alloc] init];
    component.name = @"New I2C Component";
    component.address = 0;
    
    [self.firmataPinsController addI2CComponent:component];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.firmataPinsController.i2cComponents.count-1 inSection:2];
    [self.table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}*/

- (IBAction)optionsMenuTapped:(id)sender {
    
    NSString * option;
    
    if(self.table.editing){
        option = @"Stop Editing I2C Components";
    } else {
        option = @"Edit I2C Components";
    }
    /*
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Add I2C Component",option2, nil];*/
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:option, nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [actionSheet showInView:[self view]];
}

@end
