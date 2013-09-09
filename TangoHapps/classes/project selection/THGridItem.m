//
//  TFGridItem.m
//  TangoFramework
//
//  Created by Juan Haladjian on 11/23/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THGridItem.h"

@implementation THGridItem


static inline double radians (double degrees) {return degrees * M_PI/180;}

- (id)initWithName:(NSString*)name image:(UIImage*)image {
    
    self = [super init];
    if(self){
        
        NSBundle * bundle = [NSBundle mainBundle];
        [bundle loadNibNamed:@"THGridItem" owner:self options:nil];
        [self addSubview:self.itemContainer];

        self.userInteractionEnabled = YES;
        self.name = name;
        self.image = image;
        
        self.textField.layer.borderColor = [UIColor whiteColor].CGColor;
        self.textField.delegate = self;
        
        // Long Press
        UILongPressGestureRecognizer *longpressRecognizer =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressedLong:)];
        [self addGestureRecognizer:longpressRecognizer];
    }
    return self;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self handleItemRenamed];
    [self.textField resignFirstResponder];
    
    return YES;
}

-(void) stopEditingSceneName{
    self.editing = NO;
}

-(BOOL) keyboardHidden{
    [self stopEditingSceneName];
    return YES;
}

-(void) setImage:(UIImage *)image{
    self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.button setImage:image forState:UIControlStateNormal];
    [self.button setImage:image forState:UIControlStateDisabled];
    //[self.button setImage:image forState:UIControlStateHighlighted];
}

-(UIImage*) image{
    return [self.button backgroundImageForState:UIControlStateNormal];
}

-(NSString*) name{
    return self.textField.text;
}

-(void) setName:(NSString *)name{
    self.textField.text = name;
}


-(void) startShaking{
    float const kItemShakingAngle = 0.5f;
    CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, radians(-kItemShakingAngle));
    CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, radians(kItemShakingAngle));
    
    self.transform = leftWobble;  // starting point
    
    [UIView beginAnimations:@"wobble" context:nil];
    [UIView setAnimationRepeatAutoreverses:YES]; // important
    [UIView setAnimationRepeatCount:MAXFLOAT];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(wobbleEnded:finished:context:)];
    
    self.transform = rightWobble; // end here & auto-reverse
    
    [UIView commitAnimations];
}

- (void) wobbleEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([finished boolValue]) {
        self.transform = CGAffineTransformIdentity;
    }
}

-(void) stopShaking {
    [self.layer removeAllAnimations];
    self.transform = CGAffineTransformIdentity;
}

-(void)setEditing:(BOOL)editing {
    if(_editable && editing != _editing){
        
        _editing = editing;
        
        self.button.enabled = !_editing;
        self.deleteButton.hidden = !_editing;
        
        if(_editing){
            [self startShaking];
            self.textField.layer.borderWidth = 1.0f;
        } else {
            [self stopShaking];
            self.textField.layer.borderWidth = 0;
        }
        
        self.textField.enabled = _editing;
    }
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
                         self.iPadFrame.transform = CGAffineTransformMakeScale(1.1, 1.1);
                         //self.button.transform = CGAffineTransformMakeScale(1.1, 1.1);
                         self.deleteButton.transform=CGAffineTransformMakeScale(1.1, 1.1);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.25
                                               delay:0
                                             options:UIViewAnimationOptionBeginFromCurrentState
                                          animations:(void (^)(void)) ^{
                                              self.iPadFrame.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                              //self.button.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                              self.deleteButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                          }
                                          completion:^(BOOL finished){
                                              
                                              self.iPadFrame.transform=CGAffineTransformIdentity;
                                              //self.button.transform = CGAffineTransformIdentity;
                                              self.deleteButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                              
                                          }];
                         
                     }];
}

-(void) pressedLong:(UILongPressGestureRecognizer*) recognizer{
    if(recognizer.state == UIGestureRecognizerStateBegan &&  !self.editing){
        [self scaleEffect];
        [self.delegate didLongPressGridItem:self];
    }
}

-(IBAction)selectItem:(id)sender {
    [self.delegate didSelectGridItem:self];
}

-(IBAction)deleteItem:(id)sender {
    [self.delegate didDeleteGridItem:self];
}

-(void) handleItemRenamed {
    NSLog(@"passing name: %@",self.name);
    [self.delegate didRenameGridItem:self newName:self.name];
}

-(IBAction)renameItem:(id)sender {
    [self handleItemRenamed];
}

- (IBAction)tapped:(id)sender {
    NSLog(@"tapp");
}

@end
