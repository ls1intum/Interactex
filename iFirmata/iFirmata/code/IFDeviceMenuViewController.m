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
    
    [BLEDiscovery sharedInstance].peripheralDelegate = self;
}

-(void) viewWillAppear:(BOOL)animated{
    if(!self.currentPeripheral.isConnected){
        [self startSpinning];
    } else {
        
    }
    
    self.title = self.currentPeripheral.name;
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

-(void) startSpinning{
    self.view.alpha = 0.5f;
    [self.activityIndicator startAnimating];
}

-(void) stopSpinning{
    self.view.alpha = 1.0f;
    [self.activityIndicator stopAnimating];
}

#pragma mark Connection

-(void) connect{
    [self.bleService start];
    [self startSpinning];
}

-(void) disconnect{
    [self.bleService disconnect];
    [self stopSpinning];
}

#pragma mark BleServiceProtocol

-(void) enableButtons{
    
    self.firmataButton.enabled = YES;
    self.characteristicsButton.enabled = YES;
}

-(void) disableButtons{
    
    self.firmataButton.enabled = NO;
    self.characteristicsButton.enabled = NO;
}

-(void) bleServiceDidConnect:(BLEService *)service{
    [self enableButtons];
    
    self.bleService = service;
    self.firmataController.bleService = self.bleService;
    self.bleService.delegate = self;
    
}

-(void) bleServiceDidDisconnect:(BLEService *)service{
    if(service == _bleService){
        
        [self disableButtons];
        self.bleService.delegate = nil;
        self.bleService = nil;
        [self.firmataController stop];
    }
}

-(void) bleServiceIsReady:(BLEService *)service{
    [service clearRx];
    [self stopSpinning];
}

-(void) bleServiceDidReset {
    [self.firmataController stop];
    _bleService = nil;
    [self stopSpinning];
}

-(void) dataReceived:(Byte *)buffer lenght:(NSInteger)length{

    [self.firmataController dataReceived:buffer lenght:length];
}

-(void) reportMessage:(NSString *)message{
    NSLog(@"%@",message);
}

@end
