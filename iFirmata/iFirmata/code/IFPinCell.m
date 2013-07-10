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
    if(pin != self.pin){
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
    
    self.digitalControl.selectedSegmentIndex = 0;
    self.digitalControl.frame = segmentFrame;
    
    [self.digitalControl addTarget:self action:@selector(digitalControlChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:self.digitalControl];
}

-(void) addValueLabel{
    
    CGRect labelFrame = CGRectMake(195, 8, 80, 35);
    
    self.valueLabel = [[UILabel alloc] initWithFrame:labelFrame];
    self.valueLabel.layer.borderWidth = 1.0f;
    
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
        } else if(self.pin.mode == IFPinModeInput){
            
            [self addValueLabel];
        } else if(self.pin.mode == IFPinModePWM){
            [self addSlider];
        } else if(self.pin.mode == IFPinModeServo){
            [self addSlider];
        }
    } else {
        
        [self addValueLabel];
    }
}
/*
-(void) parseBuf:(const uint8_t *)buf length:(NSInteger) len {
        const uint8_t *p, *end;
        
        p = buf;
        end = p + len;
        for (p = buf; p < end; p++) {
            uint8_t msn = *p & 0xF0;
            if (msn == 0xE0 || msn == 0x90 || *p == 0xF9) {
                parse_command_len = 3;
                parse_count = 0;
            } else if (msn == 0xC0 || msn == 0xD0) {
                parse_command_len = 2;
                parse_count = 0;
            } else if (*p == START_SYSEX) {
                parse_count = 0;
                parse_command_len = sizeof(parse_buf);
            } else if (*p == END_SYSEX) {
                parse_command_len = parse_count + 1;
            } else if (*p & 0x80) {
                parse_command_len = 1;
                parse_count = 0;
            }
            if (parse_count < (int)sizeof(parse_buf)) {
                parse_buf[parse_count++] = *p;
            }
            if (parse_count == parse_command_len) {
                DoMessage();
                parse_count = parse_command_len = 0;
            }
        }
    }
}*/

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

-(void) digitalControlChanged:(UISegmentedControl*) sender{
    self.pin.value = sender.selectedSegmentIndex;
}

-(void) sliderChanged:(UISlider*) sender{
    if(sender.value == 0 || fabs(self.pin.value - sender.value) > 10){
        self.pin.value = sender.value;
    }
}

@end
