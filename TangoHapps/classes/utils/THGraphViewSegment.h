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
}

- (id)initWithHeight:(float) height;
- (void)addX:(float)x;
- (void)reset;
- (BOOL)isFull;
- (BOOL)isVisibleInRect:(CGRect)r;
- (float) leftmostValue;
-(BOOL) hasFirstValue;

@property(nonatomic, readonly) CALayer *layer;
@property(nonatomic) float height;
@property(nonatomic) NSInteger index;

@end