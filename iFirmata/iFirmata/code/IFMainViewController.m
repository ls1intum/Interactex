//
//  MainViewController.m
//  iFirmata
//
//  Created by Juan Haladjian on 6/27/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "IFMainViewController.h"
#import "IFDeviceMenuViewController.h"
#import "IFDeviceCell.h"

@implementation IFMainViewController

const NSInteger IFRefreshHeaderHeight = 120;
const NSInteger IFDiscoveryTime = 3;

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
    [BLEDiscovery sharedInstance].peripheralDelegate = self;
    
    [[BLEDiscovery sharedInstance] startScanningForSupportedUUIDs];
    
    NSURL * pullDownSoundUrl = [[NSBundle mainBundle] URLForResource: @"pullDown" withExtension: @"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pullDownSoundUrl, &pullDownSound);
    
    NSURL * pullUpSoundUrl = [[NSBundle mainBundle] URLForResource: @"pullUp" withExtension: @"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pullUpSoundUrl, &pullUpSound);
    
}

-(void) viewWillAppear:(BOOL)animated{
    if(self.table.indexPathForSelectedRow){
        [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:NO];
    }
    
    if([BLEDiscovery sharedInstance].currentPeripheral.isConnected){
        [self disconnect];
    }
    
    refreshHeaderTop = self.table.contentInset.top;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) connectToPeripheralAtIndexPath:(NSIndexPath*) indexPath{

    CBPeripheral * peripheral = [[BLEDiscovery sharedInstance].foundPeripherals objectAtIndex:indexPath.row];
    
    if(!peripheral.isConnected){
        [[BLEDiscovery sharedInstance] connectPeripheral:peripheral];
        
        IFDeviceCell * cell = (IFDeviceCell*) [self.table cellForRowAtIndexPath:indexPath];
        [cell.activityIndicator startAnimating];
        connectingRow = indexPath;
        isConnecting = YES;
        
        NSTimeInterval interval = 7.0f;
        connectingTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(stopConnecting) userInfo:nil repeats:NO];
    }
}
#pragma mark TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [BLEDiscovery sharedInstance].foundPeripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    CBPeripheral * peripheral = [[BLEDiscovery sharedInstance].foundPeripherals objectAtIndex:row];
    
    IFDeviceCell * cell = [self.table dequeueReusableCellWithIdentifier:@"deviceCell"];
    cell.titleLabel.text = peripheral.name;
    //cell.uiidLabel.text = [BLEHelper UUIDToString:peripheral.UUID];
    
    //CFStringRef string = CFUUIDCreateString(NULL, (peripheral.UUID));//bug here
    //cell.uiidLabel.text = (__bridge_transfer NSString *)string;
    
    return cell;
}

#pragma mark TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self connectToPeripheralAtIndexPath:self.table.indexPathForSelectedRow];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toDeviceMenuSegue"]){
    }
}

#pragma mark Connection

-(void) disconnect{
    
    self.table.allowsSelection = NO;
    [[BLEDiscovery sharedInstance] disconnectCurrentPeripheral];
}

-(void) stopConnecting{
    
    [connectingTimer invalidate];
    connectingTimer = nil;
    
    NSLog(@"stopping connection");
    isConnecting = NO;
    
    if([BLEDiscovery sharedInstance].currentPeripheral){
        [self disconnect];
    }
}

#pragma mark BleDiscoveryDelegate

- (void) discoveryDidRefresh {
    [self.table reloadData];
    
    NSLog(@"refreshed disc");
}

- (void) peripheralDiscovered:(CBPeripheral*) peripheral {
    [self.table reloadData];
}

- (void) discoveryStatePoweredOff {
    NSLog(@"Powered Off");
}

#pragma mark BleServiceProtocol

-(void) bleServiceDidConnect:(BLEService *)service{
    service.delegate = self;
    isConnecting = NO;
}

-(void) bleServiceDidDisconnect:(BLEService *)service{
    NSLog(@"disconnected");
    
    [connectingTimer invalidate];
    connectingTimer = nil;
    
    if(isConnecting){
        
        [self connectToPeripheralAtIndexPath:connectingRow];
        
    } else {
        
        self.table.allowsSelection = YES;
        
        if(connectingRow){
            [self.table deselectRowAtIndexPath:connectingRow animated:YES];
            IFDeviceCell * cell = (IFDeviceCell*) [self.table cellForRowAtIndexPath:connectingRow];
            [cell.activityIndicator stopAnimating];
        }
    }
    
    if(self.navigationController.topViewController != self){
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

-(void) bleServiceIsReady:(BLEService *)service{
    NSLog(@"ready");
    
    [connectingTimer invalidate];
    connectingTimer = nil;
    
    IFDeviceCell * cell = (IFDeviceCell*) [self.table cellForRowAtIndexPath:connectingRow];
    [cell.activityIndicator stopAnimating];
    
    [self performSegueWithIdentifier:@"toDeviceMenuSegue" sender:self];
    
    //[service clearRx];
}

-(void) bleServiceDidReset {
}

-(void) reportMessage:(NSString*) message{
    NSLog(@"%@",message);
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
    [[BLEDiscovery sharedInstance] startScanningForSupportedUUIDs];
    [self.table reloadData];
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        self.table.contentInset = UIEdgeInsetsMake(IFRefreshHeaderHeight, 0, 0, 0);
        
        [self. activityIndicator startAnimating];
        self.refreshingLabel.hidden = NO;
        
        self.refreshingLabel.text = [NSString stringWithFormat:@"Refreshing... %ds left",IFDiscoveryTime];
        
    }];
    
    secondsRemaining = IFDiscoveryTime;
    refreshingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(secondElapsed:) userInfo:nil repeats:YES];
}

-(void) stopRefreshing{
    isRefreshing = NO;
    self.arrowImageView.hidden = NO;
    
    [[BLEDiscovery sharedInstance] stopScanning];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.table.contentInset = UIEdgeInsetsMake(refreshHeaderTop, 0, 0, 0);
        
        [self.activityIndicator stopAnimating];
        self.refreshingLabel.text = [NSString stringWithFormat:@"Pull down to refresh"];
        
    } completion:^(BOOL finished){
        
    }];
    
    [self.activityIndicator stopAnimating];
    
    [refreshingTimer invalidate];
    refreshingTimer = nil;
    
    AudioServicesPlaySystemSound(pullUpSound);
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"%f",scrollView.contentOffset.y);
    
    if (!shouldRefreshOnRelease && !isRefreshing && scrollView.contentOffset.y <= -IFRefreshHeaderHeight) {
        self.refreshingLabel.text = [NSString stringWithFormat:@"Release to refresh"];
        shouldRefreshOnRelease = YES;
        self.arrowImageView.image = [UIImage imageNamed:@"arrowUp.png"];
        
        AudioServicesPlaySystemSound(pullDownSound);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!isRefreshing && scrollView.contentOffset.y <= -IFRefreshHeaderHeight && shouldRefreshOnRelease) {
        
        shouldRefreshOnRelease = NO;
        self.arrowImageView.image = [UIImage imageNamed:@"arrowDown.png"];
        self.arrowImageView.hidden = YES;
        
        [self startRefreshingPeripherals];
    }
}

-(void) dealloc{
    AudioServicesDisposeSystemSoundID(pullDownSound);
    AudioServicesDisposeSystemSoundID(pullUpSound);
}

@end
