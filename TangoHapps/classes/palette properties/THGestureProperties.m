//
//  THGestureProperties.m
//  TangoHapps
//
//  Created by Timm Beckmann on 18/04/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THGestureProperties.h"
#import "THGestureEditableObject.h"

@implementation THGestureProperties

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(NSString *)title
{
    return @"Button";
}

-(void) updateLabel{
    THGestureEditableObject * gesture = (THGestureEditableObject*) self.editableObject;
    self.scaleLabel.text = [NSString stringWithFormat:@"%.2f",gesture.scale];
}

-(void) updateSlider{
    
    THGestureEditableObject * gesture = (THGestureEditableObject*) self.editableObject;
    self.scaleSlider.value = gesture.scale;
}

-(void) reloadState{
    [self updateLabel];
    [self updateSlider];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScaleLabel:nil];
    [self setScaleSlider:nil];
    [super viewDidUnload];
}

- (IBAction)scaleChanged:(id)sender {
    
    THGestureEditableObject * gesture = (THGestureEditableObject*) self.editableObject;
    gesture.scale = self.scaleSlider.value;
    
    [self updateLabel];
}

- (IBAction)outputChanged:(UIStepper*)sender {
    
    THGestureEditableObject * gesture = (THGestureEditableObject*) self.editableObject;
    int count = [sender value];
    [gesture outputAmountChanged:count];
}

@end
