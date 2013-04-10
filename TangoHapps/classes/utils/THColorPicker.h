
#import <UIKit/UIKit.h>

@class THColorPicker;

@protocol THColorPickerDelegate <NSObject>
- (void)colorPicker:(THColorPicker*)picker didPickColor:(UIColor*)color;
@end

@interface THColorPicker : UIViewController {
    IBOutlet UISlider *alphaSlider;
    IBOutlet UISlider *saturationSlider;
    NSMutableArray *swatches;
}

@property (weak) id<THColorPickerDelegate> delegate;

- (IBAction)sliderChanged:(id)sender;

@end
