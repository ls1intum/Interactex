//
//  THGraphViewSegment.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/02/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kGraphSegmentSize 33

@interface THGraphViewSegment : NSObject {
	float xhistory[kGraphSegmentSize];
    
    BOOL isFilled[kGraphSegmentSize];
    CGPoint lines[(kGraphSegmentSize-1)*2];
}

- (id) initWithHeight:(float) height;
- (BOOL) addX:(float)x;
- (void) reset;
- (BOOL) isFull;
- (BOOL) isVisibleInRect:(CGRect)r;
- (void) repeatLast;

@property(nonatomic, readonly) CALayer *layer;
@property(nonatomic) float height;
@property(nonatomic) NSInteger index;

@end