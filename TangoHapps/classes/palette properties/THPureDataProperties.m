//
//  THPureDataProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 4/23/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THPureDataProperties.h"
#import "THPureDataEditable.h"

@implementation THPureDataProperties

-(NSString*) title{
    return @"PureData";
}

 -(void) updateVarLabels{
 
 //THPureDataEditable * PureData = (THPureDataEditable*) self.editableObject;
 //self.var1Label.text = [NSString stringWithFormat: @"%d", PureData.variable1];
 //self.var2Label.text = [NSString stringWithFormat: @"%d", PureData.variable2];
 }
 
 -(void) reloadState{
 
 //THPureDataEditable * PureData = (THPureDataEditable*) self.editableObject;
 //when uncommenting following lines it will crash
     
 //self.var1Slider.value = PureData.variable1;
 //self.var2Slider.value = PureData.variable2;
 [self updateVarLabels];
 }
 
 - (IBAction)var1Changed:(id)sender {
 
 THPureDataEditable * PureData = (THPureDataEditable*) self.editableObject;
 
 NSInteger var1 = self.var1Slider.value;
 PureData.variable1 = var1;

 [self updateVarLabels];
 }

- (IBAction)var2Changed:(id)sender {
    
    THPureDataEditable * PureData = (THPureDataEditable*) self.editableObject;
    
    NSInteger var2 = self.var2Slider.value;
    PureData.variable2 = var2;
    
    [self updateVarLabels];
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
    
 [self setVar1Label:nil];
 [self setVar1Slider:nil];

 [self setVar2Label:nil];
 [self setVar2Slider:nil];
 
 [super viewDidUnload];
 }

@end
