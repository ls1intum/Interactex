/*
GMPPinCell.m
iGMP

Created by Juan Haladjian on 27/06/2013.

iGMP is an App to control an Arduino board over Bluetooth 4.0. iGMP uses the GMP protocol (based on Firmata): www.firmata.org

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany, 
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
It has been created with funding from EIT ICT, as part of the activity "Connected Textiles".


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "GMPPinCell.h"
#import "GMPPin.h"
#import <QuartzCore/QuartzCore.h>

@implementation GMPPinCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier pin:(GMPPin*) pin {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.pin = pin;
        
        [self relayout];
    }
    return self;
}

-(void) setPin:(GMPPin *)pin{
    if(_pin != pin){
        if(pin){
            [_pin removeObserver:self forKeyPath:@"value"];
            [_pin removeObserver:self forKeyPath:@"updatesValues"];
            
            [pin addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
            [pin addObserver:self forKeyPath:@"updatesValues" options:NSKeyValueObservingOptionNew context:nil];
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
    
    if(self.pin.type == kGMPPinTypeDigital){
        self.label.text = @"D";
    } else {
        self.label.text = @"A";
    }
    
    self.label.text = [self.label.text stringByAppendingFormat:@"%d",self.pin.number];
    
}

-(void) addDigitalButton{
    
    //CGRect segmentFrame = CGRectMake(175, 10, 130, 33);
    self.digitalControl.hidden = NO;

}

-(void) addValueLabel{
    self.valueLabel.hidden = NO;
}

-(void) addSlider{
    
    if(self.pin.mode == kGMPPinModeServo){
        self.slider.maximumValue = 180;
    } else {
        self.slider.maximumValue = 255;
    }
    self.slider.hidden = NO;

}

-(void) removeControls{
    if(self.digitalControl){
        self.digitalControl.hidden = YES;
    }
    
    if(self.valueLabel){
        self.valueLabel.hidden = YES;
    }
    
    if(self.slider){
        self.slider.hidden = YES;
    }
}

-(void) reloadPinModeControls{
    [self removeControls];
    
    if(self.pin.type == kGMPPinTypeDigital){
        if(self.pin.mode == kGMPPinModeOutput){
            
            [self addDigitalButton];
            self.modeControl.selectedSegmentIndex = 1;
            
        } else if(self.pin.mode == kGMPPinModeInput){
            
            [self addValueLabel];
            [self updateDigitalLabel];
        } else if(self.pin.mode == kGMPPinModePWM){
            
            self.modeControl.selectedSegmentIndex = 3;
            [self addSlider];
            [self updateSlider];
            
        } else if(self.pin.mode == kGMPPinModeServo){
            
            self.modeControl.selectedSegmentIndex = 2;
            [self addSlider];
            [self updateSlider];
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
    self.analogValueLabel.text = [NSString stringWithFormat:@"%d",self.pin.value];
}

-(void) updateSlider{
    self.slider.value = self.pin.value;
}

-(IBAction) segmentedControlChanged:(UISegmentedControl*) sender{
    
    if(sender.selectedSegmentIndex < 2){
        self.pin.mode = sender.selectedSegmentIndex;
    } else if(sender.selectedSegmentIndex == 2){
        self.pin.mode = kGMPPinModeServo;
    } else {
        self.pin.mode = kGMPPinModePWM;
    }
    
    [self reloadPinModeControls];
}

- (IBAction)analogSwitchChanged:(UISwitch*)sender {
    
    [self.pin removeObserver:self forKeyPath:@"updatesValues"];
    self.pin.updatesValues = sender.on;
    if(!self.pin.updatesValues){
        self.analogValueLabel.text = @"";
    }
    [self.pin addObserver:self forKeyPath:@"updatesValues" options:NSKeyValueObservingOptionNew context:nil];
}

-(IBAction) digitalControlChanged:(UISegmentedControl*) sender{
    [self.pin removeObserver:self forKeyPath:@"value"];
    self.pin.value = sender.selectedSegmentIndex;
    [self.pin addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
}

-(IBAction) sliderChanged:(UISlider*) sender{
    
    if(self.pin.value != sender.value && (sender.value == 0 || fabs(self.pin.value - sender.value) > 10)){
        [self.pin removeObserver:self forKeyPath:@"value"];
        self.pin.value = sender.value;
        [self.pin addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
    }
}

#pragma mark -- Keyvalue coding

-(void) handlePinValueChanged:(GMPPin*) pin{
    
    if(pin.mode == kGMPPinModeInput){
        [self updateDigitalLabel];
    } else if(pin.mode == kGMPPinModeAnalog){
        if(pin.updatesValues){
            [self updateAnalogLabel];
        }
    } else if(pin.mode == kGMPPinModePWM){
        [self updateSlider];
    }
}

-(void) handlePinUpdatesValuesChanged:(GMPPin*) pin{
    
    if(pin.mode == kGMPPinModeAnalog){
        self.analogSwitch.on = pin.updatesValues;
        if(!pin.updatesValues){
            self.analogValueLabel.text = @"";
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath  ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if([keyPath isEqual:@"value"]){
        
        [self handlePinValueChanged:object];
    } else if([keyPath isEqual:@"updatesValues"]){
        
        [self handlePinUpdatesValuesChanged:object];
    }
}

-(void) dealloc{
    
    [self.pin removeObserver:self forKeyPath:@"value"];
    [self.pin removeObserver:self forKeyPath:@"updatesValues"];
}

@end
