//
//  IFI2CPinViewController.h
//  iFirmata
//
//  Created by Juan Haladjian on 7/31/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GMPI2CRegisterViewController.h"

@class GMPI2CComponent;
@class GMPI2CRegister;
@class GMPI2CComponentViewController;

@protocol GMPI2CComponentDelegate <NSObject>

-(void) i2cComponentRemoved:(GMPI2CComponent*) component;
-(void) i2cComponent:(GMPI2CComponent*) component wroteData:(NSString*) data toRegister:(GMPI2CRegister*) reg;
-(void) i2cComponent:(GMPI2CComponent*) component startedNotifyingRegister:(GMPI2CRegister*) reg;
-(void) i2cComponent:(GMPI2CComponent*) component stoppedNotifyingRegister:(GMPI2CRegister*) reg;

-(void) i2cComponent:(GMPI2CComponent*) component addedRegister:(GMPI2CRegister*) reg;
-(void) i2cComponent:(GMPI2CComponent*) component removedRegister:(GMPI2CRegister*) reg;
@end

@interface GMPI2CComponentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, GMPI2CRegisterDelegate, UIActionSheetDelegate>
{    
    UIColor * defaultButtonColor;
}

@property (nonatomic, weak) GMPI2CComponent * component;
@property (nonatomic, weak) id<GMPI2CComponentDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) GMPI2CRegister *removingRegister;
@property (strong, nonatomic) NSIndexPath *removingRegisterPath;

- (IBAction)removeTapped:(id)sender;
- (IBAction) addRegisterTapped:(id)sender;

@end
