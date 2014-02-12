
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
    
    self.speed = 1.0f;
}

-(void) setMaxAxisY:(float)maxAxisY{
    self.text.maxAxisY = maxAxisY;
}

-(void) setMinAxisY:(float)minAxisY{
    self.text.minAxisY = minAxisY;
}

- (void)addX:(float)x{

    [self.current addX:x];
}

-(void) displaceRight{

    self.current.index--;
    
    for (THGraphViewSegment *s in self.segments) {
		CGPoint position = s.layer.position;
		position.x += self.speed;
		s.layer.position = position;
	}
    
    if(self.current.index <= 0){
        NSLog(@"gonna check");
        
        THGraphViewSegment * previousSegment = self.current;
        [self recycleSegment];
        
        if([previousSegment hasFirstValue]){
            float value = [previousSegment leftmostValue];
            [self.current addX:value];
        }
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

		self.current = [self addSegment];
        
	} else {

		[last reset];
        
        last.layer.position = CGPointMake(kGraphViewLeftAxisWidth - last.layer.frame.size.width/2, self.frame.size.height/2);
		[self.segments insertObject:last atIndex:0];
		[self.segments removeLastObject];
		self.current = last;
	}
}


- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	// Fill in the background
	CGContextSetFillColorWithColor(context, graphBackgroundColor());
	CGContextFillRect(context, self.bounds);

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
