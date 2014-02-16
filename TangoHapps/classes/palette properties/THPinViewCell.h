//
//  THPinViewCell.h
//  TangoHapps
//
//  Created by Juan Haladjian on 16/02/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THBoardPinEditable;
@class THPinViewCell;

@protocol THPinViewCellDelegate <NSObject>

-(void) pinViewCell:(THPinViewCell*) pinViewCell didChangePwmStateTo:(BOOL) pwm;

@end

@interface THPinViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *pinLabel;
@property (strong, nonatomic) UILabel *pinInfoLabel;
@property (strong, nonatomic) UISegmentedControl *pwmControl;
@property (weak, nonatomic) THBoardPinEditable * boardPin;
@property (weak, nonatomic) id<THPinViewCellDelegate> delegate;

- (void)pwmControlChanged:(id)sender;

@end
