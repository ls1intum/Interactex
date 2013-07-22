//
//  IFPinCell.m
//  iFirmata
//
//  Created by Juan Haladjian on 6/27/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "IFPinCell.h"
#import "IFPin.h"
#import <QuartzCore/QuartzCore.h>

@implementation IFPinCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier pin:(IFPin*) pin {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.pin = pin;
        
        [self relayout];
    }
    return self;
}

-(void) setPin:(IFPin *)pin{
    if(_pin != pin){
        if(pin){
            [_pin removeObserver:self forKeyPath:@"value"];
            [pin addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
        }
        _pin = pin;
        [self relayout];
    }
}

-(void) relayout{
    
    [self setLabelText];
    [self reloadPinModeControls];
}

#pragma mark -- GUI Setup

-(void) setLabelText{
    
    if(self.pin.type == IFPinTypeDigital){
        self.label.text = @"D";
    } else {
        self.label.text = @"A";
    }
    
    self.label.text = [self.label.text stringByAppendingFormat:@"%d",self.pin.number];
}

-(void) addDigitalButton{
    
    CGRect segmentFrame = CGRectMake(175, 8, 130, 33);
    
    NSArray * items = [NSArray arrayWithObjects:@"LOW",@"HIGH",nil];
    self.digitalControl = [[UISegmentedControl alloc] initWithItems:items];
    
    self.digitalControl.selectedSegmentIndex = self.pin.value;
    self.digitalControl.frame = segmentFrame;
    
    [self.digitalControl addTarget:self action:@selector(digitalControlChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:self.digitalControl];
}

-(void) addValueLabel{
    CGRect labelFrame = CGRectMake(240, 10, 82, 35);
    
    self.valueLabel = [[UILabel alloc] initWithFrame:labelFrame];
    self.valueLabel.layer.borderWidth = 1.0f;
    self.valueLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.valueLabel];
}

-(void) addSlider{
    
    CGRect sliderFrame = CGRectMake(175, 8, 135, 35);
    
    self.slider = [[UISlider alloc] initWithFrame:sliderFrame];
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 255;
    [self.slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:self.slider];
}

/*
-(void) addAnalogSwitch{
    CGRect labelFrame = CGRectMake(186, 26, 79, 27);
    
    self.analogSwitch = [[UISwitch alloc] initWithFrame:labelFrame];
    self.analogSwitch.enabled = NO;
    
    [self.analogSwitch addTarget:self action:@selector(analogSwitchChanged) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:self.analogSwitch];
}*/

-(void) removeControls{
    if(self.digitalControl){
        [self.digitalControl removeFromSuperview];
    }
    
    if(self.valueLabel){
        [self.valueLabel removeFromSuperview];
    }
    
    if(self.slider){
        [self.slider removeFromSuperview];
    }
}

-(void) reloadPinModeControls{
    [self removeControls];
    
    if(self.pin.type == IFPinTypeDigital){
        if(self.pin.mode == IFPinModeOutput){
            
            [self addDigitalButton];
            self.modeControl.selectedSegmentIndex = 1;
        } else if(self.pin.mode == IFPinModeInput){
            
            [self addValueLabel];
            [self updateDigitalLabel];
        } else if(self.pin.mode == IFPinModePWM){
            
            self.modeControl.selectedSegmentIndex = 3;
            [self addSlider];
        } else if(self.pin.mode == IFPinModeServo){
            
            self.modeControl.selectedSegmentIndex = 2;
            [self addSlider];
        }
    } else {
        
        //self.modeControl.selectedSegmentIndex = 2;
        self.valueLabel.layer.borderWidth = 1.0f;
        
        //[self addAnalogSwitch];
        //[self addValueLabel];
    }
}

#pragma mark -- Update

-(void) updateDigitalLabel{
    self.valueLabel.text = (self.pin.value == 0 ? @"LOW" : @"HIGH");
}

-(void) updateAnalogLabel{
    self.valueLabel.text = [NSString stringWithFormat:@"%d",self.pin.value];
}

-(IBAction) segmentedControlChanged:(UISegmentedControl*) sender{
    if(self.pin.type == IFPinTypeDigital){
        self.pin.mode = sender.selectedSegmentIndex;
        
    } else {
        if(sender.selectedSegmentIndex == 2){
            self.pin.mode = IFPinModeAnalog;
        } else {
            self.pin.mode = sender.selectedSegmentIndex;
        }
    }
    
    [self reloadPinModeControls];
}

- (IBAction)analogSwitchChanged:(UISwitch*)sender {
    self.pin.updatesValues = sender.on;
}

-(void) digitalControlChanged:(UISegmentedControl*) sender{
    self.pin.value = sender.selectedSegmentIndex;
}

-(void) sliderChanged:(UISlider*) sender{
    if(sender.value == 0 || fabs(self.pin.value - sender.value) > 10){
        self.pin.value = sender.value;
    }
}

#pragma mark -- Keyvalue coding

-(void) handlePinValueChanged:(IFPin*) pin{
    if(pin.mode == IFPinModeInput){
        [self updateDigitalLabel];
    } else if(pin.mode == IFPinModeAnalog){
        [self updateAnalogLabel];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath  ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if([keyPath isEqual:@"value"]){
    
        [self handlePinValueChanged:object];
    }
}

-(void) dealloc{
    
    [self.pin removeObserver:self forKeyPath:@"value"];
}

@end
