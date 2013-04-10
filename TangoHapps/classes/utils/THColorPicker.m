
#import "THColorPicker.h"
#import <QuartzCore/QuartzCore.h>

static NSUInteger shades = 8;
static NSUInteger hues = 10;
static CGFloat buttonSize = 44.0f;
static CGFloat topOffset = 88.0f;

@implementation THColorPicker

-(id)init {
    self = [super initWithNibName:@"THColorPicker" bundle:nil];
    if(self){
        swatches = [NSMutableArray array];
        [self updateSwatches];
    }
    return self;
}

- (void)updateSwatches {
    for(UIView *swatch in swatches)
        [swatch removeFromSuperview];
    [swatches removeAllObjects];
    for(int y = 0; y <= hues; y++){
        for(int x = 0; x < shades; x++){
            UIColor *color;
            if(y == hues){
                // Grayscale row
                float brightness = ((float)x / (float)shades);
                color = [UIColor colorWithHue:0.0f
                                   saturation:0.0f
                                   brightness:brightness
                                        alpha:alphaSlider.value];
            }else{
                // Color rows
                float hue = ((float)y / (float)hues);
                float brightness = (((float)x + 4.0f) / ((float)shades + 4.0f));
                color = [UIColor colorWithHue:hue 
                                   saturation:saturationSlider.value
                                   brightness:brightness
                                        alpha:alphaSlider.value];
            }
            UIButton *swatch = [UIButton buttonWithType:UIButtonTypeCustom];
            [swatch setBackgroundColor:color];
            swatch.layer.cornerRadius = 4.0f;
            swatch.layer.borderWidth = 1.0f;
            swatch.layer.borderColor = [[UIColor colorWithWhite:1.0f alpha:0.5f] CGColor];
            CGRect frame = CGRectMake(x * (buttonSize + 8) + 8,
                                      y * (buttonSize + 8) + 8 + topOffset, buttonSize, buttonSize);
            [self.view addSubview:swatch];
            [swatch setFrame:frame];
            [swatch addTarget:self action:@selector(swatchTapped:) forControlEvents:UIControlEventTouchDown];
            [swatches addObject:swatch];
        }
    }
}

-(CGSize)contentSizeForViewInPopover
{
    return CGSizeMake(shades * (buttonSize + 8) + 8 + 8,
                      (hues + 1) * (buttonSize + 8) + 8 + 8 + topOffset);
}

- (IBAction)swatchTapped:(id)sender
{
    UIButton *swatch = (UIButton*)sender;
    UIColor *color = [swatch backgroundColor];
    [_delegate colorPicker:self didPickColor:color];
}

-(void)sliderChanged:(id)sender
{
    [self updateSwatches];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIDeviceOrientationLandscapeRight);
}

@end
