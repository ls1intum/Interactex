//
//  THClientSceneCell.m
//  TangoHapps
//
//  Created by Juan Haladjian on 8/18/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THCollectionProjectCell.h"

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

@implementation THCollectionProjectCell

const float kShakingEffectAngleInRadians = 2.0f;
const float kShakingEffectRotationTime = 0.10f;
const float kProjectCellScaleEffectDuration = 0.5;

- (id)initWithFrame:(CGRect)frame {
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
            self.nameTextField.enabled = YES;
            self.nameTextField.borderStyle = UITextBorderStyleLine;
            
        } else {
            
            [self stopShaking];
            
            self.deleteButton.hidden = YES;
            self.nameTextField.enabled = NO;
            self.nameTextField.borderStyle = UITextBorderStyleNone;
        }
    }
}


#pragma mark - UI Interaction

- (IBAction)deleteTapped:(id)sender {
    
    [self.delegate didDeleteProjectCell:self];
}

- (IBAction)textChanged:(id)sender {
    [self.delegate didRenameProjectCell:self toName:self.nameTextField.text];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self.nameTextField resignFirstResponder];
    
    return YES;
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
                     completion:nil
     ];
}

- (void)stopShaking {
    [self.layer removeAllAnimations];
    self.transform = CGAffineTransformIdentity;
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

-(void) scaleEffect{
    
    [UIView animateWithDuration:kProjectCellScaleEffectDuration/2.0f
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         self.transform = CGAffineTransformMakeScale(1.1, 1.1);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:kProjectCellScaleEffectDuration/2.0f
                                               delay:0
                                             options:UIViewAnimationOptionBeginFromCurrentState
                                          animations:(void (^)(void)) ^{
                                              self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                          }
                                          completion:^(BOOL finished){
                                              
                                              self.transform = CGAffineTransformIdentity;
                                              
                                          }];
                         
                     }];
}

-(BOOL) canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(duplicate:));
}

-(void) duplicate: (id) sender {
    [self.delegate didDuplicateProjectCell:self];
}

@end
