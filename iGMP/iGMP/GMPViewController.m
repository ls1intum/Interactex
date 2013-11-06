//
//  GMPViewController.m
//  iGMP
//
//  Created by Juan Haladjian on 11/6/13.
//  Copyright (c) 2013 Technical University Munich. All rights reserved.
//

#import "GMPViewController.h"
#import "BLE.h"

@interface GMPViewController ()

@end

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
}

- (void) discoveryStatePoweredOff {
    NSLog(@"Powered Off");
}

#pragma mark BleServiceProtocol

-(void) bleServiceDidConnect:(BLEService *)service{
    service.delegate = self;
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

@end
