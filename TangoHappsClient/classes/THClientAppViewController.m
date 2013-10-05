/*
THClientAppViewController.m
Interactex Designer

Created by Juan Haladjian on 10/07/2013.

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

        if(!scene.isFakeScene){

            float relx = (object.position.x - iPhone.position.x + size.width/2) / kiPhoneFrames[type].size.width;
            float rely = (object.position.y - iPhone.position.y - navigationBarOffset + size.height/2) / kiPhoneFrames[type].size.height;
            
            CGPoint translatedPos = CGPointMake(relx * screenWidth ,rely * viewHeight);
            
            object.position = translatedPos;
        }
        
        [object addToView:self.view];
    }
    
    [project startSimulating];
}

-(void) stopActivityIndicator {
    
    self.view.userInteractionEnabled = YES;
    self.view.alpha = 1.0f;
    if(_activityIndicator != nil){
        [_activityIndicator removeFromSuperview];
        _activityIndicator = nil;
    }
}

-(void) startActivityIndicator {
    
    self.view.userInteractionEnabled = NO;
    
    self.view.alpha = 0.5f;
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    _activityIndicator.center = self.view.center;
    [_activityIndicator startAnimating];
    
    [self.view addSubview:_activityIndicator];
}

-(void) viewWillAppear:(BOOL)animated{
    
    if([THSimulableWorldController sharedInstance].currentProject != nil){
        
        [[BLEDiscovery sharedInstance] startScanningForUUIDString:kBleServiceUUIDString];
        
        [self loadUIObjects];
        [self addPinObservers];
        [self updateModeButton];
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    
    UIImage * image = [THUtils screenshot];
    
    [self removePinObservers];
    [self disconnectFromBle];
    
    THClientScene * scene = [THSimulableWorldController sharedInstance].currentScene;
    if(!scene.image){
        [scene saveImage:image];
    }
}

-(void) viewDidDisappear:(BOOL)animated{
    
    [THSimulableWorldController sharedInstance].currentScene = nil;
    [THSimulableWorldController sharedInstance].currentProject = nil;
}

- (void)viewDidUnload {
    [self setModeButton:nil];
    [super viewDidUnload];
}

-(void) updateModeButton{
    
    if([BLEDiscovery sharedInstance].connectedService){
        
        self.modeButton.title = @"Stop";
        self.modeButton.enabled = YES;
        
    } else {
        
        self.modeButton.title = @"Start";
        if([BLEDiscovery sharedInstance].foundPeripherals.count > 0){
            self.modeButton.enabled = YES;
        } else {
            
            self.modeButton.enabled = NO;
        }
    }
}

#pragma mark Ble Interaction

-(void) connectToBle{
    
    if(![BLEDiscovery sharedInstance].currentPeripheral && [BLEDiscovery sharedInstance].foundPeripherals.count> 0){
        CBPeripheral * peripheral = [[BLEDiscovery sharedInstance].foundPeripherals objectAtIndex:0];
        [[BLEDiscovery sharedInstance] connectPeripheral:peripheral];
    }
}

-(void) disconnectFromBle{
    if([BLEDiscovery sharedInstance].currentPeripheral){
        [[BLEDiscovery sharedInstance] disconnectCurrentPeripheral];
    }
}

#pragma mark Pins Observing

-(void) addPinObservers{
    
    THClientProject * project = [THSimulableWorldController sharedInstance].currentProject;
    
    for (THBoardPin * pin in project.lilypad.pins) {
        [pin.pin addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
    }
}

-(void) removePinObservers{
    THClientProject * project = [THSimulableWorldController sharedInstance].currentProject;
    
    for (THBoardPin * pin in project.lilypad.pins) {
        [pin.pin removeObserver:self forKeyPath:@"value"];
    }
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"value"]){
        
        IFPin * pin = object;
        
        if(pin.mode == kPinModeDigitalOutput){
            
            [self sendDigitalOutputForPin:pin];
            
        } else if(pin.mode == kPinModePWM){
            
            [self sendPWMOutputForPin:pin];
        }
    }
}

#pragma mark Firmata Interaction

-(void) sendDigitalOutputForPin:(IFPin*) pin{
    [self.firmataController sendDigitalOutputForPort:pin.number value:pin.value];
}

-(void) sendPWMOutputForPin:(IFPin*) pin{
    [self.firmataController sendAnalogOutputForPin:pin.number value:pin.value];
}

-(void) sendServoOutputForPin:(IFPin*) pin{
    [self.firmataController sendAnalogOutputForPin:pin.number value:pin.value];
}

-(void) sendPinModes{
    
    THClientProject * project = [THSimulableWorldController sharedInstance].currentProject;
    
    for (THBoardPin * pin in project.lilypad.pins) {
        
        if((pin.type == kPintypeDigital || pin.type == kPintypeAnalog) && pin.mode != kPinModeUndefined){
            
            [self.firmataController sendPinModeForPin:pin.pin.number mode:pin.mode];
        }
    }
}

-(void) firmataController:(IFFirmataController*) firmataController didReceiveAnalogMappingResponse:(uint8_t*) buffer length:(NSInteger) length {
    
    int pin=0;
    for (int i=2; i<length-1; i++) {
        NSLog(@"%d to channel: %d",pin,buffer[i]);/*
        pinInfo[pin].analogChannel = buffer[i];*/
        pin++;
    }
}

