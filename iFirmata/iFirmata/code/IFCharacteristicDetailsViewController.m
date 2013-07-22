//
//  IFCharacteristicDetailsViewController.m
//  iFirmata
//
//  Created by Juan Haladjian on 6/30/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "IFCharacteristicDetailsViewController.h"
#import "BLEService.h"
#import <QuartzCore/QuartzCore.h>
#import "BLEHelper.h"

@implementation IFCharacteristicDetailsViewController

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
    
    self.label.layer.borderWidth = 1.0f;
    self.label.layer.cornerRadius = 5.0f;
    
    [self readCharacteristicAndUpdateLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    
    //NSLog(@"notified: %d comp: %d",self.currentCharacteristic.properties,self.currentCharacteristic.properties & CBCharacteristicPropertyNotify);
    
    if(self.currentCharacteristic.properties & CBCharacteristicPropertyNotify){
        self.notifyLabel.hidden = NO;
        self.notifySwitch.hidden = NO;
    } else {
        self.notifyLabel.hidden = YES;
        self.notifySwitch.hidden = YES;
    }
    
    if(self.currentCharacteristic.properties & CBCharacteristicPropertyWrite){
        self.writeText.hidden = NO;
        self.writeButton.hidden = NO;
    } else {
        self.writeText.hidden = YES;
        self.writeButton.hidden = YES;
    }
}


-(void) readCharacteristicAndUpdateLabel{

    NSString * rxValue = self.bleService.rx;
    NSInteger count =  self.bleService.rxCount;
    
    NSLog(@"%d - %@",count,rxValue);
    
    self.label.text = rxValue;
    
    [self.bleService clearRx];
}

- (IBAction)readPushed:(id)sender {
    [self readCharacteristicAndUpdateLabel];
}

- (IBAction)notifySwitchChanged:(id)sender {
    bool b = self.notifySwitch.on;
    CBPeripheral * peripheral = self.currentCharacteristic.service.peripheral;
    [peripheral setNotifyValue:b forCharacteristic:self.currentCharacteristic];
}

- (IBAction)writePushed:(id)sender {
    
    CBPeripheral * peripheral = self.currentCharacteristic.service.peripheral;
    NSString * text = self.writeText.text;
    
    NSData * bytes = [BLEHelper hexToBytes:text];    
    
    //NSData * data = [NSData dataWithBytes:buf length:text.length];
    [peripheral writeValue:bytes forCharacteristic:self.currentCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (IBAction)textChanged:(id)sender {
    if(self.writeText.text.length > 0){
        self.writeButton.enabled = YES;
    } else {
        self.writeButton.enabled = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.writeText resignFirstResponder];
    return YES;
}

@end
