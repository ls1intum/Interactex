//
//  IFFirmataViewController.m
//  iFirmata
//
//  Created by Juan Haladjian on 6/27/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

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

@implementation IFViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.firmataPinsController = appDelegate.firmataController;
    
    [self loadPersistedObjects];
}

-(void) viewWillAppear:(BOOL)animated{
    
    IFFirmataBLECommunicationModule * commModule = [[IFFirmataBLECommunicationModule alloc] init];
    commModule.bleService = [BLEDiscovery sharedInstance].connectedService;
    
    self.firmataPinsController.firmataController.communicationModule = commModule;
    [BLEDiscovery sharedInstance].connectedService.dataDelegate = self.firmataPinsController.firmataController;
    
    if(self.firmataPinsController.analogPins.count == 0 && self.firmataPinsController.digitalPins.count == 0){
        
        [self.firmataPinsController.firmataController sendFirmwareRequest];
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
        
        [self.firmataPinsController stopReportingI2CComponents];
        [self.firmataPinsController stopReportingAnalogPins];
        [self persistObjects];
    }
    goingToI2CScene = NO;
}

-(void) loadPersistedObjects{
        
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:IFDefaultsI2CComponents];
    if(data){
        self.firmataPinsController.i2cComponents = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

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
    /*
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.table reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];*/
}

-(void) firmataDidUpdateAnalogPins:(IFPinsController *)firmataController{
    [self.table reloadData];/*
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:1];
    [self.table reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];*/
}

-(void) firmataDidUpdateI2CComponents:(IFPinsController *)firmataController{

    //[self.table reloadData];
    
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:2];
    [self.table reloadSections:indexSet withRowAnimation:UITableViewRowAnimationTop];
}

-(void) firmata:(IFPinsController *)firmataController didUpdateTitle:(NSString *)title{
    self.title = title;
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
        return self.firmataPinsController.digitalPins.count;
    } else if(section == 1){
        return self.firmataPinsController.analogPins.count;
    } else {
        return self.firmataPinsController.i2cComponents.count;
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
        IFPin * pin = (digital ? [self.firmataPinsController.digitalPins objectAtIndex:pinNumber] : [self.firmataPinsController.analogPins objectAtIndex:pinNumber]);
        
        if(digital){
            cell = [self.table dequeueReusableCellWithIdentifier:@"digitalCell"];
        } else {
            cell = [self.table dequeueReusableCellWithIdentifier:@"analogCell"];
        }
        
        ((IFPinCell*)cell).pin = pin;
    } else {
        
        NSInteger idx = indexPath.row;
        IFI2CComponent * component = [self.firmataPinsController.i2cComponents objectAtIndex:idx];
        
         cell = [self.table dequeueReusableCellWithIdentifier:@"i2cCell"];
        ((IFI2CComponentCell*) cell).component = component;
    }
    
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if( [segue.identifier isEqualToString:@"toI2CDeviceSegue"]){
        IFI2CComponentViewController * viewController = segue.destinationViewController;
        viewController.delegate = self;
        
        IFI2CComponentCell * cell = (IFI2CComponentCell*) [self.table cellForRowAtIndexPath:self.table.indexPathForSelectedRow];
        viewController.component = cell.component;
        
        goingToI2CScene = YES;
    }
}

#pragma mark - i2cComponent Delegate

//called after view did appear when there is a component to remove
-(void) removeComponentAnimated{
    
    IFI2CComponentCell * cell = (IFI2CComponentCell*) [self.table cellForRowAtIndexPath:self.removingComponentPath];
    [cell removeComponentObservers];
    
    [self.table scrollToRowAtIndexPath:self.removingComponentPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.removingComponentPath] withRowAnimation:UITableViewRowAnimationFade];
    
    self.removingComponent = nil;
}

-(void) i2cComponentRemoved:(IFI2CComponent*) component{
    NSInteger row = [self.firmataPinsController.i2cComponents indexOfObject:component];
    self.removingComponentPath = [NSIndexPath indexPathForRow:row inSection:2];
    
    self.firmataPinsController.delegate = nil;
    [self.firmataPinsController removeI2CComponent:component];
    self.firmataPinsController.delegate = self;
    
    self.removingComponent = component;
}

-(void) i2cComponent:(IFI2CComponent*) component wroteData:(NSString*) data toRegister:(IFI2CRegister*) reg{
    NSInteger value = data.integerValue;
    [self.firmataPinsController.firmataController sendI2CWriteValue:value toAddress:component.address reg:reg.number];
    
}

-(void) i2cComponent:(IFI2CComponent*) component startedNotifyingRegister:(IFI2CRegister*) reg{
    [self.firmataPinsController.firmataController sendI2CStartReadingAddress:component.address reg:reg.number size:reg.size];
}

-(void) i2cComponent:(IFI2CComponent*) component stoppedNotifyingRegister:(IFI2CRegister*) reg{
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
        
        [self addI2CComponent];
        
    } else if(buttonIndex == 1){
        
        [self.firmataPinsController.firmataController sendResetRequest];
        [self.firmataPinsController reset];
        [self.firmataPinsController.firmataController sendFirmwareRequest];
    }
    
    NSLog(@"%d",buttonIndex);
}

-(void) addI2CComponent {
    
    IFI2CComponent * component = [[IFI2CComponent alloc] init];
    component.name = @"New I2C Component";
    component.address = 24;
    
    [self.firmataPinsController addI2CComponent:component];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.firmataPinsController.i2cComponents.count-1 inSection:2];
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
