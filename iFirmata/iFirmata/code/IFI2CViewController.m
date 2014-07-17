//
//  IFI2CViewController.m
//  iFirmata
//
//  Created by Juan Haladjian on 15/07/14.
//  Copyright (c) 2014 TUM. All rights reserved.
//

#import "IFI2CViewController.h"
#import "IFI2CRegister.h"
#import "IFI2CComponent.h"
#import "IFI2CComponentProxy.h"

@implementation IFI2CViewController

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
    
    [self.component.component.mainRegister addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
}

-(void) viewWillDisappear:(BOOL)animated{
    
    [self.component.component.mainRegister removeObserver:self forKeyPath:@"value"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateValueLabel{
    IFI2CRegister * reg = self.component.component.mainRegister;
    
    NSLog(@"%d",reg.value.length);
    
    if(!reg.notifies || reg.value.length <= 0){
        return;
    }
    
    uint8_t* bytes = (uint8_t*)reg.value.bytes;
    
    int x = bytes[0] | (bytes[1] << 7);
    int y = bytes[2] | (bytes[3] << 7);
    int z = bytes[4] | (bytes[5] << 7);
    
    self.valueLabel.text = [NSString stringWithFormat:@"%d %d %d",x,y,z];
}

-(void) startChanged:(BOOL) start{

    //[self.component.mainRegister removeObserver:self forKeyPath:@"notifies"];
    self.component.component.mainRegister.notifies = start;
    //[self.component.mainRegister addObserver:self forKeyPath:@"notifies" options:NSKeyValueObservingOptionNew context:nil];
    
    //[self.delegate I2CDeviceStarted:self.component];
}

#pragma mark - UI

- (IBAction)startTapped:(id)sender {
    
    NSString * data = @"39";
    [self.delegate I2CDevice:self.component.component wroteData:data];
    
    [self startChanged:YES];
}

- (IBAction)stopTapped:(id)sender {
    [self startChanged:NO];
}


#pragma mark - Observing Value

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"value"]){
        [self updateValueLabel];
    }
}

@end
