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

float const kRecorderButtonWidth = 30;
float const kRecorderButtonHeight = 30;
float const kRecorderLabelHeight = 40;
float const kRecorderInnerPadding = 10;

NSString * const kStartImageName = @"musicPlay.png";
NSString * const kStopImageName = @"pause.png";
NSString * const kRecordImageName = @"recording";
NSString * const kPushImageName = @"push.png";
NSString * const kOpenGraphImageName = @"duplicate@2x.png";
NSString * const kDeleteImageName = @"delete.png";

#pragma mark - Initializing

-(id) init{
    
    self = [super init];
    if(self){
        self.width = 250;
        self.height = 370;
        
        [self loadRecorder];
        
    }
    
    return self;
}

-(void) initVariables{
    
    _recording = NO;
    _isRecordDone = NO;
    
    [self updateLabel];
}

-(void) loadRecorderViews{
    UIView * containerView = [[UIView alloc] init];
    containerView.bounds = CGRectMake(0, 0, self.width, self.height);
    containerView.layer.cornerRadius = 5.0f;
    containerView.layer.borderWidth = 1.0f;
    self.view = containerView;
    
    UIImage * image =  [UIImage imageNamed:kRecordImageName];
    _imageView = [[UIImageView alloc] initWithImage:image];
    _imageView.frame= CGRectMake(5, 5, image.size.width, image.size.height);
    [self.view addSubview:_imageView];
    
    _label = [[UILabel alloc] init];
    _label.layer.borderWidth = 1.0f;
    CGRect imageFrame = _imageView.frame;
    float x = imageFrame.origin.x + imageFrame.size.width + kRecorderInnerPadding;
    _label.frame = CGRectMake(x, 5, self.width - imageFrame.size.width - 20, kRecorderLabelHeight);
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:12];
    _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:_label];
    
    CGRect deleteButtonFrame = CGRectMake(110+kRecorderButtonWidth+kRecorderInnerPadding, _label.frame.origin.y -10, 3*kRecorderButtonWidth, 3*kRecorderButtonHeight);
    _deleteButton = [self buttonWithFrame:deleteButtonFrame imageName:kDeleteImageName];
    [_deleteButton addTarget:self action:@selector(deleteGraph) forControlEvents:UIControlEventTouchDown];
    
    CGRect sendButtonFrame = CGRectMake(30, _label.frame.origin.y -10, 3*kRecorderButtonWidth, 3*kRecorderButtonHeight);
    _sendButton = [self buttonWithFrame:sendButtonFrame imageName:kPushImageName];
    [_sendButton addTarget:self action:@selector(sendGraph) forControlEvents:UIControlEventTouchDown];
    
    CGRect startButtonFrame = CGRectMake(120, _label.frame.origin.y + _label.frame.size.height + kRecorderInnerPadding, kRecorderButtonWidth, kRecorderButtonHeight);
    _startButton = [self buttonWithFrame:startButtonFrame imageName:kStartImageName];
    [_startButton addTarget:self action:@selector(toggleStart) forControlEvents:UIControlEventTouchDown];
    
    CGRect openGraphButtonFrame = CGRectMake(170, _label.frame.origin.y + _label.frame.size.height + kRecorderInnerPadding, kRecorderButtonWidth, kRecorderButtonHeight);
    _openGraphButton = [self buttonWithFrame:openGraphButtonFrame imageName:kOpenGraphImageName];
    [_openGraphButton addTarget:self action:@selector(openGraph) forControlEvents:UIControlEventTouchDown];

   /* _plotView = [[UIView alloc] init];
    _plotView.bounds = CGRectMake(-125, -180, self.width+15, self.height-kRecorderButtonHeight-_label.frame.size.height+10);
    */
    [self setFirstPage];
    _startButton.enabled = NO;
    
    //[self.view addSubview:_plotView];
    [self.view addSubview:_deleteButton];
    [self.view addSubview:_sendButton];
    [self.view addSubview:_startButton];
    [self.view addSubview:_openGraphButton];
    
}

