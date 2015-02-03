//
//  THRecorder.h
//  TangoHapps
//
//  Created by Guven Candogan on 26/01/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THView.h"
#import "THLinePlotController.h"

@interface THRecorder : THView
{
    UIImageView * _imageView;
    UILabel * _label;
    UIButton * _startButton;
    UIButton * _openGraphButton;
    UIButton * _deleteButton;
    UIButton * _sendButton;
    //UIView * _plotView;
    
    BOOL _recording;
    BOOL _isRecordDone;
    THLinePlotController *plot;
}

@property (nonatomic) NSMutableArray* buffer;
/*
-(void) start;
-(void) stop;
-(void) send;
*/
-(void) appendData:(NSInteger) data;
@end