//
//  GMPViewController.m
//  iGMP
//
//  Created by Juan Haladjian on 11/6/13.
//  Copyright (c) 2013 Technical University Munich. All rights reserved.
//

#import "GMPViewController.h"
#import "BLE.h"
#import "GMP.h"
#import "GMPBLECommunicationModule.h"
#import "GMPPinsController.h"
#import "GMPDelegate.h"

@implementation GMPViewController

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
    
    [[BLEDiscovery sharedInstance] startScanningForSupportedUUIDs];
    [BLEDiscovery sharedInstance].discoveryDelegate = self;
    [BLEDiscovery sharedInstance].peripheralDelegate = self;
    
    self.gmpDelegate = [[GMPDelegate alloc] init];
    self.gmpController = [[GMP alloc] init];
    self.gmpController.delegate = self.gmpDelegate;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark BleDiscoveryDelegate

- (void) discoveryDidRefresh {
}

- (void) peripheralDiscovered:(CBPeripheral*) peripheral {
    
    [[BLEDiscovery sharedInstance] connectPeripheral:peripheral];
}

- (void) discoveryStatePoweredOff {
    NSLog(@"Powered Off");
}

#pragma mark BleServiceProtocol

-(void) bleServiceDidConnect:(BLEService *)service{
    GMPBLECommunicationModule *communicationModule = [[GMPBLECommunicationModule alloc] init];
    
    service.delegate = self;
    service.dataDelegate = communicationModule;
    service.shouldUseCRC = YES;
    
    communicationModule.bleService = service;
    communicationModule.gmpController = self.gmpController;
    
    self.gmpController.communicationModule = communicationModule;
    
    
    //self.gmpController.delegate = gmpDelegate;
}

-(void) bleServiceDidDisconnect:(BLEService *)service{
    
}

-(void) bleServiceIsReady:(BLEService *)service{
}

-(void) bleServiceDidReset {
}

-(void) reportMessage:(NSString*) message{
    NSLog(@"%@",message);
}


#pragma mark UI Interaction

- (IBAction)sendFirmwareTapped:(id)sender {
    [self.gmpController sendFirmwareRequest];
}

- (IBAction)sendModesTapped:(id)sender {
    
    pin_t pinModes[3];
    
    pinModes[0].index = 1;
    pinModes[1].index = 2;
    pinModes[2].index = 3;
    
    pinModes[0].capability = I2C;
    pinModes[1].capability = UART;
    pinModes[2].capability = SPI;
    
    [self.gmpController sendPinModesForPins:pinModes count:3];
    //[self.gmpController sendPinModeForPin:9 mode:GPIO | I2C];
}

- (IBAction)sendGroupTapped:(id)sender {
    
}

- (IBAction)sendResetTapped:(id)sender {
    [self.gmpController sendResetRequest];
}

- (IBAction)sendI2CTapped:(id)sender {
    
    //[self.gmpController sendI2CReadAddress:104 reg:0x3B size:6];
    [self.gmpController sendI2CStartReadingAddress:104 reg:0x3B size:6];
}

- (IBAction)sendI2CStopTapped:(id)sender {
    [self.gmpController sendI2CStopStreamingAddress:104];
}

@end
