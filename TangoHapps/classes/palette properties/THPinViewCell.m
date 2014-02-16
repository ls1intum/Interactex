//
//  THPinViewCell.m
//  TangoHapps
//
//  Created by Juan Haladjian on 16/02/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THPinViewCell.h"
#import "THBoardPinEditable.h"

@implementation THPinViewCell

#pragma mark - properties

CGSize const frameSize = {215,44};
CGSize const segmentSize = {105,29};

-(id) init {
    self = [super init];
    if(self) {
        
        self.frame = CGRectMake(0, 0, frameSize.width, frameSize.height);
        
        float offsetY = 10;
        float offsetX = 5;
        
        UIFont * font = [UIFont systemFontOfSize:14];
        
        CGRect frame = CGRectMake(offsetX, offsetY, 54, 21);
        self.pinLabel = [[UILabel alloc] initWithFrame:frame];
        self.pinLabel.font = font;
        [self addSubview:self.pinLabel];
        
        frame = CGRectMake(self.pinLabel.frame.origin.x + self.pinLabel.frame.size.width + offsetX, offsetY, 105, 21);
        self.pinInfoLabel = [[UILabel alloc] initWithFrame:frame];
        self.pinInfoLabel.font = font;
        [self addSubview:self.pinInfoLabel];
        
        frame = CGRectMake(self.pinLabel.frame.origin.x + self.pinLabel.frame.size.width + offsetX, (frameSize.height - segmentSize.height) / 2, segmentSize.width, segmentSize.height);
        self.pwmControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Digital", @"PWM", nil]];
        self.pwmControl.frame = frame;
        [self.pwmControl addTarget:self action:@selector(pwmControlChanged:) forControlEvents:UIControlEventValueChanged];
        self.pwmControl.hidden = YES;
        [self addSubview:self.pwmControl];
    }
    return self;
}

-(void) setBoardPin:(THBoardPinEditable *)boardPin {
    
    if(boardPin != _boardPin){
        _boardPin = boardPin;
        
        [self reloadUI];
    }
}

-(void) reloadUI {
    
    self.pinLabel.text = [NSString stringWithFormat:@"PIN %d - ",self.boardPin.number];
    NSString * pintype = [NSString stringWithFormat:@"%@",kPinTexts[self.boardPin.type]];
    self.pinInfoLabel.text = pintype;
    
    if(self.boardPin.type == kPintypeAnalog){
        if(self.boardPin.supportsSCL && self.boardPin.mode == kPinModeI2C){
            self.pinInfoLabel.text = @"SCL";
        } else if(self.boardPin.supportsSDA && self.boardPin.mode == kPinModeI2C){
            self.pinInfoLabel.text = @"SDA";
        } else {
            self.pinInfoLabel.text = @"Analog input";
        }
    } else {
        self.pinInfoLabel.text = @"Digital input";
    }
    
    if(self.boardPin.isPWM){
        self.pwmControl.selectedSegmentIndex = (self.boardPin.mode == kPinModePWM);
        self.pwmControl.hidden = NO;
        self.pinInfoLabel.hidden = YES;
    } else {
        self.pwmControl.hidden = YES;
        self.pinInfoLabel.hidden = NO;
    }
}

#pragma mark - UI interaction

- (void)pwmControlChanged:(id)sender {
    BOOL pwm = (self.pwmControl.selectedSegmentIndex == 1);
    [self.delegate pinViewCell:self didChangePwmStateTo:pwm];
}

@end
