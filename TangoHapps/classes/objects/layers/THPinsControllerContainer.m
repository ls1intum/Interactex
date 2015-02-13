/*
THPinsControllerContainer.m
Interactex Designer

Created by Juan Haladjian on 05/10/2013.

Interactex Designer is a configuration tool to easily setup, simulate and connect e-Textile hardware with smartphone functionality. Interactex Client is an app to store and replay projects made with Interactex Designer.

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
The first version of the software was designed and implemented as part of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was founded by Telekom Innovation Laboratories Berlin. It has been extended with funding from EIT ICT, as part of the activity "Connected Textiles".

Interactex is built using the Tango framework developed by TU Munich.

In the Interactex software, we use the GHUnit (a test framework for iOS developed by Gabriel Handford) and cocos2D libraries (a framework for building 2D games and graphical applications developed by Zynga Inc.). 
www.cocos2d-iphone.org
github.com/gabriel/gh-unit

Interactex also implements the Firmata protocol. Its software serial library is based on the original Arduino Firmata library.
www.firmata.org

All hardware part graphics in Interactex Designer are reproduced with kind permission from Fritzing. Fritzing is an open-source hardware initiative to support designers, artists, researchers and hobbyists to work creatively with interactive electronics.
www.frizting.org

Martijn ten Bhömer from TU Eindhoven contributed PureData support. Contact: m.t.bhomer@tue.nl.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

#import "THPinsControllerContainer.h"
#import "THBoardPinEditable.h"
#import "THBoardPin.h"

@implementation THPinsControllerContainer


CGSize const kPinControllerLabelSize = {50, 30};
CGSize const kPinControllerValueLabelSize = {80, 30};
CGSize const kPinControllerTypeLabelSize = {80, 30};
CGSize const kPinControllerSegmentedSize = {100, 30};
CGSize const kPinControllerSliderSize = {150, 30};


float const kPinControllerInnerPadding = 5;

-(UILabel*) labelWithFrame:(CGRect) frame text:(NSString*) text{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont systemFontOfSize:13];
    return label;
}

-(void) setPin:(THBoardPinEditable *)pin{
    _pin = pin;
    
    THBoardPin * realPin = (THBoardPin*) pin.simulableObject;
    
    
    CGRect labelFrame = CGRectMake(kPinControllerInnerPadding, kPinControllerInnerPadding, kPinControllerLabelSize.width, kPinControllerLabelSize.height);
    UILabel * label = [[UILabel alloc] initWithFrame:labelFrame];
    label.font = [UIFont systemFontOfSize:13];
    NSString * pintype = [NSString stringWithFormat:@"%@ - ",kPinTexts[realPin.type]];
    label.text = [NSString stringWithFormat:@"%@ %ld",pintype,(long)realPin.number];
    [self addSubview:label];
    
    CGRect typeLabelFrame = CGRectMake(labelFrame.origin.x + kPinControllerLabelSize.width + kPinControllerInnerPadding, 5, kPinControllerTypeLabelSize.width, kPinControllerTypeLabelSize.height);
    UILabel * typeLabel = [[UILabel alloc] initWithFrame:typeLabelFrame];
    typeLabel.text = [NSString stringWithFormat:@"%@",kPinModeTexts[pin.mode]];
    typeLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:typeLabel];
    
    if(pin.mode != kPinModeUndefined){
        UIView * valueView = nil;
        if(pin.mode == kPinModeDigitalOutput){
            _segmentedControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Low", @"High", nil]];
            
            CGRect segmentedControlFrame = CGRectMake(typeLabelFrame.origin.x + kPinControllerTypeLabelSize.width + kPinControllerInnerPadding, kPinControllerInnerPadding, kPinControllerSegmentedSize.width, kPinControllerSegmentedSize.height);
            _segmentedControl.frame = segmentedControlFrame;
            _segmentedControl.selectedSegmentIndex = realPin.value;
            
            valueView = _segmentedControl;
            
            [_segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:)
                        forControlEvents:UIControlEventValueChanged];
        } else if(pin.mode == kPinModeDigitalInput){
            
            CGRect valueLabelFrame = CGRectMake(typeLabelFrame.origin.x + kPinControllerTypeLabelSize.width + kPinControllerInnerPadding, kPinControllerInnerPadding, kPinControllerSegmentedSize.width, kPinControllerSegmentedSize.height);
            NSString * valueStr = (realPin.value == kDigitalPinValueHigh) ? @"High" : @"Low";
            
            _valueLabel = [self labelWithFrame:valueLabelFrame text:valueStr];
            
            [self addSubview:_valueLabel];
            
        } else if(pin.mode == kPinModePWM){
            
            CGRect sliderFrame = CGRectMake(typeLabelFrame.origin.x + kPinControllerTypeLabelSize.width + kPinControllerInnerPadding, kPinControllerInnerPadding, kPinControllerSliderSize.width, kPinControllerSliderSize.height);
            _slider = [[UISlider alloc] initWithFrame:sliderFrame];
            _slider.minimumValue = 0;
            _slider.maximumValue = 255;
            _slider.value = realPin.value;
            //slider.enabled = YES;
            valueView = _slider;
            
            [_slider addTarget:self action:@selector(sliderValueChanged:)
              forControlEvents:UIControlEventValueChanged];
        } else if(pin.mode == kPinModeAnalogInput){
            
            CGRect valueLabelFrame = CGRectMake(typeLabelFrame.origin.x + kPinControllerTypeLabelSize.width + kPinControllerInnerPadding, kPinControllerInnerPadding, kPinControllerSegmentedSize.width, kPinControllerSegmentedSize.height);
            
            NSString * text = [NSString stringWithFormat:@"%ld",(long)pin.value];
            _valueLabel = [self labelWithFrame:valueLabelFrame text:text];
            
            [self addSubview:_valueLabel];
        }
        
        [self addSubview:valueView];
        [self registerPinObserver];
    }
}

-(void) registerPinObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pinValueChanged:) name:kNotificationPinValueChanged object:self.pin.simulableObject];
}

-(void) pinValueChanged:(NSNotification*) notification{
    THBoardPin * pin = (THBoardPin*) self.pin.simulableObject;
        
    if(pin.value < 0) { // buzzer sends -1 in the end
        return;
    }
    
    if(pin.mode == kPinModeDigitalOutput){
        _segmentedControl.selectedSegmentIndex = pin.value;
    } else if(pin.mode == kPinModeDigitalInput){
        
        NSString * valueStr = (pin.value == kDigitalPinValueHigh) ? @"High" : @"Low";
        _valueLabel.text = valueStr;
    } else if(pin.mode == kPinModePWM) {

        _slider.value = pin.value;
    } else if(pin.mode == kPinModeAnalogInput){
        _valueLabel.text = [NSString stringWithFormat:@"%ld",(long)pin.value];
    }
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        //self.layer.borderWidth = 1.0f;
    }
    return self;
}

#pragma mark - Events

-(void) sliderValueChanged:(UISlider*) slider{
    THBoardPin * pin = (THBoardPin*) self.pin.simulableObject;
    pin.value = slider.value;
}

-(void) segmentedControlValueChanged:(UISegmentedControl*) control{
    THBoardPin * pin = (THBoardPin*) self.pin.simulableObject;
    pin.value = control.selectedSegmentIndex;
}

-(void) prepareToDie{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
