//
//  FDMainViewController.m
//  iFirmataDemo
//
//  Created by Juan Haladjian on 10/21/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "FDMainViewController.h"
//#import "BLEHelper.h"


@interface FDMainViewController ()

@end

@implementation FDMainViewController

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
    
    [BLEDiscovery sharedInstance].discoveryDelegate = self;
    [BLEDiscovery sharedInstance].peripheralDelegate = self;
    [[BLEDiscovery sharedInstance] startScanningForAnyUUID];
    
    
    self.firmataController = [[IFFirmataController alloc] init];
    self.firmataController.delegate = self;
    
    //[[BLEDiscovery sharedInstance] startScanningForUUIDString:kBleServiceUUIDString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark Connection

-(void) disconnect{
    
    [[BLEDiscovery sharedInstance] disconnectCurrentPeripheral];
}

-(void) stopConnecting{
    NSLog(@"stopping connection");
    if([BLEDiscovery sharedInstance].currentPeripheral){
        [self disconnect];
    }
}

#pragma mark BleDiscoveryDelegate

- (void) discoveryDidRefresh {
}

- (void) peripheralDiscovered:(CBPeripheral*) peripheral {
    self.availablePeripheral = peripheral;
    
}

- (void) discoveryStatePoweredOff {
    NSLog(@"Powered Off");
}

#pragma mark BleServiceProtocol

-(void) bleServiceDidConnect:(BLEService *)service{
    service.delegate = self;
    
    self.firmataController.bleService = service;
    self.firmataController.bleService.dataDelegate = self.firmataController;
    
    [self.connectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
}

-(void) bleServiceDidDisconnect:(BLEService *)service{
    [self.connectButton setTitle:@"Connect" forState:UIControlStateNormal];
}

-(void) bleServiceIsReady:(BLEService *)service{
    
    //[service clearRx];
}

-(void) bleServiceDidReset {
}

-(void) reportMessage:(NSString*) message{
    NSLog(@"%@",message);
}

- (IBAction)connectTapped:(id)sender {
    
    if([BLEDiscovery sharedInstance].connectedService){
        
        [[BLEDiscovery sharedInstance] disconnectCurrentPeripheral];
        
    } else {
        
        if(self.availablePeripheral){
            
            [[BLEDiscovery sharedInstance] connectPeripheral:self.availablePeripheral];
        }
    }
}

- (IBAction)sendTapped:(id)sender {
    if(self.on){
        [self.firmataController sendDigitalOutputForPort:1 value:0x00];
    } else {
        [self.firmataController sendDigitalOutputForPort:1 value:0x80];
    }
    self.on = !self.on;
}

- (IBAction)sendFirmwareTapped:(id)sender {
    [self.firmataController sendFirmwareRequest];
}

- (IBAction)sendCapabilitiesTapped:(id)sender {
    [self.firmataController sendCapabilitiesAndReportRequest];
}

@end
