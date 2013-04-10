//
//  THPotentiometerProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 1/7/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THPotentiometerProperties.h"
#import "THPotentiometerEditableObject.h"

@implementation THPotentiometerProperties

-(NSString *)title {
    return @"Potentiometer";
}

-(void) reloadState{
    [self updateMinLabel];
    [self updateMaxLabel];
    [self updateMinSlider];
    [self updateMinSlider];
    [self updateBehaviorType];
    [self updateTextLabel];
}

-(void) updateBehaviorType{
    
    THPotentiometerEditableObject * potentiometer = (THPotentiometerEditableObject*)self.editableObject;
    self.behaviorControl.selectedSegmentIndex = potentiometer.notifyBehavior;
}

-(void) updateMinLabel{
    THPotentiometerEditableObject * potentiometer = (THPotentiometerEditableObject*)self.editableObject;
    self.minLabel.text = [NSString stringWithFormat:@"%d",potentiometer.minValueNotify];
}

-(void) updateMaxLabel{
    THPotentiometerEditableObject * potentiometer = (THPotentiometerEditableObject*)self.editableObject;
    self.maxLabel.text = [NSString stringWithFormat:@"%d",potentiometer.maxValueNotify];
}

-(void) updateMinSlider{
    THPotentiometerEditableObject * potentiometer = (THPotentiometerEditableObject*)self.editableObject;
    self.minSlider.value = potentiometer.minValueNotify;
    self.maxSlider.minimumValue = potentiometer.minValueNotify;
}

-(void) updateMaxSlider{
    THPotentiometerEditableObject * potentiometer = (THPotentiometerEditableObject*)self.editableObject;
    self.maxSlider.value = potentiometer.maxValueNotify;
    self.minSlider.maximumValue = potentiometer.maxValueNotify;
}

- (IBAction)minChanged:(id)sender {
    THPotentiometerEditableObject * potentiometer = (THPotentiometerEditableObject*)self.editableObject;
    potentiometer.minValueNotify = self.minSlider.value;
    self.maxSlider.minimumValue = potentiometer.minValueNotify;
    [self updateMinLabel];
}

- (IBAction)maxChanged:(id)sender {
    THPotentiometerEditableObject * potentiometer = (THPotentiometerEditableObject*)self.editableObject;
    potentiometer.maxValueNotify = self.maxSlider.value;
    self.minSlider.maximumValue = potentiometer.maxValueNotify;
    [self updateMaxLabel];
}

-(void) updateTextLabel{
    THPotentiometerEditableObject * potentiometer = (THPotentiometerEditableObject*)self.editableObject;
    self.textLabel.text = kNotifyBehaviorsText[potentiometer.notifyBehavior];
}

- (IBAction)behaviorChanged:(id)sender {
    
    THPotentiometerEditableObject * potentiometer = (THPotentiometerEditableObject*)self.editableObject;
    potentiometer.notifyBehavior = self.behaviorControl.selectedSegmentIndex;
    [self updateTextLabel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
