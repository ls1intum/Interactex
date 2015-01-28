//
//  THRecorder.m
//  TangoHapps
//
//  Created by Guven Candogan on 26/01/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THRecorder.h"

@implementation THRecorder

@synthesize buffer = _buffer;
@synthesize recording = _recording;
@synthesize isRecordDone = _isRecordDone;

float const kRecorderButtonWidth = 30;
float const kRecorderButtonHeight = 30;
float const kRecorderVolumeViewWidth = 150;
float const kRecorderVolumeViewHeight = 30;
float const kRecorderLabelHeight = 40;
float const kRecorderInnerPadding = 10;

NSString * const kStartImageName = @"musicPlay.png";
NSString * const kStopImageName = @"pause.png";

#pragma mark - Initializing

-(id) init{
    
    self = [super init];
    if(self){
        self.width = 260;
        self.height = 140;
        
        [self initVariables];
        
        [self loadRecorder];
        
    }
    
    return self;
}

-(void) initVariables{
    
    _recording = NO;
    _isRecordDone = NO;
    
    self.text = @"";

}


-(void) loadRecorderViews{
    UIView * containerView = [[UIView alloc] init];
    containerView.bounds = CGRectMake(0, 0, self.width, self.height);
    containerView.layer.cornerRadius = 5.0f;
    containerView.layer.borderWidth = 1.0f;
    self.view = containerView;
    
    UIImage * image =  [UIImage imageNamed:@"recording"];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame= CGRectMake(5, 5, image.size.width, image.size.height);
    [containerView addSubview:imageView];
    
    _label = [[UILabel alloc] init];
    _label.layer.borderWidth = 1.0f;
    CGRect imageFrame = imageView.frame;
    float x = imageFrame.origin.x + imageFrame.size.width + kRecorderInnerPadding;
    _label.frame = CGRectMake(x, 5, self.width - imageFrame.size.width - 20, kRecorderLabelHeight);
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:12];
    _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    [containerView addSubview:_label];
    
    CGRect startButtonFrame = CGRectMake(120, _label.frame.origin.y + _label.frame.size.height + kRecorderInnerPadding, kRecorderButtonWidth, kRecorderButtonHeight);
    _startButton = [self buttonWithFrame:startButtonFrame imageName:kStartImageName];
    [_startButton addTarget:self action:@selector(togglePlay) forControlEvents:UIControlEventTouchDown];
    
    CGRect sendButtonFrame = CGRectMake(180, _label.frame.origin.y + _label.frame.size.height + kRecorderInnerPadding, kRecorderButtonWidth, kRecorderButtonHeight);
    _sendButoon = [self buttonWithFrame:sendButtonFrame imageName:@"forward.png"];
    [_sendButoon addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchDown];
    _sendButoon.userInteractionEnabled = NO; // ****
    [_sendButoon setAlpha:0.5];
    
    [self.view addSubview:_startButton];
    [self.view addSubview:_sendButoon];
    
}

-(void) loadRecorder{
    
    [self loadRecorderViews];
    
    TFProperty * property = [TFProperty propertyWithName:@"buffer" andType:kDataTypeAny];
    self.properties = [NSMutableArray arrayWithObject:property];
    
    TFMethod * method1 = [TFMethod methodWithName:@"start"];
    TFMethod * method2 = [TFMethod methodWithName:@"stop"];
    TFMethod * method3 = [TFMethod methodWithName:@"send"];
    TFMethod * method4 = [TFMethod methodWithName:@"appendData"];
    method4.firstParamType = kDataTypeInteger;
    method4.numParams = 1;
    
    self.methods = [NSMutableArray arrayWithObjects:method1, method2, method3, method4, nil];
    
    
    [self registerEvents];
    
}

-(UIButton*) buttonWithFrame:(CGRect) frame imageName:(NSString*) name{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = frame;
    UIImage * playImage = [UIImage imageNamed:name];
    [button setBackgroundImage:playImage forState:UIControlStateNormal];
    button.enabled = NO;
    
    return button;
}

-(void) registerEvents{
    #if !(TARGET_IPHONE_SIMULATOR)
    #endif
}

-(void) reloadView{
    [self loadRecorderViews];
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    [self initVariables];
    
    [self loadRecorder];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
}


#pragma mark - Method
/*
-(void) addValue:(NSInteger) value{
    [self.buffer addObject:[NSNumber numberWithInt:value]];
}*/

-(void) appendData:(id)data{
    [self.buffer addObject:[NSNumber numberWithInt:data]];
}

-(NSMutableArray *) buffer{

    if(_buffer==NULL)
        _buffer= [[NSMutableArray alloc] init];
    
    return _buffer;
}

-(void) toggleStart{
    
    if(_recording){
        [self stop];
    } else {
        [self start];
    }
}

-(void) start{
    _recording = YES;
    _isRecordDone = NO;
    
    [self updateLabel];
    
    if(_startButton != nil){
        UIImage * playImage = [UIImage imageNamed:kStopImageName];
        [_startButton setBackgroundImage:playImage forState:UIControlStateNormal];
    }
}


-(void) stop{
    _recording = NO;
    _isRecordDone = YES;
    _sendButoon.userInteractionEnabled = YES;
    
    [self updateLabel];
    
    if(_startButton != nil){
        UIImage * playImage = [UIImage imageNamed:kStartImageName];
        [_startButton setBackgroundImage:playImage forState:UIControlStateNormal];
    }
}


-(void) send{
    if(_isRecordDone){
        _isRecordDone = NO;
        _sendButoon.userInteractionEnabled = NO;
        [self updateLabel];
        
    }
}

-(void) updateLabel{
    
    if(_recording){
        [self setText:@"Recording!"];
    } else if(_isRecordDone){
        [self setText:@"Send?"];
    } else {
        [self setText:@"Not Recording."];
    }
}

-(void) willStartSimulating{
    _startButton.enabled = YES;
    _sendButoon.enabled = YES;
    _sendButoon.userInteractionEnabled = YES;
    [self updateLabel];
    [_sendButoon setAlpha:1.0];
}

-(void) stopSimulating{
    [self stop];
    [super stopSimulating];
}

-(void) prepareToDie{
    
#if !(TARGET_IPHONE_SIMULATOR)
#endif
    [super prepareToDie];
}
-(void) dealloc{
    [self stop];
}

-(void) setText:(NSString *)text{
    _label.text = text;
}
-(NSString*) text{
    return _label.text;
}

-(NSString*) description{
    return @"Recorder";
}

@end