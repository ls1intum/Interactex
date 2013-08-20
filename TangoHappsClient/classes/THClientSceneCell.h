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

@interface THClientSceneCell : UICollectionViewCell

@property (nonatomic) BOOL editing;

@property (nonatomic) NSString * title;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

- (IBAction)deleteTapped:(id)sender;

-(void) startShaking;
-(void) stopShaking;
-(void) scaleEffect;

@end