-(void) firmataController:(IFFirmataController*) firmataController didReceiveAnalogMessageOnChannel:(NSInteger) channel value:(NSInteger) value{
    
    THClientProject * project = [THSimulableWorldController sharedInstance].currentProject;
    
    for (THBoardPin * pin in project.lilypad.analogPins) {
        if (pin.pin.analogChannel == channel) {
            pin.value = value;
            return;
        }
    }
}

-(void) firmataController:(IFFirmataController*) firmataController didReceiveDigitalMessageForPort:(NSInteger) port value:(NSInteger) value{
    
    
    THClientProject * project = [THSimulableWorldController sharedInstance].currentProject;
    NSInteger pinNumber = port * 8;
    
    for (int mask = 1; mask & 0xFF; mask <<= 1, pinNumber++) {
        THBoardPin * pin = [project.lilypad digitalPinWithNumber:pinNumber];
        
        if (pin && pin.mode == IFPinModeInput) {
            uint32_t val = (value & mask) ? 1 : 0;
            if (pin.value != val) {
                pin.value = val;
            }
        }
    }
}

-(void) firmataController:(IFFirmataController*) firmataController didReceiveI2CReply:(uint8_t*) buffer length:(NSInteger)length {
    /*
    uint8_t address = buffer[2] + (buffer[3] << 7);
    NSInteger registerNumber = buffer[4];
    
    //NSLog(@"addr: %d reg %d ",address,registerNumber);
    if(!self.firmataController.startedI2C){
        
        NSLog(@"reporting but i2c did not start");
        [self.firmataController sendI2CStopReadingAddress:address];
        
    } else {
        THClientProject * project = [THSimulableWorldController sharedInstance].currentProject;
        IFI2CComponent * component = [project.lilypad i2cComponentWithAddress:address];
        
        IFI2CRegister * reg = [component registerWithNumber:registerNumber];
        if(reg){
            uint8_t values[reg.size];
            NSInteger parseBufCount = 6;
            for (int i = 0; i < reg.size; i++) {
                uint8_t value = buffer[parseBufCount++] + (buffer[parseBufCount++] << 7);
                values[i] = value;
            }
            NSData * data = [NSData dataWithBytes:values length:reg.size];
            reg.value = data;
        }

    }
     */
}


#pragma mark LeDiscoveryDelegate

- (void) discoveryDidRefresh {
    //[self updateModeButton];
    
    /*
     self.bleService.delegate = self;
     
     [self.currentlyConnectedLabel setText:[peripheral name]];
     [self.currentlyConnectedLabel setEnabled:YES];*/
}

- (void) peripheralDiscovered:(CBPeripheral*) peripheral {
    
    [self updateModeButton];
    
    //[[LeDiscovery sharedInstance] connectPeripheral:peripheral];
}

- (void) discoveryStatePoweredOff {
    [self updateModeButton];
    
    NSLog(@"Powered Off");
}


#pragma mark BleServiceProtocol

-(void) bleServiceDidConnect:(BLEService*) service{
    service.delegate = self;
    [self updateModeButton];
}

-(void) bleServiceDidDisconnect:(BLEService*) service{
    
    service.delegate = nil;
    service.dataDelegate = nil;
    if(self.firmataController.bleService == service){
        self.firmataController.bleService = nil;
    }
    [self updateModeButton];
}

-(void) bleServiceIsReady:(BLEService*) service{
    
    [self stopActivityIndicator];
        
    //[service clearRx];
    
    self.firmataController.bleService = service;
    service.dataDelegate = self.firmataController;
    
    [self stopActivityIndicator];
    [self sendPinModes];
}

- (void) bleServiceDidReset {
    //_bleService = nil;
}


-(IBAction)modeButtonTapped:(id)sender {
    if([BLEDiscovery sharedInstance].connectedService){
        [self stopActivityIndicator];
        [self disconnectFromBle];
    } else {
        [self startActivityIndicator];
        [self connectToBle];
    }
}


/*
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
            
            THElementPin * epin = [lilypadPin.attachedElementPins objectAtIndex:0];
            THCompass * compass = (THCompass*) epin.hardware;
            
            [self fillAccelerometerValues:&(data[1]) to:compass];
            compass.heading = [self angleFromMagnetometer:&(data[7])];

        } else if(lilypadPin.mode == kPinModeAnalogInput){
            
            short x1 = data[i++];
            short x2 = data[i++];
            int value = ((x1 << 8) | x2) - kAnalogInMin;
            lilypadPin.value = value;
            [lilypadPin notifyNewValue];
            
            //NSLog(@"received: %d",value);
            
        } else {
            lilypadPin.value = data[i++];
            [lilypadPin notifyNewValue];
        }
    }
}*/

@end
