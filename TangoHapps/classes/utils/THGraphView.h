
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface THGraphView : UIView

- (id)initWithFrame:(CGRect)frame maxAxisY:(float) maxAxisY minAxisY:(float) minAxisY ;
- (void)addX:(float)x;
- (void) displaceRight;

@property (nonatomic) float maxAxisY;
@property (nonatomic) float minAxisY;
@property (nonatomic) float speed;//in pixels
@property (nonatomic) BOOL should;

@end

