//
//  THClientSceneCell.m
//  TangoHapps
//
//  Created by Juan Haladjian on 8/18/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THClientSceneCell.h"

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

@implementation THClientSceneCell

const float kShakingEffectAngleInRadians = 2.0f;
const float kShakingEffectRotationTime = 0.10f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        
    }
    return self;
}

-(void) setEditing:(BOOL)editing{
    if(editing != _editing){
        _editing = editing;
        
        if(editing){
            
            [self startShaking];
            
            self.deleteButton.hidden = NO;
            self.titleTextField.enabled = YES;
            self.titleTextField.borderStyle = UITextBorderStyleLine;
            
        } else {
            
            [self stopShaking];
            
            self.deleteButton.hidden = YES;
            self.titleTextField.enabled = NO;
            self.titleTextField.borderStyle = UITextBorderStyleNone;
        }
    }
}

-(void) setTitle:(NSString *)title{
    self.titleTextField.text = title;
}

-(NSString*) title{
    return self.titleTextField.text;
}

- (IBAction)deleteTapped:(id)sender {
    
}

#pragma mark - Effects

- (void)startShaking {
    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-kShakingEffectAngleInRadians));
    
    [UIView animateWithDuration:kShakingEffectRotationTime
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse)
                     animations:^ {
                        self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(kShakingEffectAngleInRadians));
                     }
                     completion:NULL
     ];
}

- (void)stopShaking {
    [UIView animateWithDuration:kShakingEffectRotationTime
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear)
                     animations:^ {
                         self.transform = CGAffineTransformIdentity;
                     }
                     completion:NULL
     ];
}

-(void)fadeView:(UIView*)view toHidden:(BOOL)hidden {
    if(!hidden){
        [view setAlpha:0];
        [view setHidden:NO];
    }
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         [view setAlpha:(hidden ? 0 : 1)];
                     } completion:^(BOOL finished) {
                         if(hidden){
                             [view setHidden:YES];
                         }
                     }];
}

-(void) scaleEffect {
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(5));
                         
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.25
                                               delay:0
                                             options:UIViewAnimationOptionBeginFromCurrentState
                                          animations:(void (^)(void)) ^{
                                          }
                                          completion:^(BOOL finished){
                                              
                                          }];
                         
                     }];
}

@end
