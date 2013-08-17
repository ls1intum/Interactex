//
//  BLEFMainViewController.m
//  BLEFirmataDemo
//
//  Created by Juan Haladjian on 8/6/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "BLEFMainViewController.h"

@implementation BLEFMainViewController

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
    [BLEDiscovery sharedInstance].peripheralDelegate = self;
    [BLEDiscovery sharedInstance].discoveryDelegate = self;
    
    self.firmataController = [[IFFirmataController alloc] init];
    //[[BLEDiscovery sharedInstance] startScanningForUUIDString:kBleServiceUUIDString];
    [[BLEDiscovery sharedInstance] startScanningForAnyUUID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) sendTestData{
    
    uint8_t buf[16];
    for (int i = 0; i < 16; i++) {
        buf[i] = i+100;
        
    }
    BLEService * service = [BLEDiscovery sharedInstance].connectedService;
    if(!service){
        NSLog(@"no service!");
    }
    //[service sendData:buf count:16];
    [service writeToTx:[NSData dataWithBytes:buf length:16]];
}

-(void) sendFirmwareRequest{
    [self.firmataController sendFirmwareRequest];
}

-(void) stopSending{
    
    [timer invalidate];
    timer = nil;
}

-(void) updateButtonText{
    if(timer){
        [self.sendButton setTitle:@"Stop Sending" forState:UIControlStateNormal];
    } else {
        [self.sendButton setTitle:@"Start Sending" forState:UIControlStateNormal];
    }
}

- (IBAction) startSendingTapped:(id)sender {
    [self sendTestData];
    
    /*
    if(timer){
        [timer invalidate];
        timer = nil;
    } else {
        timer = [NSTimer scheduledTimerWithTimeInterval:kFlushInterval target:self selector:@selector(sendTestData) userInfo:nil repeats:YES];
    }
    
    [self updateButtonText];*/
}

-(void) updateConnectedLabel{
    if([BLEDiscovery sharedInstance].connectedService){
        self.connectedLabel.text = @"CONNECTED";
    } else {
        self.connectedLabel.text = @"NOT CONNECTED";
    }
}

#pragma mark BleServiceDataDelegate

-(void) dataReceived:(Byte*) buffer lenght:(NSInteger) length{
    
    NSString * text = @"";
    for (int i = 0 ; i < length; i++) {
        int value = buffer[i];
        text = [text stringByAppendingFormat:@"%d ",value];
    }
    
    NSLog(@"%@",text);
    
    self.receivedLabel.text = text;
}

#pragma mark BleDiscoveryDelegate

- (void) discoveryDidRefresh {
}

- (void) peripheralDiscovered:(CBPeripheral*) peripheral {
    if([BLEDiscovery sharedInstance].connectedService == nil){
        [[BLEDiscovery sharedInstance] connectPeripheral:peripheral];
    }
}

- (void) discoveryStatePoweredOff {
}

#pragma mark BleServiceProtocol

-(void) bleServiceDidConnect:(BLEService *)service{
    service.delegate = self;
    service.dataDelegate = self;
    self.firmataController.bleService = service;
    [self updateConnectedLabel];
}

-(void) bleServiceDidDisconnect:(BLEService *)service{
    [self updateConnectedLabel];
}

-(void) bleServiceIsReady:(BLEService *)service{
    
    [service clearRx];
}

-(void) bleServiceDidReset {
}

-(void) reportMessage:(NSString*) message{
}


@end
