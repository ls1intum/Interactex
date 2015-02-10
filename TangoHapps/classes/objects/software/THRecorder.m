//
//  THRecorder.m
//  TangoHapps
//
//  Created by Guven Candogan on 26/01/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THRecorder.h"
#import "THLinePlotController.h"

@implementation THRecorder


UIImageView * imageView;
UILabel * label;
UIButton * startButton;
UIButton * openGraphButton;
UIButton * deleteButton;
UIButton * sendButton;
UIButton * thresholdButton;

BOOL recording;
BOOL isRecordDone;
THLinePlotController * plot;

NSMutableArray* processedBuffer;

@synthesize buffer = _buffer;

float const kRecorderButtonWidth = 30;
float const kRecorderButtonHeight = 30;
float const kRecorderLabelHeight = 40;
float const kRecorderInnerPadding = 10;

NSString * const kStartImageName = @"musicPlay.png";
NSString * const kStopImageName = @"pause.png";
NSString * const kRecordImageName = @"recording";
NSString * const kPushImageName = @"push.png";
NSString * const kOpenGraphImageName = @"graph.png";
NSString * const kDeleteImageName = @"delete.png";
NSString * const kThresholdImageName = @"threshold.png";

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
    
    recording = NO;
    isRecordDone = NO;
    
    [self updateLabel];
}

-(void) loadRecorderViews{
    UIView * containerView = [[UIView alloc] init];
    containerView.bounds = CGRectMake(0, 0, self.width, self.height);
    containerView.layer.cornerRadius = 5.0f;
    containerView.layer.borderWidth = 1.0f;
    self.view = containerView;
    
    UIImage * image =  [UIImage imageNamed:kRecordImageName];
    imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame= CGRectMake(5, 5, image.size.width, image.size.height);
    [self.view addSubview:imageView];
    
    label = [[UILabel alloc] init];
    label.layer.borderWidth = 1.0f;
    CGRect imageFrame = imageView.frame;
    float x = imageFrame.origin.x + imageFrame.size.width + kRecorderInnerPadding;
    label.frame = CGRectMake(x, 5, self.width - imageFrame.size.width - 20, kRecorderLabelHeight);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:label];
    
    CGRect deleteButtonFrame = CGRectMake(50+kRecorderButtonWidth+kRecorderInnerPadding, label.frame.origin.y-10, 3*kRecorderButtonWidth, 3*kRecorderButtonHeight);
    deleteButton = [self buttonWithFrame:deleteButtonFrame imageName:kDeleteImageName];
    [deleteButton addTarget:self action:@selector(deleteGraph) forControlEvents:UIControlEventTouchDown];
    
    CGRect sendButtonFrame = CGRectMake(20, label.frame.origin.y -10, 3*kRecorderButtonWidth, 3*kRecorderButtonHeight);
    sendButton = [self buttonWithFrame:sendButtonFrame imageName:kPushImageName];
    [sendButton addTarget:self action:@selector(sendGraph) forControlEvents:UIControlEventTouchDown];
    
    CGRect thresholdButtonFrame = CGRectMake(185, label.frame.origin.y +20,kRecorderButtonWidth, kRecorderButtonHeight);
    thresholdButton = [self buttonWithFrame:thresholdButtonFrame imageName:kThresholdImageName];
    [thresholdButton addTarget:self action:@selector(applyThreshold) forControlEvents:UIControlEventTouchDown];
    
    CGRect startButtonFrame = CGRectMake(120, label.frame.origin.y + label.frame.size.height + kRecorderInnerPadding, kRecorderButtonWidth, kRecorderButtonHeight);
    startButton = [self buttonWithFrame:startButtonFrame imageName:kStartImageName];
    [startButton addTarget:self action:@selector(toggleStart) forControlEvents:UIControlEventTouchDown];
    
    CGRect openGraphButtonFrame = CGRectMake(170, label.frame.origin.y + label.frame.size.height + kRecorderInnerPadding, kRecorderButtonWidth, kRecorderButtonHeight);
    openGraphButton = [self buttonWithFrame:openGraphButtonFrame imageName:kOpenGraphImageName];
    [openGraphButton addTarget:self action:@selector(openGraph) forControlEvents:UIControlEventTouchDown];

   /* _plotView = [[UIView alloc] init];
    _plotView.bounds = CGRectMake(-125, -180, self.width+15, self.height-kRecorderButtonHeight-label.frame.size.height+10);
    */
    [self setFirstPage];
    startButton.enabled = NO;
    
    [self.view addSubview:thresholdButton];
    [self.view addSubview:deleteButton];
    [self.view addSubview:sendButton];
    [self.view addSubview:startButton];
    [self.view addSubview:openGraphButton];
    
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