-(void) loadRecorder{
    
    [self loadRecorderViews];
    
    TFProperty * property = [TFProperty propertyWithName:@"buffer" andType:kDataTypeAny];
    self.properties = [NSMutableArray arrayWithObject:property];
    /*
    TFMethod * method1 = [TFMethod methodWithName:@"start"];
    TFMethod * method2 = [TFMethod methodWithName:@"stop"];
    TFMethod * method3 = [TFMethod methodWithName:@"send"];
    TFMethod * method4 = [TFMethod methodWithName:@"appendData"];
    method4.firstParamType = kDataTypeInteger;
    method4.numParams = 1;
    
    self.methods = [NSMutableArray arrayWithObjects:method1, method2, method3, method4, nil];
    */
    
    TFMethod * method = [TFMethod methodWithName:@"appendData"];
    method.firstParamType = kDataTypeInteger;
    method.numParams = 1;
    
    self.methods = [NSMutableArray arrayWithObjects:method, nil];
    
    [self initVariables];
    
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

#pragma mark - UI functions

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
    
    [self setFirstPage];
    
    if(_startButton != nil){
        UIImage * playImage = [UIImage imageNamed:kStopImageName];
        [_startButton setBackgroundImage:playImage forState:UIControlStateNormal];
    }
}

-(void) stop{
    _recording = NO;
    _isRecordDone = YES;
    
    [self updateLabel];
    
    _openGraphButton.enabled = YES;
    [_openGraphButton setAlpha:1.0];
    
    if(_startButton != nil){
        UIImage * playImage = [UIImage imageNamed:kStartImageName];
        [_startButton setBackgroundImage:playImage forState:UIControlStateNormal];
    }
}

-(void) openGraph{

    //plot = [[THLinePlotController alloc] initWithView:self.view withData:buffer];
    plot = [[THLinePlotController alloc] initWithView:self.view withData:nil];
    
    [self setSecondPage];
}

-(void)deleteGraph{
    
    if(plot)
        plot =nil;
    
    [self setFirstPage];
}

-(void) sendGraph{
    /*
     [self openGraph];
     
     if(_isRecordDone){
     _isRecordDone = NO;
     [_openGraph setAlpha:0.0];
     [self updateLabel];
     [self sendInformation];
     }*/
    
    NSMutableArray * selected = [plot getMarkedPoints];
    NSLog(@"%@", selected);
    
    [self deleteGraph];
    
    //ToDo
    //process the selested ones with older data
    
}

#pragma mark - Method

-(void) appendData:(NSInteger)data{
    if(_recording)
        [self.buffer addObject:[NSNumber numberWithInt:data]];
}

-(UIButton*) buttonWithFrame:(CGRect) frame imageName:(NSString*) name{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = frame;
    UIImage * playImage = [UIImage imageNamed:name];
    [button setBackgroundImage:playImage forState:UIControlStateNormal];
    button.enabled = NO;
    
    return button;
}

-(void) setFirstPage{
    _openGraphButton.enabled = NO;
    [_openGraphButton setAlpha:0.0];
    
    _startButton.enabled = YES;
    [_startButton setAlpha:1.0];
    
    _label.enabled = YES;
    [_label setAlpha:1.0];
    
    _deleteButton.enabled = NO;
    [_deleteButton setAlpha:0.0];
    
    _sendButton.enabled = NO;
    [_sendButton setAlpha:0.0];
    
    [_imageView setAlpha:1.0];
}

-(void) setSecondPage{
    _openGraphButton.enabled = NO;
    [_openGraphButton setAlpha:0.0];
    
    _startButton.enabled = NO;
    [_startButton setAlpha:0.0];
    
    _label.enabled = NO;
    [_label setAlpha:0.0];
    
    _deleteButton.enabled = YES;
    [_deleteButton setAlpha:1.0];
    
    _sendButton.enabled = YES;
    [_sendButton setAlpha:1.0];
    
    [_imageView setAlpha:0.0];
}

-(void) sendInformation{ //TODO
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

#pragma mark - Protocol functions

-(void) prepareToDie{
    [super prepareToDie];
}

-(void) dealloc{
    [self stop];
}

#pragma mark - Getter-Setter

-(NSMutableArray *) buffer{
    
    if(_buffer==NULL)
        _buffer= [[NSMutableArray alloc] init];
    
    return _buffer;
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

-(void) willStartSimulating{
    _startButton.enabled = YES;
    _openGraphButton.enabled = YES;
    [self updateLabel];
}

-(void) stopSimulating{
    _startButton.enabled = NO;
    _openGraphButton.enabled = NO;
    _sendButton.enabled = NO;
    _deleteButton.enabled = NO;
    [self stop];
    [super stopSimulating];
}

@end