//
//  THBuzzerProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THBuzzerProperties.h"
#import "THBuzzer.h"
#import "THBuzzerEditableObject.h"

@implementation THBuzzerProperties
@synthesize testButton;
@synthesize onSwitch;
@synthesize frequencyLabel;
@synthesize frequencySlider;


-(NSString *)title
{
    return @"Buzzer";
}

-(void) reloadState{
    
    THBuzzerEditableObject * buzzer = (THBuzzerEditableObject*) self.editableObject;
    self.frequencySlider.value = buzzer.frequency;
    [self updateValueLabels];
    
    self.onSwitch.on = buzzer.onAtStart;
}

#pragma mark - Interface Actions

- (IBAction)onChanged:(id)sender {
    THBuzzerEditableObject * buzzer = (THBuzzerEditableObject*) self.editableObject;
    buzzer.onAtStart = self.onSwitch.on;
}

- (IBAction) frequencySliderChanged:(UISlider *)sender
{
    float frequency = [sender value];
    THBuzzerEditableObject * buzzer = (THBuzzerEditableObject*) self.editableObject;
    buzzer.frequency = frequency;
    
    [self updateValueLabels];
}

- (IBAction)testTapped:(id)sender {
    
    THBuzzerEditableObject * buzzerEditable = (THBuzzerEditableObject*) self.editableObject;
    
    if(buzzerEditable.on) {
        [buzzerEditable handleBuzzerOff];
        UIImage * image = [UIImage imageNamed:@"buzzerPlay.png"];
        [self.testButton setImage:image forState:UIControlStateNormal];
    } else {
        [buzzerEditable handleBuzzerOn];
        UIImage * image = [UIImage imageNamed:@"buzzerStop.png"];
        [self.testButton setImage:image forState:UIControlStateNormal];
    }
}

#pragma mark Private

-(void)updateValueLabels
{
    THBuzzerEditableObject * buzzer = (THBuzzerEditableObject*) self.editableObject;
    self.frequencyLabel.text = [NSString stringWithFormat:@"%.2f",buzzer.frequency];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setFrequencySlider:nil];
    [self setFrequencyLabel:nil];
    [self setTestButton:nil];
    [self setOnSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
@end
