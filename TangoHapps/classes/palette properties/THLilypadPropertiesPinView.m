//
//  THLilypadPropertiesPinView.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/14/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THLilypadPropertiesPinView.h"
#import "THBoardPin.h"
#import "THBoardPinEditable.h"
#import "THElementPinEditable.h"
#import "THClotheObjectEditableObject.h"

@implementation THLilypadPropertiesPinView

CGSize const kLilypadPropertyLabelSize = {50, 30};
CGSize const kLilypadPropertyTypeLabelSize = {120, 30};
CGSize const kLilypadPropertySegmentedSize = {130, 30};

float const kLilypadPropertyInnerPadding = 5;

-(UILabel*) labelWithFrame:(CGRect) frame text:(NSString*) text{
    
    UILabel * modeLabel = [[UILabel alloc] initWithFrame:frame];
    modeLabel.backgroundColor = [UIColor clearColor];
    modeLabel.textColor = [UIColor whiteColor];
    modeLabel.text = text;
    modeLabel.font = [UIFont systemFontOfSize:13];
    return modeLabel;
}

-(void) setPin:(THBoardPinEditable *)pin{
    _pin = pin;
    
    THBoardPin * realPin = (THBoardPin*) pin.simulableObject;
    
    CGRect labelFrame = CGRectMake(kLilypadPropertyInnerPadding, kLilypadPropertyInnerPadding, kLilypadPropertyLabelSize.width, kLilypadPropertyLabelSize.height);
    UILabel * label = [[UILabel alloc] initWithFrame:labelFrame];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:13];
    NSString * pintype = [NSString stringWithFormat:@"%@ - ",kPinTexts[realPin.type]];
    label.text = [NSString stringWithFormat:@"%@ %d",pintype,realPin.number];
    [self addSubview:label];
    
    CGRect typeLabelFrame = CGRectMake(labelFrame.origin.x + labelFrame.size.width + kLilypadPropertyInnerPadding, 5, kLilypadPropertyTypeLabelSize.width, kLilypadPropertyTypeLabelSize.height);
    
    if(pin.type == kPintypeAnalog){
        _modeView = [self labelWithFrame:typeLabelFrame text:@"Analog input"];
        
    } else {
        
        if(pin.mode == kPinModeDigitalInput){
            _modeView = [self labelWithFrame:typeLabelFrame text:@"Digital input"];
        } else if(pin.mode== kPinModeBuzzer){
            _modeView = [self labelWithFrame:typeLabelFrame text:@"Buzzer"];
        } else if(pin.mode == kPinModeCompass){
            _modeView = [self labelWithFrame:typeLabelFrame text:@"Compass"];
        } else if(pin.isPWM){
            
            _segmentedControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Digital", @"PWM", nil]];
            
            CGRect segmentedControlFrame = CGRectMake(typeLabelFrame.origin.x, kLilypadPropertyInnerPadding, kLilypadPropertySegmentedSize.width, kLilypadPropertySegmentedSize.height);
            _segmentedControl.frame = segmentedControlFrame;
            if(realPin.mode == kPinModeDigitalOutput){
                _segmentedControl.selectedSegmentIndex = 0;
            } else if(realPin.mode == kPinModePWM || realPin.mode == kPinModeBuzzer){
                _segmentedControl.selectedSegmentIndex = 1;
            }
            
            _modeView = _segmentedControl;
            
            [_segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:)
                        forControlEvents:UIControlEventValueChanged];
        }
        
        /*
        THElementPinEditable * elementPin = [pin.attachedPins objectAtIndex:0];
        if(elementPin.hardware.isInputObject){
            _modeView = [self labelWithFrame:typeLabelFrame text:@"Digital input"];
        } else if(realPin.isPWM){
            
            _segmentedControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Digital", @"PWM", nil]];
            
            CGRect segmentedControlFrame = CGRectMake(typeLabelFrame.origin.x, kLilypadPropertyInnerPadding, kLilypadPropertySegmentedSize.width, kLilypadPropertySegmentedSize.height);
            _segmentedControl.frame = segmentedControlFrame;
            if(realPin.mode == kPinModeDigitalOutput){
                _segmentedControl.selectedSegmentIndex = 0;
            } else if(realPin.mode == kPinModePWM || realPin.mode == kPinModeBuzzer){
                _segmentedControl.selectedSegmentIndex = 1;
            }
            
            _modeView = _segmentedControl;
            
            [_segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:)
                        forControlEvents:UIControlEventValueChanged];
        } else {
            
            _modeView = [self labelWithFrame:typeLabelFrame text:@"Digital output"];
        }*/
    }
    
    [self addSubview:_modeView];
}

-(void) segmentedControlValueChanged:(UISegmentedControl*) control{
    THBoardPin * pin = (THBoardPin*) self.pin.simulableObject;
    if(control.selectedSegmentIndex == 0){
        pin.mode = kPinModeDigitalOutput;
    } else {
        THElementPinEditable * elementPin = [pin.attachedPins objectAtIndex:0];
        if(elementPin.defaultBoardPinMode == kPinModeBuzzer){
            pin.mode = kPinModeBuzzer;
        } else {
            pin.mode = kPinModePWM;
        }
    }
    //NSLog(@"seting mode: %@",kPinModeTexts[pin.mode]);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1.0f;
        // Initialization code
        
    }
    return self;
}


@end
