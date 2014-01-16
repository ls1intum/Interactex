/*
GMPMainViewController.m
iGMP

Created by Juan Haladjian on 27/06/2013.

iGMP is an App to control an Arduino board over Bluetooth 4.0. iGMP uses the GMP protocol (based on Firmata): www.firmata.org

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany, 
	
Contacts:
juan.haladjian@cs.tum.edu
k.zhang@utwente.nl
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
It has been created with funding from EIT ICT, as part of the activity "Connected Textiles".


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "GMPMainViewController.h"
#import "GMPDeviceMenuViewController.h"
#import "GMPDeviceCell.h"

@implementation GMPMainViewController

const NSInteger GMPRefreshHeaderHeight = 120;
const NSInteger GMPDiscoveryTime = 3;

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
    
    if([BLEDiscovery sharedInstance].currentPeripheral.state == CBPeripheralStateConnected){
        [self disconnect];
    }
    
    refreshHeaderTop = self.table.contentInset.top;
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
    
    GMPDeviceCell * cell = [self.table dequeueReusableCellWithIdentifier:@"deviceCell"];
    cell.titleLabel.text = peripheral.name;
    //cell.uiidLabel.text = [BLEHelper UUIDToString:peripheral.UUID];
    
    //CFStringRef string = CFUUIDCreateString(NULL, (peripheral.UUID));//bug here
    //cell.uiidLabel.text = (__bridge_transfer NSString *)string;
    
    return cell;
}

#pragma mark TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = self.table.indexPathForSelectedRow.row;
    CBPeripheral * peripheral = [[BLEDiscovery sharedInstance].foundPeripherals objectAtIndex:row];
    
    if(peripheral.state != CBPeripheralStateConnected){
        [[BLEDiscovery sharedInstance] connectPeripheral:peripheral];
        
        GMPDeviceCell * cell = (GMPDeviceCell*) [self.table cellForRowAtIndexPath:indexPath];
        [cell.activityIndicator startAnimating];
        connectingRow = indexPath;
        
        NSTimeInterval interval = 7.0f;
        connectingTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(stopConnecting) userInfo:nil repeats:NO];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toDeviceMenuSegue"]){
        /*
        NSInteger row = self.table.indexPathForSelectedRow.row;
        CBPeripheral * peripheral = [[BLEDiscovery sharedInstance].foundPeripherals objectAtIndex:row];*/
        
        /*
        IFDeviceMenuViewController * deviceViewController = segue.destinationViewController;
        
        deviceViewController.currentPeripheral = peripheral;*/
        
        /*
        if(!deviceViewController.currentPeripheral.isConnected){
            [[BLEDiscovery sharedInstance] connectPeripheral:peripheral];
        }*/
    }
}

#pragma mark Connection

-(void) disconnect{
    
    isDisconnecting = YES;
    self.table.allowsSelection = NO;
    [[BLEDiscovery sharedInstance] disconnectCurrentPeripheral];
}

-(void) stopConnecting{
    NSLog(@"stopping connection");
    if([BLEDiscovery sharedInstance].currentPeripheral){
        [self disconnect];
        /*
         NSInteger row = connectingRow.row;
         CBPeripheral * peripheral = [[BLEDiscovery sharedInstance].foundPeripherals objectAtIndex:row];
         [[BLEDiscovery sharedInstance] cancelConnectionToPeripheral:peripheral];*/
        
        [connectingTimer invalidate];
        connectingTimer = nil;
    }
}

#pragma mark BleDiscoveryDelegate

- (void) discoveryDidRefresh {
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
}

-(void) bleServiceDidDisconnect:(BLEService *)service{

    self.table.allowsSelection = YES;
    
    isDisconnecting = NO;
    
    if(connectingRow){
        [self.table deselectRowAtIndexPath:connectingRow animated:YES];
        GMPDeviceCell * cell = (GMPDeviceCell*) [self.table cellForRowAtIndexPath:connectingRow];
        [cell.activityIndicator stopAnimating];
    }
    
    [connectingTimer invalidate];
    connectingTimer = nil;
}

-(void) bleServiceIsReady:(BLEService *)service{
    
    [connectingTimer invalidate];
    connectingTimer = nil;
    
    GMPDeviceCell * cell = (GMPDeviceCell*) [self.table cellForRowAtIndexPath:connectingRow];
    [cell.activityIndicator stopAnimating];
    
    service.shouldUseCRC = YES;
    service.shouldUseTurnBasedCommunication = YES;
    
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

    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        self.table.contentInset = UIEdgeInsetsMake(GMPRefreshHeaderHeight, 0, 0, 0);
        
        [self. activityIndicator startAnimating];
        self.refreshingLabel.hidden = NO;
        
        self.refreshingLabel.text = [NSString stringWithFormat:@"Refreshing... %ds left",GMPDiscoveryTime];
        
    }];
    
    secondsRemaining = GMPDiscoveryTime;
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
    
    if (!shouldRefreshOnRelease && !isRefreshing && scrollView.contentOffset.y <= -GMPRefreshHeaderHeight) {
        self.refreshingLabel.text = [NSString stringWithFormat:@"Release to refresh"];
        shouldRefreshOnRelease = YES;
        self.arrowImageView.image = [UIImage imageNamed:@"arrowUp.png"];
        
        AudioServicesPlaySystemSound(pullDownSound);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!isRefreshing && scrollView.contentOffset.y <= -GMPRefreshHeaderHeight && shouldRefreshOnRelease) {
        
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
