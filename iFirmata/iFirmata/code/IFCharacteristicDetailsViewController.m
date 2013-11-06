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
    
    [self updateLabel];
    
    /*
    CGSize scrollContentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height + kKeyboardOffset);
    ((UIScrollView*) self.view).contentSize = scrollContentSize;*/
    
    CGRect frame = self.writeText.frame;
    frame.size.height = 40;
    self.writeText.frame = frame;
    self.writeText.borderStyle = UITextBorderStyleRoundedRect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateCharacteristicUUID{
    
    self.uuidLabel.text = [BLEHelper UUIDToString:self.currentCharacteristic.UUID];
}

-(void) updateCharacteristicNotify{
    if(self.currentCharacteristic.properties & CBCharacteristicPropertyNotify){
        self.notifyControl.selectedSegmentIndex = self.currentCharacteristic.isNotifying;
        self.notifyControl.hidden = NO;
    } else {
        self.notifyControl.hidden = YES;
    }
}

-(void) updateCharacteristicWrite{
    if(self.currentCharacteristic.properties & CBCharacteristicPropertyWrite){
        self.writeText.hidden = NO;
        self.writeButton.hidden = NO;
    } else {
        self.writeText.hidden = YES;
        self.writeButton.hidden = YES;
    }
}

-(void) viewWillAppear:(BOOL)animated{
    
    self.bleService.dataDelegate = self;
    
    [self updateCharacteristicUUID];
    [self updateCharacteristicNotify];
    [self updateCharacteristicWrite];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void) viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

-(void) updateLabel{

    NSString * string = [BLEHelper DataToString:self.currentCharacteristic.value];
    
    self.label.text = string;
}

- (IBAction)readPushed:(id)sender {
    [self.bleService updateCharacteristic:self.currentCharacteristic];

    //[self updateLabel];
}

- (IBAction)writePushed:(id)sender {

    NSData * data = [BLEHelper StringToData:self.writeText.text];
    
    [self.bleService.peripheral writeValue:data forCharacteristic:self.bleService.txCharacteristic type:CBCharacteristicWriteWithResponse];
}

-(void)keyboardWillShow:(NSNotification*) notification {
    
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    keyboardHeight = keyboardFrameBeginRect.size.height;
    
    if (self.view.frame.origin.y >= 0)     {
        [self moveView:YES];
    } else if (self.view.frame.origin.y < 0) {
       // [self moveView:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0) {
        [self moveView:YES];
    } else if (self.view.frame.origin.y < 0) {
        [self moveView:NO];
    }
}

- (IBAction)textChanged:(id)sender {
    if(self.writeText.text.length > 0){
        self.writeButton.enabled = YES;
    } else {
        self.writeButton.enabled = NO;
    }
}

- (IBAction)notifyChanged:(id)sender {
    
    bool b = (self.notifyControl.selectedSegmentIndex == 1);
    CBPeripheral * peripheral = self.currentCharacteristic.service.peripheral;
    [peripheral setNotifyValue:b forCharacteristic:self.currentCharacteristic];
}

-(void)moveView:(BOOL)moveUp {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = self.view.frame;
    if (moveUp) {
        rect.origin.y -= keyboardHeight;
        rect.size.height += keyboardHeight;
        
    }
    else {
        
        rect.origin.y += keyboardHeight;
        rect.size.height -= keyboardHeight;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.writeText resignFirstResponder];
    return YES;
}

#pragma mark - BleDataDelegate

-(void) updatedValueForCharacteristic:(CBCharacteristic *)characteristic{
    if(self.currentCharacteristic == characteristic){
        [self updateLabel];
    }
}

-(void) didReceiveData:(uint8_t *)buffer lenght:(NSInteger)originalLength{
    if(self.currentCharacteristic == self.bleService.rxCharacteristic){
        [self updateLabel];
    }
}

@end
