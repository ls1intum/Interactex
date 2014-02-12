
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class THGraphViewSegment;
@class THGraphTextView;

@interface THGraphView : UIView
{
    
}

- (id)initWithFrame:(CGRect)frame maxAxisY:(float) maxAxisY minAxisY:(float) minAxisY ;
- (void)addX:(float)x;

@property (nonatomic) float maxAxisY;
@property (nonatomic) float minAxisY;
@property (nonatomic) float speed;//in pixels
@property (nonatomic) BOOL should;

@property (nonatomic, strong) NSMutableArray *segments;

@property (nonatomic, unsafe_unretained) THGraphViewSegment * currentSegment;
@property (nonatomic) THGraphTextView *text;

@end

