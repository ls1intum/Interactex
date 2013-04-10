//
//  THTimerProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 2/21/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THTimerProperties.h"
#import "THTimerEditable.h"

@implementation THTimerProperties

-(NSString *)title {
    return @"Timer";
}

-(void) updateFrequencyLabel{
    
    THTimerEditable * timer = (THTimerEditable*) self.editableObject;
    
    self.secondsLabel.text = [NSString stringWithFormat:@"%.3fs",timer.frequency];
}

-(void) updateFrequencySlider{
    
    THTimerEditable * timer = (THTimerEditable*) self.editableObject;
    self.secondsSlider.value = timer.frequency;
}

-(void) reloadState{
    
    [self updateFrequencyLabel];
    [self updateFrequencySlider];
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

-(void) updateTime{
    
    THTimerEditable * timer = (THTimerEditable*) self.editableObject;
    double miliseconds = [self.milisecondsText.text doubleValue];
    timer.frequency = self.secondsSlider.value + miliseconds / 1000.0f;
}

- (IBAction)secondsChanged:(id)sender {
    [self updateTime];
    [self updateFrequencyLabel];
}

- (IBAction)typeChanged:(id)sender {
    
    THTimerEditable * timer = (THTimerEditable*) self.editableObject;
    timer.type = self.alwaysSwitch.on;
}

- (IBAction)milisecondsChanged:(id)sender {
    [self updateTime];
    [self updateFrequencyLabel];
}

@end
