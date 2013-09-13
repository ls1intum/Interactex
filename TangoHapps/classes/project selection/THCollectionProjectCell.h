//
//  THClientSceneCell.h
//  TangoHapps
//
//  Created by Juan Haladjian on 8/18/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const float kShakingEffectAngleInRadians;
extern const float kShakingEffectRotationTime;
extern const float kProjectCellScaleEffectDuration;

@class THCollectionProjectCell;

@protocol THProjectCellDelegate <NSObject>

-(void) didDeleteProjectCell:(THCollectionProjectCell*)cell;
-(void) didRenameProjectCell:(THCollectionProjectCell*)cell toName:(NSString*) name;
-(void) didDuplicateProjectCell:(THCollectionProjectCell*)cell;

@end

@interface THCollectionProjectCell : UICollectionViewCell <UITextFieldDelegate>

@property (nonatomic) BOOL editing;

@property (weak, nonatomic) IBOutlet UITextField * nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) id<THProjectCellDelegate> delegate;

- (IBAction)deleteTapped:(id)sender;
- (IBAction)textChanged:(id)sender;

-(void) startShaking;
-(void) stopShaking;
-(void) scaleEffect;

@end
