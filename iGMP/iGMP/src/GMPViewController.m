/*
GMPViewController.m
iGMP

Created by Juan Haladjian on 27/06/2013.

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

#import "GMPViewController.h"
#import "GMPPinCell.h"
#import "GMPPin.h"
#import "GMPPinsController.h"
#import "GMPI2CComponentCell.h"
#import "GMPAppDelegate.h"
#import "GMPI2CComponent.h"
#import "GMPCommunicationModule.h"
#import "GMPBLECommunicationModule.h"
#import "GMPI2CRegister.h"
#import "GMPConstants.h"

@implementation GMPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    GMPAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.gmpPinsController = appDelegate.gmpController;
    
    [self loadPersistedObjects];
}

-(void) viewWillAppear:(BOOL)animated{
    
    GMPBLECommunicationModule * commModule = [[GMPBLECommunicationModule alloc] init];
    commModule.bleService = [BLEDiscovery sharedInstance].connectedService;
    
    self.gmpPinsController.gmpController.communicationModule = commModule;
    [BLEDiscovery sharedInstance].connectedService.dataDelegate = commModule;
    commModule.gmpController = self.gmpPinsController.gmpController;
    
    if(self.gmpPinsController.analogPins.count == 0 && self.gmpPinsController.digitalPins.count == 0){
        
        [self.gmpPinsController.gmpController sendFirmwareRequest];
    }
    
    [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:NO];
}

-(void) viewDidAppear:(BOOL)animated{
    
    if(self.removingComponent){
        [self removeComponentAnimated];
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    if(!goingToI2CScene){
        
        [self.gmpPinsController stopReportingI2CComponents];
        [self.gmpPinsController stopReportingAnalogPins];
        [self persistObjects];
    }
    goingToI2CScene = NO;
}

-(void) loadPersistedObjects{
        
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:GMPDefaultI2CComponents];
    if(data){
        self.gmpPinsController.i2cComponents = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

-(void) persistObjects{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self.gmpPinsController.i2cComponents];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:GMPDefaultI2CComponents];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setGmpPinsController:(GMPPinsController *)firmataController{
    if(_gmpPinsController != firmataController){
        _gmpPinsController = firmataController;
        _gmpPinsController.delegate = self;
    }
}

#pragma mark FirmataDelegate

-(void) pinsControllerDidUpdateDigitalPins:(GMPPinsController *)firmataController{
    [self.table reloadData];
}

-(void) pinsControllerDidUpdateAnalogPins:(GMPPinsController *)firmataController{
    [self.table reloadData];
}

-(void) pinsControllerDidUpdateI2CComponents:(GMPPinsController *)firmataController{
    
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:2];
    [self.table reloadSections:indexSet withRowAnimation:UITableViewRowAnimationTop];
}

-(void) pinsController:(GMPPinsController*) pinsController didUpdateFirmwareName:(NSString*) firmwareName{
    self.title = firmwareName;
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
    } else {
        return @"I2C";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return self.gmpPinsController.digitalPins.count;
    } else if(section == 1){
        return self.gmpPinsController.analogPins.count;
    } else {
        return self.gmpPinsController.i2cComponents.count;
    }
}

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell;
    
    if(indexPath.section == 0 || indexPath.section == 1){
        NSInteger pinNumber = indexPath.row;
        BOOL digital = (indexPath.section == 0);
        GMPPin * pin = (digital ? [self.gmpPinsController.digitalPins objectAtIndex:pinNumber] : [self.gmpPinsController.analogPins objectAtIndex:pinNumber]);
        
        if(digital){
            cell = [self.table dequeueReusableCellWithIdentifier:@"digitalCell"];
        } else {
            cell = [self.table dequeueReusableCellWithIdentifier:@"analogCell"];
        }
        
        ((GMPPinCell*)cell).pin = pin;
    } else {
        
        NSInteger idx = indexPath.row;
        GMPI2CComponent * component = [self.gmpPinsController.i2cComponents objectAtIndex:idx];
        
         cell = [self.table dequeueReusableCellWithIdentifier:@"i2cCell"];
        ((GMPI2CComponentCell*) cell).component = component;
    }
    
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if( [segue.identifier isEqualToString:@"toI2CDeviceSegue"]){
        GMPI2CComponentViewController * viewController = segue.destinationViewController;
        viewController.delegate = self;
        
        GMPI2CComponentCell * cell = (GMPI2CComponentCell*) [self.table cellForRowAtIndexPath:self.table.indexPathForSelectedRow];
        viewController.component = cell.component;
        
        goingToI2CScene = YES;
    }
}

#pragma mark - i2cComponent Delegate

//called after view did appear when there is a component to remove
-(void) removeComponentAnimated{
    
    GMPI2CComponentCell * cell = (GMPI2CComponentCell*) [self.table cellForRowAtIndexPath:self.removingComponentPath];
    [cell removeComponentObservers];
    
    [self.table scrollToRowAtIndexPath:self.removingComponentPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.removingComponentPath] withRowAnimation:UITableViewRowAnimationFade];
    
    self.removingComponent = nil;
}

-(void) i2cComponentRemoved:(GMPI2CComponent*) component{
    NSInteger row = [self.gmpPinsController.i2cComponents indexOfObject:component];
    self.removingComponentPath = [NSIndexPath indexPathForRow:row inSection:2];
    
    self.gmpPinsController.delegate = nil;
    [self.gmpPinsController removeI2CComponent:component];
    self.gmpPinsController.delegate = self;
    
    self.removingComponent = component;
}

-(void) i2cComponent:(GMPI2CComponent*) component wroteData:(NSString*) data toRegister:(GMPI2CRegister*) reg{
    NSInteger value = data.integerValue;
    uint8_t buf[2];
    [GMPHelper valueAsTwo7bitBytes:value buffer:buf];
    [self.gmpPinsController.gmpController sendI2CWriteToAddress:component.address reg:reg.number values:buf numValues:1];
}

-(void) i2cComponent:(GMPI2CComponent*) component startedNotifyingRegister:(GMPI2CRegister*) reg{
    [self.gmpPinsController.gmpController sendI2CStartReadingAddress:component.address reg:reg.number size:reg.numElements * reg.sizePerElement];
}

-(void) i2cComponent:(GMPI2CComponent*) component stoppedNotifyingRegister:(GMPI2CRegister*) reg{
    [self.gmpPinsController.gmpController sendI2CStopStreamingAddress:component.address];
}

-(void) i2cComponent:(GMPI2CComponent *)component addedRegister:(GMPI2CRegister *)reg{
    [self.gmpPinsController addI2CRegister:reg toComponent:component];
}

-(void) i2cComponent:(GMPI2CComponent *)component removedRegister:(GMPI2CRegister *)reg{
    [self.gmpPinsController removeI2CRegister:reg fromComponent:component];
}

#pragma mark - Additional Options

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 0){
        
        [self addI2CComponent];
        
    } else if(buttonIndex == 1){
        
        [self.gmpPinsController.gmpController sendResetRequest];
        [self.gmpPinsController reset];
        [self.gmpPinsController.gmpController sendFirmwareRequest];
    }
    
    NSLog(@"%d",buttonIndex);
}

-(void) addI2CComponent {
    
    GMPI2CComponent * component = [[GMPI2CComponent alloc] init];
    component.name = @"New I2C Component";
    component.address = 24;
    
    [self.gmpPinsController addI2CComponent:component];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.gmpPinsController.i2cComponents.count-1 inSection:2];
    [self.table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (IBAction)optionsMenuTapped:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Add I2C Component",@"Reset Firmata", nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [actionSheet showInView:[self view]];
    
}

@end
