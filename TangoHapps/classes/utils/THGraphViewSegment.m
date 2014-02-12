//
//  THGraphViewSegment.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/02/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THGraphViewSegment.h"
#import "THGraphViewHelper.h"

@implementation THGraphViewSegment

@synthesize layer;

- (id)initWithHeight:(float) height {
    
	self = [super init];
	if (self != nil) {
        _height = height;
        
		layer = [[CALayer alloc] init];
		layer.delegate = self;
        
        layer.bounds = CGRectMake(0.0, - self.height - kGraphViewGraphOffsetY, kGraphSegmentSize, height);

		layer.opaque = YES;
		self.index = kGraphSegmentSize - 2;
        
	}
	return self;
}

- (void)reset {
	memset(xhistory, 0, sizeof(xhistory));
	memset(yhistory, 0, sizeof(yhistory));
    
    for(int i = 0 ; i < kGraphSegmentSize ; i++){
        isFilled[i][0] = 0;
        isFilled[i][1] = 0;
    }
    
	self.index = kGraphSegmentSize -1;
	[layer setNeedsDisplay];
}

-(BOOL) hasFirstValue{
    return isFilled[0][0];
}

-(float) leftmostValue{
    return xhistory[0];
}
                    
-(BOOL) isFull {
	return index == 0;
}

-(BOOL) isVisibleInRect:(CGRect)r {
   // NSLog(@"%f %f",layer.frame.origin.x + layer.frame.size.width, r.origin.x + r.size.width);
    return (layer.frame.origin.x + layer.frame.size.width) < (r.origin.x + r.size.width) ;
}

-(void) addX:(float)x {
    if(self.index >= 0){
        NSLog(@"filling %d",self.index);
        xhistory[self.index] = x;
        isFilled[self.index][0] = YES;
        [layer setNeedsDisplay];
    }
}

-(void) drawPoints:(float*) array inContext:(CGContextRef)context {
    
    int pointsCount = 0;
    BOOL previousFilled = false;
    
	for (int i = 0; i < kGraphSegmentSize-1; ++i) {
        
        if(isFilled[i][0] && isFilled[i+1][0]){
            
            lines[pointsCount*2].x = i;
            lines[pointsCount*2+1].x = i+1;
            
            lines[pointsCount*2].y = -xhistory[i];
            lines[pointsCount*2+1].y = -xhistory[i+1];
            
            previousFilled = YES;
            pointsCount++;
            
        } else {
            if(previousFilled){
                CGContextSetStrokeColorWithColor(context, graphXColor());
                CGContextStrokeLineSegments(context, lines, pointsCount*2);
                previousFilled = NO;
                pointsCount = 0;
            }
        }
	}
    
    if(previousFilled){
        
        CGContextSetStrokeColorWithColor(context, graphXColor());
        CGContextStrokeLineSegments(context, lines, pointsCount*2);
    }
}

- (void)drawLayer:(CALayer*)l inContext:(CGContextRef)context {

	CGContextSetFillColorWithColor(context, graphBackgroundColor());
	CGContextFillRect(context, layer.bounds);
	
    float height = l.frame.size.height;
    float width = l.frame.size.width;
    
    DrawHorizontalLine(context, 0 , kGraphViewAxisLabelSize.height/2 - height, width);
    DrawHorizontalLine(context, 0 , kGraphViewAxisLabelSize.height/2 - height/2 - kGraphViewGraphOffsetY, width);
    DrawHorizontalLine(context, 0 , -kGraphViewAxisLabelSize.height/2 - 2 * kGraphViewGraphOffsetY, width);
    StrokeLines(context);

    [self drawPoints:xhistory inContext:context];
    
/*
	// Y
	for (i = 0; i < kGraphSegmentSize-1; ++i) {
		lines[i*2].y = -yhistory[i];
		lines[i*2+1].y = -yhistory[i+1];
	}
	CGContextSetStrokeColorWithColor(context, graphYColor());
	CGContextStrokeLineSegments(context, lines, (kGraphSegmentSize-1)*2);*/
}

- (id)actionForLayer:(CALayer *)layer forKey :(NSString *)key {
	// We disable all actions for the layer, so no content cross fades, no implicit animation on moves, etc.
	return [NSNull null];
}

// The accessibilityValue of this segment should be the x,y,z values last added.
- (NSString *)accessibilityValue {
	return [NSString stringWithFormat:NSLocalizedString(@"graphSegmentFormat", @""), xhistory[self.index], yhistory[self.index]];
}

@end
