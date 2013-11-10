//
//  IFI2CRegisterViewController.h
//  iFirmata
//
//  Created by Juan Haladjian on 8/1/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMPI2CRegister;
@class GMPI2CRegisterViewController;

@protocol GMPI2CRegisterDelegate <NSObject>

-(void) i2cRegister:(GMPI2CRegister*) reg changedNumber:(NSInteger) newNumber;
-(void) i2cRegister:(GMPI2CRegister*) reg wroteData:(NSString*) data;
-(void) i2cRegisterRemoved:(GMPI2CRegister*) reg;
@end

@interface GMPI2CRegisterViewController : UIViewController <UIActionSheetDelegate>
{
    UIColor * defaultButtonColor;
}

@property (weak, nonatomic) GMPI2CRegister * reg;
@property (weak, nonatomic) id<GMPI2CRegisterDelegate> delegate;

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
