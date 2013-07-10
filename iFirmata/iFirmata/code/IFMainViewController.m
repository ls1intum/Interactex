//
//  MainViewController.m
//  iFirmata
//
//  Created by Juan Haladjian on 6/27/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "IFMainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "IFDeviceMenuViewController.h"

@implementation IFMainViewController

const NSInteger IFRefreshHeaderHeight = 56;
const NSInteger IFDiscoveryTime = 5;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [BLEDiscovery sharedInstance].discoveryDelegate = self;
    [[BLEDiscovery sharedInstance] startScanningForUUIDString:kBleServiceUUIDString];
    
    self.stopRefreshingButton.layer.borderWidth = 1.0f;
    self.stopRefreshingButton.layer.cornerRadius = 5.0f;
    self.stopRefreshingButton.layer.backgroundColor = [UIColor redColor].CGColor;
}

-(void) viewWillAppear:(BOOL)animated{
    if(self.table.indexPathForSelectedRow){
        [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [BLEDiscovery sharedInstance].foundPeripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    CBPeripheral * peripheral = [[BLEDiscovery sharedInstance].foundPeripherals objectAtIndex:row];
    
    UITableViewCell * cell = [self.table dequeueReusableCellWithIdentifier:@"mainViewCell"];
    
    cell.textLabel.text = peripheral.name;
    cell.detailTextLabel.text = [IFHelper UUIDToString:peripheral.UUID];
    
    return cell;
}

#pragma mark TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"toDeviceMenuSegue" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toDeviceMenuSegue"]){
        
        NSInteger row = self.table.indexPathForSelectedRow.row;
        CBPeripheral * peripheral = [[BLEDiscovery sharedInstance].foundPeripherals objectAtIndex:row];
        
        IFDeviceMenuViewController * viewController = segue.destinationViewController;
        viewController.currentPeripheral = peripheral;
    }
}

#pragma mark LeDiscoveryDelegate

- (void) discoveryDidRefresh {
    NSLog(@"refresh");
    /*
     self.bleService.delegate = self;
     
     [self.currentlyConnectedLabel setText:[peripheral name]];
     [self.currentlyConnectedLabel setEnabled:YES];*/
}

- (void) peripheralDiscovered:(CBPeripheral*) peripheral {
    [self.table reloadData];
}

- (void) discoveryStatePoweredOff {
    NSLog(@"Powered Off");
}

#pragma mark -- Refreshing Scrolled

-(void) secondElapsed:(NSTimer*) timer{
    
    secondsRemaining--;
        
    self.refreshingLabel.text = [NSString stringWithFormat:@"Refreshing... %ds left",secondsRemaining];
    
    if(secondsRemaining == 0){
        [self stopRefreshing];
    }
}

- (void) startRefreshingPeripherals {
    isRefreshing = YES;
    [[BLEDiscovery sharedInstance] startScanningForUUIDString:kBleServiceUUIDString];

    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        self.table.contentInset = UIEdgeInsetsMake(IFRefreshHeaderHeight, 0, 0, 0);
        
        [self. activityIndicator startAnimating];
        self.refreshingLabel.hidden = NO;
        self.stopRefreshingButton.hidden = NO;
        
        self.refreshingLabel.text = [NSString stringWithFormat:@"Refreshing... %ds left",IFDiscoveryTime];
        
    }];
    
    secondsRemaining = IFDiscoveryTime;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(secondElapsed:) userInfo:nil repeats:YES];
}

-(void) stopRefreshing{
    isRefreshing = NO;
    [[BLEDiscovery sharedInstance] stopScanning];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [self.activityIndicator stopAnimating];
        self.refreshingLabel.hidden = YES;
        self.stopRefreshingButton.hidden = YES;
        
    } completion:^(BOOL finished){
        
    }];
    
    [self.activityIndicator stopAnimating];
    
    [timer invalidate];
    timer = nil;
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!isRefreshing && scrollView.contentOffset.y <= -IFRefreshHeaderHeight) {
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!isRefreshing && scrollView.contentOffset.y <= -IFRefreshHeaderHeight) {
        [self startRefreshingPeripherals];
    }
}

- (IBAction)stopRefreshingPushed:(id)sender {
    [self stopRefreshing];
}

@end
