//
//  IFFirmataViewController.m
//  iFirmata
//
//  Created by Juan Haladjian on 6/27/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "IFFirmataViewController.h"
#import "IFPinCell.h"
#import "IFPin.h"
#import "IFFirmataController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEDiscovery.h"

@implementation IFFirmataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void) viewWillAppear:(BOOL)animated{
    if(self.firmataController.numAnalogPins == 0 && self.firmataController.numDigitalPins == 0){
        [self.firmataController stop];
        [self.firmataController start];
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    [self.firmataController stopReportingAnalogPins];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setFirmataController:(IFFirmataController *)firmataController{
    if(_firmataController != firmataController){
        _firmataController = firmataController;
        _firmataController.delegate = self;
    }
}

#pragma mark FirmataDelegate

-(void) didUpdatePins{
    [self.table reloadData];
}

#pragma mark TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"Digital";
    } else return @"Analog";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return self.firmataController.digitalPins.count;
    } else {
        return self.firmataController.analogPins.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger pinNumber = indexPath.row;
    BOOL digital = (indexPath.section == 0);
    IFPin * pin = (digital ? [self.firmataController.digitalPins objectAtIndex:pinNumber] : [self.firmataController.analogPins objectAtIndex:pinNumber]);
    
    IFPinCell * cell;
    if(digital){
        if(pin.supportsPwm){
            cell = [self.table dequeueReusableCellWithIdentifier:@"digitalPWMCell"];
        } else {
            cell = [self.table dequeueReusableCellWithIdentifier:@"digitalNormalCell"];
        }
    } else {
        cell = [self.table dequeueReusableCellWithIdentifier:@"analogCell"];
    }
    
    cell.pin = pin;
    return cell;
}


- (IBAction)segmentedControlChanged:(id)sender {
    
}

- (IBAction)versionTapped:(id)sender {
    
    [self.firmataController stopReportingAnalogPins];
    [self.firmataController stop];
    [self.firmataController start];
    
    //[self.firmataController sendFirmwareRequest];
    //[self.firmataController.bleService clearRx];
}

-(void) dealloc{
}

@end
