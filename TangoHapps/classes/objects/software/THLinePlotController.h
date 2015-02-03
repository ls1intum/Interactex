//
//  THLinePlotController.h
//  TangoHapps
//
//  Created by Guven Candogan on 31/01/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CorePlot-CocoaTouch.h>
#import <THView.h>
//#import <THRecorder.h>

@interface THLinePlotController : THView<CPTPlotAreaDelegate,CPTPlotSpaceDelegate,CPTPlotDataSource,CPTScatterPlotDelegate>
{
    CPTGraphHostingView *_hostingView;
    UIButton *_backButton;
    CPTXYGraph *_graph;
    UIView * _inView;
}

-(NSMutableArray*) getMarkedPoints;
- (void)draw;
-(id) initWithView:(UIView*)view withData:(NSMutableArray *) data;

@end
