//
//  THSliderProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 12/9/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THSliderProperties.h"
#import "THSliderEditableObject.h"

@implementation THSliderProperties

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSString *)title {
    return @"Slider";
}

-(void) updateMinLabel{
    
    THSliderEditableObject *slider = (THSliderEditableObject*) self.editableObject;
    self.minLabel.text = [NSString stringWithFormat:@"%.2f",slider.min];
}

-(void) updateMaxLabel{
    
    THSliderEditableObject *slider = (THSliderEditableObject*) self.editableObject;
    self.maxLabel.text = [NSString stringWithFormat:@"%.2f",slider.max];
}

-(void) updateValueLabel{
    
    THSliderEditableObject *slider = (THSliderEditableObject*) self.editableObject;
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f",slider.value];
}

-(void) updateMinSlider{
    
    THSliderEditableObject *slider = (THSliderEditableObject*) self.editableObject;
    self.minSlider.value = slider.min;
}

-(void) updateMaxSlider{
    
    THSliderEditableObject *slider = (THSliderEditableObject*) self.editableObject;
    self.maxSlider.value = slider.max;
}

-(void) updateValueSlider{
    
    THSliderEditableObject *slider = (THSliderEditableObject*) self.editableObject;
    self.valueSlider.value = slider.value;
}

-(void) reloadState{
    
    [self updateMinLabel];
    [self updateMaxLabel];
    [self updateValueLabel];
    [self updateMinSlider];
    [self updateMaxSlider];
    [self updateValueSlider];
}

- (IBAction)valueChanged:(id)sender {
    THSliderEditableObject *slider = (THSliderEditableObject*) self.editableObject;
    slider.value = self.valueSlider.value;
    
    [self updateValueLabel];
}

- (IBAction)minChanged:(id)sender {
    
    THSliderEditableObject *slider = (THSliderEditableObject*) self.editableObject;
    slider.min = self.minSlider.value;
    self.valueSlider.minimumValue = slider.min;
    self.maxSlider.minimumValue = slider.min;
    [self updateMinLabel];
}

- (IBAction)maxChanged:(id)sender {
    
    THSliderEditableObject *slider = (THSliderEditableObject*) self.editableObject;
    slider.max = self.maxSlider.value;
    self.valueSlider.maximumValue = slider.max;
    self.minSlider.maximumValue = slider.max;
    [self updateMaxLabel];
}

#pragma Mark - View Lifecycle

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

- (void)viewDidUnload {
    [self setValueSlider:nil];
    [self setMinSlider:nil];
    [self setMaxSlider:nil];
    [self setValueLabel:nil];
    [self setMinLabel:nil];
    [self setMaxLabel:nil];
    [super viewDidUnload];
}
@end
