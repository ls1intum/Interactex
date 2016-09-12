//
//  THDeviceViewController.m
//  TangoHapps
//
//  Created by Juan Haladjian on 20/07/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THDeviceViewController.h"
#import "THDeviceCell.h"

@interface THDeviceViewController ()

@end


float const kConnectingTimeout = 7.0f;
const NSInteger THRefreshHeaderHeight = 60;
const NSInteger IFDiscoveryTime = 3;

@implementation THDeviceViewController

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
    
    
    //[self startScanningDevices];
    
}
-(void) viewWillAppear:(BOOL)animated{
    if(self.table.indexPathForSelectedRow){
        [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:NO];
    }
    
    if([BLEDiscovery sharedInstance].currentPeripheral.state == CBPeripheralStateConnected){
        [self disconnect];
    }
    
    refreshHeaderTop = self.table.contentInset.top;
    
    //[self startRefreshingPeripherals];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Ble Interaction


-(void) connectingTimedOut{
    
    [connectingTimer invalidate];
    connectingTimer = nil;
    
    isConnecting = NO;
    
    if([BLEDiscovery sharedInstance].currentPeripheral){
        [[BLEDiscovery sharedInstance] disconnectCurrentPeripheral];
    }
    

    //[self updateStartButtonToScan];
}

-(void) disconnect{
    
    if([BLEDiscovery sharedInstance].currentPeripheral){
        [[BLEDiscovery sharedInstance].connectedService stop];
        [[BLEDiscovery sharedInstance] disconnectCurrentPeripheral];
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
    NSLog(@"connected");
    shouldDisconnect = NO;
    service.delegate = self;
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
            THDeviceCell * cell = (THDeviceCell*) [self.table cellForRowAtIndexPath:connectingRow];
            [cell.activityIndicator stopAnimating];
        }
    }
  
    [self.delegate bleDeviceDisconnected:service];
}

-(void) bleServiceIsReady:(BLEService *)service{
    isConnecting = NO;
    
    [connectingTimer invalidate];
    connectingTimer = nil;
    
    THDeviceCell * cell = (THDeviceCell*) [self.table cellForRowAtIndexPath:connectingRow];
    [cell.activityIndicator stopAnimating];
    
    [self.delegate bleDeviceConnected:service];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) connectToPeripheralAtIndexPath:(NSIndexPath*) indexPath{
    
    CBPeripheral * peripheral = [[BLEDiscovery sharedInstance].foundPeripherals objectAtIndex:indexPath.row];
    
    if(peripheral.state != CBPeripheralStateConnected){
        
        [[BLEDiscovery sharedInstance] connectPeripheral:peripheral];
        
        THDeviceCell * cell = (THDeviceCell*) [self.table cellForRowAtIndexPath:indexPath];
        [cell.activityIndicator startAnimating];
        connectingRow = indexPath;
        isConnecting = YES;
        /*
        NSTimeInterval interval = 7.0f;
        connectingTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(stopConnecting) userInfo:nil repeats:NO];*/
    }
}


#pragma mark TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [BLEDiscovery sharedInstance].foundPeripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    CBPeripheral * peripheral = [[BLEDiscovery sharedInstance].foundPeripherals objectAtIndex:row];
    
    THDeviceCell * cell = [self.table dequeueReusableCellWithIdentifier:@"deviceCell"];
    cell.titleLabel.text = peripheral.name;
    cell.uiidLabel.text = peripheral.identifier.UUIDString;
    
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


#pragma mark -- Refreshing Scrolled

-(void) secondElapsed:(NSTimer*) timer{
    
    secondsRemaining--;
    
    self.refreshingLabel.text = [NSString stringWithFormat:@"Refreshing... %lds left",(long)secondsRemaining];
    
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
        self.table.contentInset = UIEdgeInsetsMake(THRefreshHeaderHeight, 0, 0, 0);
        
        [self. activityIndicator startAnimating];
        self.refreshingLabel.hidden = NO;
        
        self.refreshingLabel.text = [NSString stringWithFormat:@"Refreshing... %lds left",(long)IFDiscoveryTime];
        
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
    
    if(self.navigationController.topViewController == self){
        AudioServicesPlaySystemSound(pullUpSound);
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"%f",scrollView.contentOffset.y);
    
    if (!shouldRefreshOnRelease && !isRefreshing && scrollView.contentOffset.y <= -THRefreshHeaderHeight) {
        self.refreshingLabel.text = [NSString stringWithFormat:@"Release to refresh"];
        shouldRefreshOnRelease = YES;
        self.arrowImageView.image = [UIImage imageNamed:@"arrowUp.png"];
        
        AudioServicesPlaySystemSound(pullDownSound);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!isRefreshing && scrollView.contentOffset.y <= -THRefreshHeaderHeight && shouldRefreshOnRelease) {
        
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
