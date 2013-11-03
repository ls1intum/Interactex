//
//  IFCharacteristicsViewController.m
//  iFirmata
//
//  Created by Juan Haladjian on 6/30/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "IFCharacteristicsViewController.h"
#import "BLEService.h"
#import "IFCharacteristicDetailsViewController.h"
#import "BLEDiscovery.h"
#import "BLEHelper.h"

@implementation IFCharacteristicsViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark TableViewDataSource
/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 2;
    } else {
        return 5;
    }
    //return [BLEDiscovery sharedInstance].foundPeripherals.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    CBCharacteristic * peripheral = [self characteristicWithIdx:row];
    
    UITableViewCell * cell = [self.table dequeueReusableCellWithIdentifier:@"mainViewCell"];
    
    cell.textLabel.text = peripheral.name;
    cell.detailTextLabel.text = [IFHelper UUIDToString:peripheral.UUID];
    
    return cell;
}
*/

#pragma mark TableViewDelegate
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0) {
            CBPeripheral * peripheral = [BLEDiscovery sharedInstance].currentPeripheral;
            if(peripheral){
                
                CBUUID * uuid = [CBUUID UUIDWithCFUUID:peripheral.UUID];
                cell.detailTextLabel.text = [BLEHelper UUIDToString:uuid];
            }
            
        } else if(indexPath.row == 1){
            BLEService * service = [BLEDiscovery sharedInstance].connectedService;
            if(service){
                
                cell.detailTextLabel.text = [BLEHelper UUIDToString:(service.uuid)];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 1){
        [self performSegueWithIdentifier:@"toCharacteristicDetailsSegue" sender:self];
    }
}

-(CBCharacteristic*) characteristicWithIdx:(NSInteger) idx{
   // BLEService * bleService = [BLEDiscovery sharedInstance].connectedService;
    
    /*
    if(idx == 0){
        return bleService.bdCharacteristic;
    } else if(idx == 1){
        return bleService.rxCharacteristic;
    } else if(idx == 2){
        return bleService.rxCountCharacteristic;
    } else if(idx == 3){
        return bleService.rxClearCharacteristic;
    } else if(idx == 4){
        return bleService.txCharacteristic;
    }*/
    
    return nil;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toCharacteristicDetailsSegue"]){
        
        NSInteger row = self.table.indexPathForSelectedRow.row;
        CBCharacteristic * characteristic = [self characteristicWithIdx:row];
        if(characteristic){
            
            BLEService * bleService = [BLEDiscovery sharedInstance].connectedService;
            IFCharacteristicDetailsViewController * viewController = segue.destinationViewController;
            viewController.title = [bleService characteristicNameFor:characteristic];
            viewController.currentCharacteristic = characteristic;
            viewController.bleService = bleService;
        }
    }
}

@end
