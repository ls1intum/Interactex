/*
 BLEFMainViewController.m
 Interactex Designer
 
 Created by Juan Haladjian on 06/08/2013.
 
 Interactex Designer is a configuration tool to easily setup, simulate and connect e-Textile hardware with smartphone functionality. Interactex Client is an app to store and replay projects made with Interactex Designer.
 
 www.interactex.org
 
 Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
 
 Contacts:
 juan.haladjian@cs.tum.edu
 katharina.bredies@udk-berlin.de
 opensource@telekom.de
 
 
 The first version of the software was designed and implemented as part of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was founded by Telekom Innovation Laboratories Berlin. It has been extended with funding from EIT ICT, as part of the activity "Connected Textiles".
 
 Interactex is built using the Tango framework developed by TU Munich.
 
 In the Interactex software, we use the GHUnit (a test framework for iOS developed by Gabriel Handford) and cocos2D libraries (a framework for building 2D games and graphical applications developed by Zynga Inc.).
 www.cocos2d-iphone.org
 github.com/gabriel/gh-unit
 
 Interactex also implements the Firmata protocol. Its software serial library is based on the original Arduino Firmata library.
 www.firmata.org
 
 All hardware part graphics in Interactex Designer are reproduced with kind permission from Fritzing. Fritzing is an open-source hardware initiative to support designers, artists, researchers and hobbyists to work creatively with interactive electronics.
 www.frizting.org
 
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

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
    
    //self.firmataController = [[IFFirmataController alloc] init];
    [[BLEDiscovery sharedInstance] startScanningForSupportedUUIDs];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) sendTestData{
    
    uint8_t buf[16];
    for (int i = 0; i < 16; i++) {
        buf[i] = (uint8_t)i+65;
        
    }
    BLEService * service = [BLEDiscovery sharedInstance].connectedService;
    if(!service){
        NSLog(@"no service!");
    }
    //[service sendData:buf count:16];
    [service writeToTx:[NSData dataWithBytes:buf length:16]];
}

-(void) sendFirmwareRequest{
    //[self.firmataController sendFirmwareRequest];
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
    [self updateConnectedLabel];
}

-(void) bleServiceDidDisconnect:(BLEService *)service{
    [self updateConnectedLabel];
}

-(void) bleServiceIsReady:(BLEService *)service{
    
    //[service clearRx];
}

-(void) bleServiceDidReset {
}

-(void) reportMessage:(NSString*) message{
}


@end
