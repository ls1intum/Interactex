//
//  THFirstViewController.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/24/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THClientAppViewController.h"
#import "THSimulableWorldController.h"
#import "THClientProject.h"

#import "THView.h"
#import "THiPhone.h"
#import "THClientScene.h"

#import "THLilyPad.h"
#import "THBoardPin.h"
#import "THTransferAgent.h"
#import "THPinValue.h"
#import "THElementPin.h"
#import "THCompass.h"

#import "THLabel.h"

@implementation THClientAppViewController
/*
-(void) pushLilypadStateToAllVirtualClients{
    THClientProject * project = [THSimulableWorldController sharedInstance].currentProject;
    NSArray * lilypins = project.lilypad.pins;
    NSMutableArray * pins = [NSMutableArray array];
    
    for (THBoardPin * pin in lilypins) {
        if(pin.mode == kPinModeDigitalOutput && pin.hasChanged){
            THPinValue * pinValue = [[THPinValue alloc] init];
            pinValue.type = pin.type;
            pinValue.value = pin.currentValue;
            pinValue.number = pin.number;
            
            //dont send if value is reserved for protocol (change protocol in future)
            [pins addObject:pinValue];
            pin.hasChanged = NO;
            
            NSLog(@"iPad sending %d %d",pin.number,pin.currentValue);
        }
    }
    
    [_transferAgent queueAction:kTransferActionPinState withObject:pins];
}*/

/*
-(void) pushLilypadStateToRealClient{
    THClientProject * project = [THSimulableWorldController sharedInstance].currentProject;
    NSArray * lilypins = project.lilypad.pins;
    
    for (THBoardPin * pin in lilypins) {
        if((pin.mode == kPinModeDigitalOutput || pin.mode == kPinModePWM || pin.mode == kPinModeBuzzer) && pin.hasChanged){
            NSLog(@"ble sending %d %d",pin.number,pin.currentValue);
            
            //if(pin.currentValue != kMsgPinValueStarted && pin.currentValue != kMsgPinModeStarted){
                [_bleService outputPin:pin.number value:pin.currentValue];
            //}
            pin.hasChanged = NO;
        }
    }
}
*/

-(void) startVirtualStateTransfer{
    //_virtualTransferTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/30.0f target:self selector:@selector(pushLilypadStateToAllVirtualClients) userInfo:nil repeats:YES];
}

-(void) startRealStateTransfer{
    
    _realTransferTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/30.0f target:self selector:@selector(pushLilypadStateToRealClient) userInfo:nil repeats:YES];
}
/*
-(void) stopVirtualStateTransfer{
    if(_virtualTransferTimer){
        [_virtualTransferTimer invalidate];
        _virtualTransferTimer = nil;
    }
}*/

-(void) stopRealStateTransfer{
    if(_realTransferTimer){
        [_realTransferTimer invalidate];
        _realTransferTimer = nil;
    }
}

-(NSString*) title{
    THClientProject * project = [THSimulableWorldController sharedInstance].currentProject;
    return project.name;
}

-(void) loadUIObjects{
        
    THClientProject * project = [THSimulableWorldController sharedInstance].currentProject;
    THClientScene * scene = [THSimulableWorldController sharedInstance].currentScene;
    
    THiPhone * iPhone = project.iPhone;
    
    CGSize size = iPhone.currentView.view.frame.size;
    
    self.view = iPhone.currentView.view;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    THIPhoneType type = screenHeight < 500;
    CGFloat viewHeight = self.view.bounds.size.height;
    CGFloat navigationBarOffset = screenHeight - viewHeight;
    
    for (THView * object in project.iPhoneObjects) {
        
        //NSLog(@"pos: %f %f",object.position.x,object.position.y);
        
        if(!scene.isFakeScene){
            
           // NSLog(@"object: %f, iPhone: %f viewSize: %f screenWidth: %f",object.position.x,iPhone.position.x, size.width/2, screenWidth);
            
            NSLog(@"object: %f, iPhone: %f viewSize: %f screenHeight: %f viewHeight: %f",object.position.y,iPhone.position.y, size.height/2, screenHeight,viewHeight);
            
            float relx = (object.position.x - iPhone.position.x + size.width/2) / kiPhoneFrames[type].size.width;
            float rely = (object.position.y - iPhone.position.y - navigationBarOffset + size.height/2) / kiPhoneFrames[type].size.height;
            
            CGPoint translatedPos = CGPointMake(relx * screenWidth ,rely * viewHeight);
            
            object.position = translatedPos;
            NSLog(@"end pos: %f %f",object.position.x,object.position.y);
        }
        
        [object addToView:self.view];
    }
    
    [project startSimulating];
}

-(void) sendPinModes{
    /*
    THClientProject * project = [THSimulableWorldController sharedInstance].currentProject;
    
    NSMutableArray * array = [NSMutableArray array];
    
    NSInteger i = 0;
    for (THBoardPin * pin in project.lilypad.pins) {
        if((pin.type == kPintypeDigital || pin.type == kPintypeAnalog) && pin.mode != kPinModeUndefined){
            THPinModeDescriptor * pinDescriptor = [[THPinModeDescriptor alloc] init];
            
            NSInteger pinidx = [project.lilypad realIdxForPin:pin];
            
            pinDescriptor.pin = pinidx;
            pinDescriptor.mode = pin.mode;
            
            [array addObject:pinDescriptor];
        }
        i++;
    }

    [self.bleService sendPinModes:array];*/
}

#pragma mark LeDiscoveryDelegate