-(void)applyThreshold{
    if(!plot)
        return;
    
    NSMutableArray * selected = [plot getMarkedPoints];
    if(selected.count !=1)
        return;
    
    int threshold = [selected objectAtIndex:0];
    processedBuffer = [[NSMutableArray alloc] init];
    
    for(int i = 0; i<self.buffer.count; i++){
        if(threshold >= (NSInteger )self.buffer[i])
            [processedBuffer addObject:self.buffer[i]];
    }
    
    plot = nil;
    
    plot = [[THLinePlotController alloc] initWithView:self.view withData:processedBuffer];
    [self setSecondPage];
    
}

-(void) toggleStart{
    
    if(recording){
        [self stop];
    } else {
        [self start];
    }
}

-(void) start{
    recording = YES;
    isRecordDone = NO;
    
    [self updateLabel];
    
    [self setFirstPage];
    
    if(startButton != nil){
        UIImage * playImage = [UIImage imageNamed:kStopImageName];
        [startButton setBackgroundImage:playImage forState:UIControlStateNormal];
    }
}

-(void) stop{
    recording = NO;
    isRecordDone = YES;
    
    [self updateLabel];
    
    openGraphButton.enabled = YES;
    [openGraphButton setAlpha:1.0];
    
    if(startButton != nil){
        UIImage * playImage = [UIImage imageNamed:kStartImageName];
        [startButton setBackgroundImage:playImage forState:UIControlStateNormal];
    }
}

-(void) openGraph{

    //plot = [[THLinePlotController alloc] initWithView:self.view withData:self.buffer];
    plot = [[THLinePlotController alloc] initWithView:self.view withData:nil];
    
    [self setSecondPage];
}

-(void)deleteGraph{
    
    if(plot)
        plot =nil;
    
    [self setFirstPage];
    
    openGraphButton.enabled = YES;
    [openGraphButton setAlpha:1.0];
}

-(void) sendGraph{
    /*
     [self openGraph];
     
     if(isRecordDone){
     isRecordDone = NO;
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
    if(recording)
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
    
    thresholdButton.enabled = NO;
    [thresholdButton setAlpha:0.0];
    
    openGraphButton.enabled = NO;
    [openGraphButton setAlpha:0.0];
    
    startButton.enabled = YES;
    [startButton setAlpha:1.0];
    
    label.enabled = YES;
    [label setAlpha:1.0];
    
    deleteButton.enabled = NO;
    [deleteButton setAlpha:0.0];
    
    sendButton.enabled = NO;
    [sendButton setAlpha:0.0];
    
    [imageView setAlpha:1.0];
}

-(void) setSecondPage{
    
    thresholdButton.enabled = YES;
    [thresholdButton setAlpha:1.0];
    
    openGraphButton.enabled = NO;
    [openGraphButton setAlpha:0.0];
    
    startButton.enabled = NO;
    [startButton setAlpha:0.0];
    
    label.enabled = NO;
    [label setAlpha:0.0];
    
    deleteButton.enabled = YES;
    [deleteButton setAlpha:1.0];
    
    sendButton.enabled = YES;
    [sendButton setAlpha:1.0];
    
    [imageView setAlpha:0.0];
}

-(void) sendInformation{ //TODO
}

-(void) updateLabel{
    
    if(recording){
        [self setText:@"Recording!"];
    } else if(isRecordDone){
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
    label.text = text;
}

-(NSString*) text{
    return label.text;
}

-(NSString*) description{
    return @"Recorder";
}

-(void) willStartSimulating{
    startButton.enabled = YES;
    openGraphButton.enabled = YES;
    [self updateLabel];
}

-(void) stopSimulating{
    startButton.enabled = NO;
    openGraphButton.enabled = NO;
    sendButton.enabled = NO;
    deleteButton.enabled = NO;
    [self stop];
    [super stopSimulating];
}

@end