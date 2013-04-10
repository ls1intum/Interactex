//
//  THThreeColorLedProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 1/8/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THThreeColorLedProperties.h"
#import "THThreeColorLedEditable.h"

@implementation THThreeColorLedProperties

-(NSString *)title {
    return @"Potentiometer";
}

-(void) updateRedLabel{
    THThreeColorLedEditable * led = (THThreeColorLedEditable*) self.editableObject;
    self.redLabel.text = [NSString stringWithFormat:@"%d",led.red];
}

-(void) updateGreenLabel{
    THThreeColorLedEditable * led = (THThreeColorLedEditable*) self.editableObject;
    self.greenLabel.text = [NSString stringWithFormat:@"%d",led.green];
}

-(void) updateBlueLabel{
    THThreeColorLedEditable * led = (THThreeColorLedEditable*) self.editableObject;
    self.blueLabel.text = [NSString stringWithFormat:@"%d",led.blue];
}

-(void) updateRedSlider{
    THThreeColorLedEditable * led = (THThreeColorLedEditable*) self.editableObject;
    self.redSlider.value = led.red;
}

-(void) updateGreenSlider{
    THThreeColorLedEditable * led = (THThreeColorLedEditable*) self.editableObject;
    self.greenSlider.value = led.green;
}

-(void) updateBlueSlider{
    THThreeColorLedEditable * led = (THThreeColorLedEditable*) self.editableObject;
    self.blueSlider.value = led.blue;
}

- (IBAction)redChanged:(id)sender {
    THThreeColorLedEditable * led = (THThreeColorLedEditable*) self.editableObject;
    led.red = self.redSlider.value;
    [self updateRedLabel];
}

- (IBAction)greenChanged:(id)sender {
    THThreeColorLedEditable * led = (THThreeColorLedEditable*) self.editableObject;
    led.green = self.greenSlider.value;
    [self updateGreenLabel];
}

- (IBAction)blueChanged:(id)sender {
    THThreeColorLedEditable * led = (THThreeColorLedEditable*) self.editableObject;
    led.blue = self.blueSlider.value;
    [self updateBlueLabel];
}

-(void) reloadState{
    [self updateRedLabel];
    [self updateGreenLabel];
    [self updateBlueLabel];
    [self updateRedSlider];
    [self updateGreenSlider];
    [self updateBlueSlider];
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