- (void) discoveryDidRefresh {
    /*
     self.bleService.delegate = self;
     
     [self.currentlyConnectedLabel setText:[peripheral name]];
     [self.currentlyConnectedLabel setEnabled:YES];*/
}
/*
- (void) peripheralDiscovered:(CBPeripheral*) peripheral {
    [[LeDiscovery sharedInstance] connectPeripheral:peripheral];
}*/

- (void) discoveryStatePoweredOff {
    NSLog(@"Powered Off");
}
/*
#pragma mark BleServiceProtocol


-(void) bleServiceDidConnect:(BleService *)service{
    _bleService = service;
    _bleService.delegate = self;
}

-(void) bleServiceDidDisconnect:(BleService *)service{
    if(service == _bleService){
        _bleService.delegate = nil;
        _bleService = nil;
        [self startVirtualMode];
    }
}

-(void) bleServiceIsReady:(BleService *)service{
    
    [service clearRx];
    [self sendPinModes];
    [self startRealStateTransfer];
    [self stopActivityIndicator];
}

- (void) bleServiceDidReset {
    _bleService = nil;
}
*/

-(void) stopActivityIndicator {
    
    _state = kClientStateNormal;
    self.view.userInteractionEnabled = YES;
    self.view.alpha = 1.0f;
    if(_activityIndicator != nil){
        [_activityIndicator removeFromSuperview];
        _activityIndicator = nil;
    }
}

-(void) startActivityIndicator {
    
    self.view.userInteractionEnabled = NO;
    
    _state = kClientStateWaiting;
    
    self.view.alpha = 0.5f;
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    _activityIndicator.center = self.view.center;
    //_activityIndicator.center = CGPointMake(200, 200);
    [_activityIndicator startAnimating];
    
    [self.view addSubview:_activityIndicator];
}

-(void) viewWillAppear:(BOOL)animated{
    if([THSimulableWorldController sharedInstance].currentProject != nil){
        [self loadUIObjects];
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    UIImage * image = [THUtils screenshot];
    
    [self stopRealStateTransfer];
    
    THClientScene * scene = [THSimulableWorldController sharedInstance].currentScene;
    if(!scene.image){
        [scene saveImage:image];
    }
}

-(void) viewDidDisappear:(BOOL)animated{
    
    [THSimulableWorldController sharedInstance].currentScene.project = nil;
    [THSimulableWorldController sharedInstance].currentScene = nil;
    [THSimulableWorldController sharedInstance].currentProject = nil;
}

- (void)viewDidUnload {
    [self setModeButton:nil];
    [super viewDidUnload];
}

-(void) connectToBle{
    
    //[[LeDiscovery sharedInstance] startScanningForUUIDString:kBleServiceUUIDString];
}

-(void) disconnectBle{
   // [_bleService disconnect];
    //[_bleService reset];
}
/*
-(void) startVirtualMode{
    
    [self stopActivityIndicator];
    _mode = kClientModeVirtual;
    self.modeButton.image = [UIImage imageNamed:@"lilypadmode"];
    [self stopRealStateTransfer];
    [self disconnectBle];
}

-(void) startRealMode{
    
    _mode = kClientModeReal;
    self.modeButton.image = [UIImage imageNamed:@"virtualmode"];
    [self stopVirtualStateTransfer];
    [self connectToBle];
    [self startActivityIndicator];
}

-(IBAction)modeButtonTapped:(id)sender {
    if(self.mode == kClientModeVirtual){
        [self startRealMode];
    } else {
        [self startVirtualMode];
    }
}*/

-(IBAction)modeButtonTapped:(id)sender {
    
}

-(float) angleFromMagnetometer:(Byte*) data{
    
    int i = 0;
    short x1 = data[i++];
    short x2 = data[i++];
    
    int heading = ((x1 << 8) | x2);
    
    return heading;
}


-(void) fillAccelerometerValues:(Byte*) data to:(THCompass*) compass{
    int i = 0;
    
    short x1 = data[i++];
    short x2 = data[i++];
    short y1 = data[i++];
    short y2 = data[i++];
    short z1 = data[i++];
    short z2 = data[i++];
    
    int x = ((x1 << 8) | x2) - kCompassMin;
    int y = ((y1 << 8) | y2) - kCompassMin;
    int z = ((z1 << 8) | z2) - kCompassMin;
    
    compass.accelerometerX = x;
    compass.accelerometerY = y;
    compass.accelerometerZ = z;
    
    //NSLog(@"%d %d %d",x,y,z);
}

-(void) dataReceived:(Byte*) data lenght:(NSInteger) length{
    
    THClientProject * project = [THSimulableWorldController sharedInstance].currentProject;
    
    for (int i = 0 ; i < length;) {
        short pin = data[i++];
        
        THBoardPin * lilypadPin = [project.lilypad pinWithRealIdx:pin];
        if(lilypadPin.mode == kPinModeCompass){
            
            THElementPin * epin = [lilypadPin.attachedPins objectAtIndex:0];
            THCompass * compass = (THCompass*) epin.hardware;
            
            [self fillAccelerometerValues:&(data[1]) to:compass];
            compass.heading = [self angleFromMagnetometer:&(data[7])];

        } else if(lilypadPin.mode == kPinModeAnalogInput){
            
            short x1 = data[i++];
            short x2 = data[i++];
            int value = ((x1 << 8) | x2) - kAnalogInMin;
            lilypadPin.currentValue = value;
            [lilypadPin notifyNewValue];
            
            //NSLog(@"received: %d",value);
            
        } else {
            lilypadPin.currentValue = data[i++];
            [lilypadPin notifyNewValue];
        }
    }
}

@end
