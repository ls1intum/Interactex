//
//  THGraphViewSegment.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/02/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kGraphSegmentSize 33

@interface THGraphViewSegment : NSObject
{
	// Need 33 values to fill 32 pixel width.
	float xhistory[kGraphSegmentSize];
	float yhistory[kGraphSegmentSize];
    
    BOOL isFilled[kGraphSegmentSize][2];
    CGPoint lines[(kGraphSegmentSize-1)*2];
    
	int index;
}

- (id)initWithHeight:(float) height;

// returns true if adding this value fills the segment, which is necessary for properly updating the segments
- (BOOL)addX:(float)x;

// When this object gets recycled (when it falls off the end of the graph)
// -reset is sent to clear values and prepare for reuse.
- (void)reset;

// Returns true if this segment has consumed 32 values.
- (BOOL)isFull;

// Returns true if the layer for this segment is visible in the given rect.
- (BOOL)isVisibleInRect:(CGRect)r;

// The layer that this segment is drawing into
@property(nonatomic, readonly) CALayer *layer;
@property(nonatomic) float height;

@end