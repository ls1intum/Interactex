//
//  IFDeviceMenuViewController.m
//  iFirmata
//
//  Created by Juan Haladjian on 6/30/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "IFDeviceMenuViewController.h"
#import "BLEDiscovery.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "IFFirmataController.h"
#import "IFFirmataViewController.h"
#import "IFCharacteristicsViewController.h"

@implementation IFDeviceMenuViewController

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
    
    self.firmataController = [[IFFirmataController alloc] init];
    
}

-(void) viewWillAppear:(BOOL)animated{
    if(!self.currentPeripheral.isConnected){
        
        self.title = self.currentPeripheral.name;
        [BLEDiscovery sharedInstance].peripheralDelegate = self;
        [[BLEDiscovery sharedInstance] connectPeripheral:self.currentPeripheral];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self disconnect];
    }
    [super viewWillDisappear:animated];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toFirmataSegue"]){
        
        IFFirmataViewController * firmataViewController = segue.destinationViewController;
        firmataViewController.firmataController = self.firmataController;
        
    } else if([segue.identifier isEqualToString:@"toCharacteristicsSegue"]){
        IFCharacteristicsViewController * viewController = segue.destinationViewController;
        viewController.bleService = self.bleService;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Conncetion

-(void) connect{
    [self.bleService start];
}

-(void) disconnect{
    [self.bleService disconnect];
}

#pragma mark BleServiceProtocol

-(void) bleServiceDidConnect:(BLEService *)service{
    
    self.bleService = service;
    self.firmataController.bleService = self.bleService;
    self.bleService.delegate = self;
}

-(void) bleServiceDidDisconnect:(BLEService *)service{
    if(service == _bleService){
        self.bleService.delegate = nil;
        self.bleService = nil;
    }
}

-(void) bleServiceIsReady:(BLEService *)service{
    
    [service clearRx];
}

-(void) bleServiceDidReset {
    _bleService = nil;
}

-(void) dataReceived:(Byte *)buffer lenght:(NSInteger)length{
    NSLog(@"receives data in devicemenu");
    [self.firmataController dataReceived:buffer lenght:length];
}

-(void) reportMessage:(NSString *)message{
    NSLog(@"%@",message);
}

@end
