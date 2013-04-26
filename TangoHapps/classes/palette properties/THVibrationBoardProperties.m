//
//  THVibrationBoardProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 4/12/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THVibrationBoardProperties.h"
#import "THVibrationBoardEditable.h"

@implementation THVibrationBoardProperties

-(NSString*) title{
    return @"VibeBoard";
}

-(void) updateFrequencyLabel{
    
    THVibrationBoardEditable * vibrationBoard = (THVibrationBoardEditable*) self.editableObject;
    self.frequencyLabel.text = [NSString stringWithFormat: @"%d", vibrationBoard.frequency];
}

-(void) reloadState{
    
    THVibrationBoardEditable * vibrationBoard = (THVibrationBoardEditable*) self.editableObject;
    
    self.frequencySlider.value = vibrationBoard.frequency;
    [self updateFrequencyLabel];
}


- (IBAction)frequencyChanged:(id)sender {
    
    THVibrationBoardEditable * vibrationBoard = (THVibrationBoardEditable*) self.editableObject;
    
    float frequency = self.frequencySlider.value;
    vibrationBoard.frequency = frequency;
    [self updateFrequencyLabel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFrequencySlider:nil];
    [self setFrequencyLabel:nil];
    [super viewDidUnload];
}

@end
