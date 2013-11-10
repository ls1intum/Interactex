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
#import "IFHelper.h"

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
    
    if(![self.component.name isEqualToString:@"New I2C Component"]){
        self.nameTextField.text = self.component.name;
    }
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
    
    [self addRegisterObservers];
    
    if(self.table.indexPathForSelectedRow){
        [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:NO];
    }
}

-(void) viewDidAppear:(BOOL)animated{
    if(self.removingRegister){
        [self removeRegisterCellAnimated];
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    [self removeRegisterObservers];
}

#pragma mark - Register Observers

-(void) addRegisterObservers{
    for (IFI2CRegister * reg in self.component.registers) {
        [reg addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
        [reg addObserver:self forKeyPath:@"notifies" options:NSKeyValueObservingOptionNew context:nil];
    }
}

-(void) removeRegisterObservers{
    for (IFI2CRegister * reg in self.component.registers) {
        [reg removeObserver:self forKeyPath:@"value"];
        [reg removeObserver:self forKeyPath:@"notifies"];
    }
}

#pragma mark - Register Observers

-(NSString*) title{
    if(self.component){
        return self.component.name;
    } else return @"I2C Component";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addRegisterTapped:(id)sender {
    
    IFI2CRegister * newRegister = [[IFI2CRegister alloc] init];
    newRegister.number = 32;
    newRegister.size = 3;
    
    [self.delegate i2cComponent:self.component addedRegister:newRegister];
    
    //[self.component addRegister:newRegister];
    
    [newRegister addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
    [newRegister addObserver:self forKeyPath:@"notifies" options:NSKeyValueObservingOptionNew context:nil];

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.component.registers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger idx = indexPath.row;
    
    UITableViewCell * cell = [self.table dequeueReusableCellWithIdentifier:@"i2cRegisterCell"];
    
    IFI2CRegister * reg = [self.component.registers objectAtIndex:idx];
    cell.textLabel.text =  [NSString stringWithFormat:@"Register #%d", reg.number];
    cell.detailTextLabel.text = [IFHelper valueAsBracketedStringForI2CRegister:reg];
    
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

-(NSIndexPath*) indexPathForRegister:(IFI2CRegister*) reg{
    NSInteger row = [self.component.registers indexOfObject:reg];
    if(row>= 0 && row < self.component.registers.count){
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        return indexPath;
    }
    return nil;
}

-(void) i2cRegister:(IFI2CRegister *)reg wroteData:(NSString *)data{
    [self.delegate i2cComponent:self.component wroteData:data toRegister:reg];
}

-(void) i2cRegister:(IFI2CRegister*) reg changedNumber:(NSInteger) newNumber{
    NSIndexPath * indexPath = [self indexPathForRegister:reg];
    [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Register Observer

-(void) handleStartedNotifyingRegister:(IFI2CRegister*) reg{
    
}

-(void) handleStoppedNotifyingRegister:(IFI2CRegister*) reg{
    
    NSIndexPath * indexPath = [self indexPathForRegister:reg];
    [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


//called after view did appear when there is a component to remove
-(void) removeRegisterCellAnimated{
        
    [self.table scrollToRowAtIndexPath:self.removingRegisterPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.removingRegisterPath] withRowAnimation:UITableViewRowAnimationFade];
    
    self.removingRegister = nil;
    self.removingRegisterPath = nil;
}

-(void) i2cRegisterRemoved:(IFI2CRegister *)reg{
    
    //[reg removeObserver:self forKeyPath:@"value"];
    
    NSInteger row = [self.component.registers indexOfObject:reg];
    self.removingRegisterPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    //[self.component removeRegister:reg];
    [self.delegate i2cComponent:self.component removedRegister:reg];
    
    self.removingRegister = reg;
}

#pragma mark - Remove ActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self.delegate i2cComponentRemoved:self.component];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)removeTapped:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Remove Component"
                                                    otherButtonTitles:nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [actionSheet showInView:[self view]];
}

#pragma mark - Value Observed

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"value"]){
        NSInteger idx = [self.component.registers indexOfObject:object];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else if([keyPath isEqualToString:@"notifies"]){
        IFI2CRegister * reg = object;
        if(reg.notifies){
            [self handleStartedNotifyingRegister:reg];
        } else {
            [self handleStoppedNotifyingRegister:reg];
        }
    }
    
}

@end
