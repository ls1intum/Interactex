//
//  THPinsControllerContainer.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/29/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

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
    label.text = [NSString stringWithFormat:@"%@ %d",pintype,realPin.number];
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
            _segmentedControl.selectedSegmentIndex = realPin.currentValue;
            
            valueView = _segmentedControl;
            
            [_segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:)
                        forControlEvents:UIControlEventValueChanged];
        } else if(pin.mode == kPinModeDigitalInput){
            
            CGRect valueLabelFrame = CGRectMake(typeLabelFrame.origin.x + kPinControllerTypeLabelSize.width + kPinControllerInnerPadding, kPinControllerInnerPadding, kPinControllerSegmentedSize.width, kPinControllerSegmentedSize.height);
            NSString * valueStr = (realPin.currentValue == kDigitalPinValueHigh) ? @"High" : @"Low";
            
            _valueLabel = [self labelWithFrame:valueLabelFrame text:valueStr];
            
            [self addSubview:_valueLabel];
            
        } else if(pin.mode == kPinModePWM || pin.mode == kPinModeBuzzer){
            
            CGRect sliderFrame = CGRectMake(typeLabelFrame.origin.x + kPinControllerTypeLabelSize.width + kPinControllerInnerPadding, kPinControllerInnerPadding, kPinControllerSliderSize.width, kPinControllerSliderSize.height);
            _slider = [[UISlider alloc] initWithFrame:sliderFrame];
            _slider.minimumValue = 0;
            _slider.maximumValue = 255;
            _slider.value = realPin.currentValue;
            //slider.enabled = YES;
            valueView = _slider;
            
            [_slider addTarget:self action:@selector(sliderValueChanged:)
              forControlEvents:UIControlEventValueChanged];
        } else if(pin.mode == kPinModeAnalogInput){
            
            CGRect valueLabelFrame = CGRectMake(typeLabelFrame.origin.x + kPinControllerTypeLabelSize.width + kPinControllerInnerPadding, kPinControllerInnerPadding, kPinControllerSegmentedSize.width, kPinControllerSegmentedSize.height);
            
            NSString * text = [NSString stringWithFormat:@"%d",pin.currentValue];
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
        
    if(pin.currentValue < 0) { // buzzer sends -1 in the end
        return;
    }
    
    if(pin.mode == kPinModeDigitalOutput){
        _segmentedControl.selectedSegmentIndex = pin.currentValue;
    } else if(pin.mode == kPinModeDigitalInput){
        
        NSString * valueStr = (pin.currentValue == kDigitalPinValueHigh) ? @"High" : @"Low";
        _valueLabel.text = valueStr;
    } else if(pin.mode == kPinModePWM || pin.mode == kPinModeBuzzer) {

        _slider.value = pin.currentValue;
    } else if(pin.mode == kPinModeAnalogInput){
        _valueLabel.text = [NSString stringWithFormat:@"%d",pin.currentValue];
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
    pin.currentValue = slider.value;
    [pin notifyNewValue];
}

-(void) segmentedControlValueChanged:(UISegmentedControl*) control{
    THBoardPin * pin = (THBoardPin*) self.pin.simulableObject;
    pin.currentValue = control.selectedSegmentIndex;
    [pin notifyNewValue];
}

-(void) prepareToDie{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
