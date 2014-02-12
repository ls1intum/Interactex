/*
     File: GraphView.m
 Abstract: Displays a graph of accelerometer output using. This class uses Core Animation techniques to avoid needing to render the entire graph every update
  Version: 2.6
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 */

#import "THGraphView.h"
#import "THGraphTextView.h"
#import "THGraphViewHelper.h"
#import "THGraphViewSegment.h"

@interface THGraphView()

// Internal accessors
@property (nonatomic, strong) NSMutableArray *segments;
@property (nonatomic, unsafe_unretained) THGraphViewSegment *current;
@property (nonatomic) THGraphTextView *text;

// A common init routine for use with -initWithFrame: and -initWithCoder:
- (void)commonInit;

// Creates a new segment, adds it to 'segments', and returns a weak reference to that segment
// Typically a graph will have around a dozen segments, but this depends on the width of the graph view and segments
- (THGraphViewSegment *)addSegment;

// Recycles a segment from 'segments' into  'current'
- (void)recycleSegment;

@end

#pragma mark -

@implementation THGraphView

float const kGraphViewOffsetX = 10.0f;
float const kGraphViewLeftAxisWidth = 42.0;

// Designated initializer
- (id)initWithFrame:(CGRect)frame maxAxisY:(float) maxAxisY minAxisY:(float) minAxisY {
    
	self = [super initWithFrame:frame];
	if (self != nil) {
        
        _maxAxisY = maxAxisY;
        _minAxisY = minAxisY;
        
		[self commonInit];
	}
	return self;
}

// Designated initializer
- (id)initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder:decoder];
	if (self != nil)
	{
		[self commonInit];
	}
	return self;
}

- (void)commonInit {
	// Create the text view and add it as a subview. We keep a weak reference
	// to that view afterwards for laying out the segment layers.
    //NSLog(@"height here: %f",self.frame.size.height);
    
    CGRect frame = CGRectMake(0.0, 0.0, kGraphViewLeftAxisWidth, self.frame.size.height);
    
	_text = [[THGraphTextView alloc] initWithFrame:frame maxAxisY: self.maxAxisY minAxisY:self.minAxisY];
	[self addSubview:self.text];
	
    //_text.layer.borderWidth = 1.0f;
    //_text.layer.borderColor = [UIColor blackColor].CGColor;
    
	// Create a mutable array to store segments, which is required by -addSegment
	_segments = [[NSMutableArray alloc] init];

	// Create a new current segment, which is required by -addX:y:z and other methods.
	// This is also a weak reference (we assume that the 'segments' array will keep the strong reference).
	self.current = [self addSegment];
}

-(void) setMaxAxisY:(float)maxAxisY{
    self.text.maxAxisY = maxAxisY;
}

-(void) setMinAxisY:(float)minAxisY{
    self.text.minAxisY = minAxisY;
}

- (void)addX:(float)x{

	if ([self.current addX:x]){
		[self recycleSegment];
		[self.current addX:x];
	}
}

-(void) displaceRight{
    for (THGraphViewSegment *s in self.segments) {
		CGPoint position = s.layer.position;
		position.x += 1.0;
		s.layer.position = position;
	}
}

- (THGraphViewSegment *)addSegment {
	// Create a new segment and add it to the segments array.
	THGraphViewSegment *segment = [[THGraphViewSegment alloc] initWithHeight:self.frame.size.height];
    segment.layer.borderWidth = 1.0f;
    segment.layer.borderColor = [UIColor redColor].CGColor;
    
	// We add it at the front of the array because -recycleSegment expects the oldest segment
	// to be at the end of the array. As long as we always insert the youngest segment at the front
	// this will be true.
	[self.segments insertObject:segment atIndex:0];
	
	// Ensure that newly added segment layers are placed after the text view's layer so that the text view
	// always renders above the segment layer.
	[self.layer insertSublayer:segment.layer below:self.text.layer];
	// Position it properly (see the comment for kSegmentInitialPosition)
	//segment.layer.position = CGPointMake(kGraphViewOffsetX, self.frame.size.height/2);
    
	segment.layer.position = CGPointMake(kGraphViewLeftAxisWidth - segment.layer.frame.size.width/2 - 2, self.frame.size.height/2);
    
	return segment;
}

- (void)recycleSegment
{
	// We start with the last object in the segments array, as it should either be visible onscreen,
	// which indicates that we need more segments, or pushed offscreen which makes it eligable for recycling.
	THGraphViewSegment *last = [self.segments lastObject];
    
	if ([last isVisibleInRect:self.layer.bounds]) {
		// The last segment is still visible, so create a new segment, which is now the current segment
		self.current = [self addSegment];
	}
	else {
		// The last segment is no longer visible, so we reset it in preperation to be recycled.
		[last reset];
        
		// Position it properly (see the comment for kSegmentInitialPosition)
        last.layer.position = CGPointMake(kGraphViewLeftAxisWidth - last.layer.frame.size.width/2 - 2, self.frame.size.height/2);
        
		// Move the segment from the last position in the array to the first position in the array
		// as it is now the youngest segment.
		[self.segments insertObject:last atIndex:0];
		[self.segments removeLastObject];
		// And make it our current segment
		self.current = last;
	}
}

// The graph view itself exists only to draw the background and gridlines. All other content is drawn either into
// the GraphTextView or into a layer managed by a GraphViewSegment.
- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	// Fill in the background
	CGContextSetFillColorWithColor(context, graphBackgroundColor());
	CGContextFillRect(context, self.bounds);
	
	//CGFloat width = self.bounds.size.width;
	//CGContextTranslateCTM(context, 0.0, 56.0);

	// Draw the grid lines
	//DrawGridlines(context, 0.0, 0, width);
    //NSLog(@"drawing lines in %f %f",self.bounds.size.width,self.bounds.size.height);
    StrokeAllLinesForFrameWithHeight(context, self.bounds.size.height,self.bounds.size.width);
}

-(void) update:(float) dt{
}

// Return an up-to-date value for the graph.
- (NSString *)accessibilityValue {
	if (self.segments.count == 0) {
		return nil;
	}
	
	// Let the GraphViewSegment handle its own accessibilityValue;
	THGraphViewSegment *graphViewSegment = self.segments[0];
	return [graphViewSegment accessibilityValue];
}

@end
