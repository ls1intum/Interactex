//
//  THRecorder.h
//  TangoHapps
//
//  Created by Guven Candogan on 26/01/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THView.h"

@interface THRecorder : THView
{
    UILabel * _label;
    UIButton * _startButton;
    UIButton * _sendButoon;
    
    BOOL _recording;
    BOOL _isRecordDone;
}

@property (nonatomic) NSMutableArray* buffer;

-(void) start;
-(void) stop;
-(void) send;
-(void) appendData:(NSInteger) data;
@end