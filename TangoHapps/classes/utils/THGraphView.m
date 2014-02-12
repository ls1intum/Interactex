
#import "THGraphView.h"
#import "THGraphTextView.h"
#import "THGraphViewHelper.h"
#import "THGraphViewSegment.h"

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
	if (self != nil) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit {
    
    CGRect frame = CGRectMake(0.0, 0.0, kGraphViewLeftAxisWidth, self.frame.size.height);
    
	_text = [[THGraphTextView alloc] initWithFrame:frame maxAxisY: self.maxAxisY minAxisY:self.minAxisY];
	[self addSubview:self.text];
    
	_segments = [[NSMutableArray alloc] init];
	self.currentSegment = [self addSegment];
    
    self.speed = 1.0f;
}

-(void) setMaxAxisY:(float)maxAxisY{
    self.text.maxAxisY = maxAxisY;
}

-(void) setMinAxisY:(float)minAxisY{
    self.text.minAxisY = minAxisY;
}

- (void)addX:(float)x{
    
	if ([self.currentSegment addX:x]) {
		[self recycleSegment];
		[self.currentSegment addX:x];
	}
    
	for (THGraphViewSegment *s in self.segments) {
		CGPoint position = s.layer.position;
		position.x += 1.0;
		s.layer.position = position;
	}
}

- (THGraphViewSegment*) addSegment{

	THGraphViewSegment *segment = [[THGraphViewSegment alloc] initWithHeight:self.frame.size.height];
    segment.layer.borderWidth = 1.0f;
    
	[self.segments insertObject:segment atIndex:0];
	[self.layer insertSublayer:segment.layer below:self.text.layer];
	segment.layer.position = CGPointMake(kGraphViewLeftAxisWidth - segment.layer.frame.size.width/2, self.frame.size.height/2);
    
	return segment;
}

- (void)recycleSegment{
	THGraphViewSegment *last = [self.segments lastObject];
    
	if ([last isVisibleInRect:self.layer.bounds]) {

		self.currentSegment = [self addSegment];
        
	} else {

		[last reset];
        
        last.layer.position = CGPointMake(kGraphViewLeftAxisWidth - last.layer.frame.size.width/2, self.frame.size.height/2);
		[self.segments insertObject:last atIndex:0];
		[self.segments removeLastObject];
		self.currentSegment = last;
	}
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	// Fill in the background
	CGContextSetFillColorWithColor(context, graphBackgroundColor());
	CGContextFillRect(context, self.bounds);

    StrokeAllLinesForFrameWithHeight(context, self.bounds.size.height,self.bounds.size.width);
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
