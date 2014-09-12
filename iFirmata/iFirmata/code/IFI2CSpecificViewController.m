//
//  IFI2CViewController.m
//  iFirmata
//
//  Created by Juan Haladjian on 15/07/14.
//  Copyright (c) 2014 TUM. All rights reserved.
//

#import "IFI2CSpecificViewController.h"
#import "IFI2CRegister.h"
#import "IFI2CComponent.h"
#import "IFI2CComponentProxy.h"
#import "IFFirmata.h"

@implementation IFI2CSpecificViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    
    self.navigationItem.title = self.component.name;
    self.imageView.image = self.component.image;
    
    [self.component.component.continousReadingRegister addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
}

-(void) viewWillDisappear:(BOOL)animated{
    
    [self.component.component.continousReadingRegister removeObserver:self forKeyPath:@"value"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateStartButtons:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateValueLabel{
    IFI2CRegister * reg = self.component.component.continousReadingRegister;
    
    NSLog(@"%d",(int)reg.value.length);
    
    if(reg.value.length <= 0){
        return;
    }
    
    uint8_t* bytes = (uint8_t*)reg.value.bytes;
    
    int x = bytes[0] | (bytes[1] << 7);
    int y = bytes[2] | (bytes[3] << 7);
    int z = bytes[4] | (bytes[5] << 7);
    
    self.valueLabel.text = [NSString stringWithFormat:@"%d %d %d",x,y,z];
}

-(void) updateStartButtons:(BOOL) started{

    self.startButton.enabled = !started;
    self.stopButton.enabled = started;
}

#pragma mark - UI

- (IBAction)startTapped:(id)sender {
    
    uint8_t buf[2];
    [BLEHelper valueAsTwo7bitBytes:39 buffer:buf];
    
    [self.firmata sendI2CWriteToAddress:24 reg:32 bytes:buf numBytes:2];
    [self.firmata sendI2CStartReadingAddress:24 reg:40 size:6];
    
    [self updateStartButtons:YES];
}

- (IBAction)stopTapped:(id)sender {
    
    [self.firmata sendI2CStopReadingAddress:24];
    [self updateStartButtons:NO];
}

#pragma mark - Observing Value

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"value"]){
        [self updateValueLabel];
    }
}

@end
