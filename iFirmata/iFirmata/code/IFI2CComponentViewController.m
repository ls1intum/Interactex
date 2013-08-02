//
//  IFI2CPinViewController.m
//  iFirmata
//
//  Created by Juan Haladjian on 7/31/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "IFI2CComponentViewController.h"
#import "IFI2CComponent.h"
#import "IFI2CRegister.h"
#import "IFI2CRegisterViewController.h"

@implementation IFI2CComponentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    CGRect frame = self.nameTextField.frame;
    frame.size.height = 40;
    self.nameTextField.frame = frame;
    
    frame = self.addressTextField.frame;
    frame.size.height = 40;
    self.addressTextField.frame = frame;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(closeNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.addressTextField.inputAccessoryView = numberToolbar;
    
    //[self.table reloadData];
}

-(void) reloadUI{
    
    self.nameTextField.text = self.component.name;
    self.addressTextField.text = [NSString stringWithFormat:@"%d",self.component.address];
}

-(void) setComponent:(IFI2CComponent *)component{
    if(_component != component){
        _component = component;
        [self reloadUI];
    }
}

-(void) viewWillAppear:(BOOL)animated{
    [self reloadUI];
    
    if(self.table.indexPathForSelectedRow){
        [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:NO];
    }
}

-(NSString*) title{
    if(self.component){
        return self.component.name;
    } else return @"I2C Component";
}

-(void) tapped:(UITapGestureRecognizer*) recognizer{
    //CGPoint location = [recognizer locationInView:self.view];
    [self resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)removeTapped:(id)sender {
    [self.delegate i2cComponentRemoved:self.component];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addRegisterTapped:(id)sender {
    
    IFI2CRegister * newRegister = [[IFI2CRegister alloc] init];
    newRegister.number = 32;
    newRegister.size = 6;
    
    [self.component addRegister:newRegister];
    /*
    UITableViewCell * cell = [self.table dequeueReusableCellWithIdentifier:@"i2cRegisterCell"];
    cell.textLabel.text =  [NSString stringWithFormat:@"Register #%d", newRegister.number];*/
    
    //[self.table reloadData];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.component.registers.count-1 inSection:0];
    [self.table insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - Done Button on Numeric Keyboards

-(void) closeNumberPad{
    [self.addressTextField resignFirstResponder];
    
    self.component.address = [self.addressTextField.text integerValue];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.nameTextField){
        self.navigationController.navigationBar.topItem.title = self.nameTextField.text;
        self.component.name = self.nameTextField.text;
    }
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Table


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
    return 1;
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0) {
        return @"Digital";
    } else if(section == 1){
        return @"Analog";
    } else {
        return @"I2C";
    }
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.component.registers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger idx = indexPath.row;
    
    UITableViewCell * cell = [self.table dequeueReusableCellWithIdentifier:@"i2cRegisterCell"];
    
    IFI2CRegister * reg = [self.component.registers objectAtIndex:idx];
    cell.textLabel.text =  [NSString stringWithFormat:@"Register #%d", reg.number];
    cell.detailTextLabel.text = @"";
    
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toI2CRegisterSegue"]){
        
        NSIndexPath * indexPath = [self.table indexPathForSelectedRow];
        NSInteger row = indexPath.row;
        IFI2CRegister * reg = [self.component.registers objectAtIndex:row];
        
        IFI2CRegisterViewController * viewController = (IFI2CRegisterViewController*) segue.destinationViewController;
        viewController.reg = reg;
        viewController.delegate = self;
    }
}

#pragma mark - RegisterController delegate

-(void) i2cRegister:(IFI2CRegister *)reg wroteData:(NSString *)data{
    
    [self.delegate i2cComponent:self.component wroteData:data toRegister:reg];
}

-(void) i2cRegisterStartedNotifying:(IFI2CRegister *)reg{
    [self.delegate i2cComponent:self.component startedNotifyingRegister:reg];
}

-(void) i2cRegisterStoppedNotifying:(IFI2CRegister *)reg{
    [self.delegate i2cComponent:self.component stoppedNotifyingRegister:reg];
}


-(void) i2cRegister:(IFI2CRegister*) reg changedNumber:(NSInteger) newNumber{
    NSInteger row = [self.component.registers indexOfObject:reg];
    if(row>= 0 && row < self.component.registers.count){
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
