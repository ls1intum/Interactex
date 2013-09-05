//
//  THWireProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 8/14/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THWireProperties.h"
#import "THColorPicker.h"
#import "THWire.h"

@implementation THWireProperties

-(NSString*) title{
    return @"Wire";
}

-(void) reloadState{
    
    [self updateColor];
}

-(void) updateColor {
    THWire * wire = (THWire*) self.editableObject;
    self.colorView.backgroundColor = [THHelper uicolorFromColor3B: wire.color];
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

- (void)presentColorPickerFromRect:(CGRect)rect {
    if(!colorPickerPopover){
        colorPicker = [[THColorPicker alloc] init];
        [colorPicker setDelegate:self];
        colorPickerPopover = [[UIPopoverController alloc] initWithContentViewController:colorPicker];
    }
    [colorPickerPopover presentPopoverFromRect:rect
                                        inView:self.view
                      permittedArrowDirections:UIPopoverArrowDirectionLeft
                                      animated:YES];
}

- (IBAction)changeColorTapped:(id)sender {
    
    [self presentColorPickerFromRect:self.changeColorButton.frame];
}

-(void)colorPicker:(THColorPicker *)picker didPickColor:(UIColor *)color {
    
    THWire * wire = (THWire*) self.editableObject;
    wire.color = [THHelper color3BFromUIColor:color];
    
    [self updateColor];
    [colorPickerPopover dismissPopoverAnimated:YES];
}

- (IBAction)addNodeTapped:(id)sender {
    
    THWire * wire = (THWire*) self.editableObject;
    [wire addMiddleNode];
}

@end
