//
//  THTableProjectCell.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/12/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THTableProjectCell;

@protocol THTableProjectCellDelegate <NSObject>

-(void) tableProjectCell:(THTableProjectCell*) cell didChangeNameTo:(NSString*) name;
-(void) didDuplicateTableProjectCell:(THTableProjectCell*)cell;
@end

@interface THTableProjectCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) id<THTableProjectCellDelegate> delegate;

- (IBAction)textChanged:(id)sender;

@end
