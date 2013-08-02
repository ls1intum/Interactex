//
//  IFI2CPinViewController.h
//  iFirmata
//
//  Created by Juan Haladjian on 7/31/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IFI2CRegisterViewController.h"

@class IFI2CComponent;
@class IFI2CComponentViewController;

@protocol IFI2CComponentDelegate <NSObject>

-(void) i2cComponentRemoved:(IFI2CComponent*) component;
-(void) i2cComponent:(IFI2CComponent*) component wroteData:(NSString*) data toRegister:(IFI2CRegister*) reg;
-(void) i2cComponent:(IFI2CComponent*) component startedNotifyingRegister:(IFI2CRegister*) reg;
-(void) i2cComponent:(IFI2CComponent*) component stoppedNotifyingRegister:(IFI2CRegister*) reg;
@end

@interface IFI2CComponentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, IFI2CRegisterDelegate>
{
    UITapGestureRecognizer * gestureRecognizer;
    
    UIColor * defaultButtonColor;
}

@property (nonatomic, weak) IFI2CComponent * component;
@property (nonatomic, weak) id<IFI2CComponentDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITableView *table;

- (IBAction)removeTapped:(id)sender;
- (IBAction)addRegisterTapped:(id)sender;

@end
