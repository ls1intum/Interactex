//
//  IFI2CViewController.m
//  iFirmata
//
//  Created by Juan Haladjian on 15/07/14.
//  Copyright (c) 2014 TUM. All rights reserved.
//

#import "IFI2CLSM303ViewController.h"
#import "IFI2CRegister.h"
#import "IFI2CComponent.h"
#import "IFI2CComponentProxy.h"
#import "IFFirmata.h"

@implementation IFI2CLSM303ViewController

NSInteger const address = 24;


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
    
    if(self.stopButton.enabled){
        
        [self stopReadingAccelerometer];
    }
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
    
    if(reg.value.length <= 0){
        return;
    }
    
    uint8_t* bytes = (uint8_t*)reg.value.bytes;
    
    int x = bytes[1] << 8 | bytes[0];
    int y = bytes[3] << 8 | bytes[2];
    int z = bytes[5] << 8 | bytes[4];
    
    self.valueLabel.text = [NSString stringWithFormat:@"%d %d %d",x,y,z];
}

-(void) updateStartButtons:(BOOL) started{

    self.startButton.enabled = !started;
    self.stopButton.enabled = started;
}

#pragma mark - UI

- (IBAction)startTapped:(id)sender {
    
    uint8_t firstVal = 0;
    
    uint8_t buf[2];
    [BLEHelper valueAsTwo7bitBytes:39 buffer:buf];
    
    [self.firmata sendI2CWriteToAddress:address reg:35 bytes:&firstVal numBytes:1];
    [self.firmata sendI2CWriteToAddress:address reg:32 bytes:buf numBytes:2];
    [self.firmata sendI2CStartReadingAddress:address reg:40 size:6];
    
    [self updateStartButtons:YES];
}

-(void) stopReadingAccelerometer{
    
    [self.firmata sendI2CStopReadingAddress:address];
    [self updateStartButtons:NO];
}

- (IBAction)stopTapped:(id)sender {
    [self stopReadingAccelerometer];
}

#pragma mark - Observing Value

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"value"]){
        [self updateValueLabel];
    }
}

@end
