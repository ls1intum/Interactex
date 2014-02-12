//
//  THGraphTextView.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/02/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THGraphTextView.h"
#import "THGraphViewHelper.h"

#pragma mark -

// We use a seperate view to draw the text for the graph so that we can layer the segment layers below it
// which gives the illusion that the numbers are draw over the graph, and hides the fact that the graph drawing
// for each segment is incomplete until the segment is filled.


#pragma mark -

@implementation THGraphTextView

- (id)initWithFrame:(CGRect)frame maxAxisY:(float) maxAxisY minAxisY:(float) minAxisY {
    self = [super initWithFrame:frame];
    if(self){
        _maxAxisY = maxAxisY;
        _minAxisY = minAxisY;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// Fill in the background
	CGContextSetFillColorWithColor(context, graphBackgroundColor());
	CGContextFillRect(context, self.bounds);
    
	// Draw the grid lines
    float height = self.frame.size.height;
    StrokeAllLinesForFrameWithHeight(context,height,kGraphViewAxisLineWidth);
    
    NSLog(@"height in text %f",height);
    
	// Draw the text
	UIFont *systemFont = [UIFont systemFontOfSize:12.0];
	[[UIColor whiteColor] set];
    
    NSString * topValue = [NSString stringWithFormat:@"%.1f",self.maxAxisY];
    NSString * bottomValue = [NSString stringWithFormat:@"%.1f",self.minAxisY];
    
	[topValue drawInRect:CGRectMake(0.0, kGraphViewGraphOffsetY, kGraphViewAxisLabelSize.width, kGraphViewAxisLabelSize.height) withFont:systemFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
    
	[@" 0.0" drawInRect:CGRectMake(0.0, height/2, kGraphViewAxisLabelSize.width, kGraphViewAxisLabelSize.height) withFont:systemFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
    
	[bottomValue drawInRect:CGRectMake(0.0, height - kGraphViewGraphOffsetY - kGraphViewAxisLabelSize.height, kGraphViewAxisLabelSize.width, kGraphViewAxisLabelSize.height) withFont:systemFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
}

@end
