//
//  IFI2CRegisterViewController.h
//  iFirmata
//
//  Created by Juan Haladjian on 8/1/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IFI2CRegister;
@class IFI2CRegisterViewController;

@protocol IFI2CRegisterDelegate <NSObject>

-(void) i2cRegister:(IFI2CRegister*) reg changedNumber:(NSInteger) newNumber;
-(void) i2cRegister:(IFI2CRegister*) reg wroteData:(NSString*) data;
-(void) i2cRegisterRemoved:(IFI2CRegister*) reg;
@end

@interface IFI2CRegisterViewController : UIViewController <UIActionSheetDelegate>
{
    UIColor * defaultButtonColor;
}

@property (weak, nonatomic) IFI2CRegister * reg;
@property (weak, nonatomic) id<IFI2CRegisterDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *readView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UITextField *registerTextField;
@property (weak, nonatomic) IBOutlet UITextField *sendTextField;
@property (weak, nonatomic) IBOutlet UITextField *sizeTextField;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

- (IBAction)startTapped:(id)sender;
- (IBAction)sendTapped:(id)sender;
- (IBAction)removeTapped:(id)sender;

@end
