/*
THClientCollectionProjectCell.m
Interactex Client

Created by Juan Haladjian on 12/11/2013.

iGMP is an App to control an Arduino board over Bluetooth 4.0. iGMP uses the GMP protocol (based on Firmata): www.firmata.org

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany, 
	
Contacts:
juan.haladjian@cs.tum.edu
k.zhang@utwente.nl
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
It has been created with funding from EIT ICT, as part of the activity "Connected Textiles".


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "THClientCollectionProjectCell.h"

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

@implementation THClientCollectionProjectCell

const float kShakingEffectAngleInRadians = 2.0f;
const float kShakingEffectRotationTime = 0.10f;
const float kProjectCellScaleEffectDuration = 0.5;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        self.nameTextField.delegate = self;
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
