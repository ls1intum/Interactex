//
//  IFI2CRegisterViewController.m
//  iFirmata
//
//  Created by Juan Haladjian on 8/1/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "IFI2CRegisterViewController.h"
#import "IFI2CRegister.h"

@implementation IFI2CRegisterViewController

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
          
    CGRect frame = self.registerTextField.frame;
    frame.size.height = IFTextFieldHeight;
    self.registerTextField.frame = frame;
    
    frame = self.sendTextField.frame;
    frame.size.height = IFTextFieldHeight;
    self.sendTextField.frame = frame;
    
    frame = self.sizeTextField.frame;
    frame.size.height = IFTextFieldHeight;
    self.sizeTextField.frame = frame;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(closeNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.registerTextField.inputAccessoryView = numberToolbar;
    self.sendTextField.inputAccessoryView = numberToolbar;
    self.sizeTextField.inputAccessoryView = numberToolbar;
    
    self.valueLabel.layer.cornerRadius = 5.0f;
    self.valueLabel.layer.borderWidth = 1.0f;
    
    self.readView.layer.cornerRadius = 5.0f;
    self.readView.layer.borderWidth = 1.0f;
    
}

-(NSString*) titleString{
    return [NSString stringWithFormat:@"Register: #%d",self.reg.number];
}

-(void) updateTitle{
    self.navigationItem.title = [self titleString];
    //self.navigationController.navigationBar.topItem.title = [self titleString];
}

-(void) updateRegisterText{
    
    self.registerTextField.text = [NSString stringWithFormat:@"%d",self.reg.number];
}

-(void) updateSizeText{
    
    //self.sizeTextField.text = [NSString stringWithFormat:@"%d",self.reg.size];
}

-(void) updateValueLabel{

    self.valueLabel.text = [IFHelper valueAsBracketedStringForI2CRegister:self.reg];
}

- (IBAction)startSwitchChanged:(id)sender {
    [self.reg removeObserver:self forKeyPath:@"notifies"];
    self.reg.notifies = self.startSwitch.on;
    [self.reg addObserver:self forKeyPath:@"notifies" options:NSKeyValueObservingOptionNew context:nil];
    
    [self updateValueLabel];
}

- (IBAction)sendTapped:(id)sender {
    [self.delegate i2cRegister:self.reg wroteData:self.sendTextField.text];
}

-(void) viewWillAppear:(BOOL)animated{
    
    [self.reg addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
    [self.reg addObserver:self forKeyPath:@"notifies" options:NSKeyValueObservingOptionNew context:nil];
    [self reloadUI];
}

-(void) viewWillDisappear:(BOOL)animated{
    
    [self.reg removeObserver:self forKeyPath:@"value"];
    [self.reg removeObserver:self forKeyPath:@"notifies"];
}

-(void) reloadUI{
    [self updateTitle];
    [self updateRegisterText];
    [self updateSizeText];
    [self updateValueLabel];
}

-(void) setRegister:(IFI2CRegister *)reg{
    if(_reg != reg){
        _reg = reg;
        [self reloadUI];
    }
}

-(NSString*) title{
    if(self.reg){
        return [self titleString];
    } else return @"I2C Register";
}

-(void) checkUpdateNumber{
    NSInteger regNumber = [self.registerTextField.text integerValue];
    if(self.reg.number != regNumber){
        self.reg.number = regNumber;
        [self.delegate i2cRegister:self.reg changedNumber:regNumber];
        [self updateTitle];
    }
    [self updateRegisterText];

}

-(void) closeNumberPad{
    [self.registerTextField resignFirstResponder];
    [self.sendTextField resignFirstResponder];
    [self.sizeTextField resignFirstResponder];
    
    [self checkUpdateNumber];
    
    self.reg.size = [self.sizeTextField.text integerValue];
    
    [self updateSizeText];
}

#pragma mark - Observing Value

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"value"]){
        [self updateValueLabel];
    } else if([keyPath isEqualToString:@"notifies"]){
        [self updateValueLabel];
    }
}

@end
