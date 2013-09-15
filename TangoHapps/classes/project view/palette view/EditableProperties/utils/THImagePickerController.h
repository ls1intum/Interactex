/*
 * TangoFramework
 *
 * Copyright (c) 2012 Juan Haladjian
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import <UIKit/UIKit.h>

@class THImagePickerController;

extern float const kImagePickerPadding;

@protocol TFImagePickerDelegate
- (void)imagePicker:(THImagePickerController*) picker didSelectImage:(UIImage*)image imageName:(NSString*) imageName;
@end

@interface THImagePickerController : UIViewController <UIGestureRecognizerDelegate> {
    
    CGPoint _currentPos;
    NSMutableArray * _images;
    NSMutableArray * _imageNames;
    UIActivityIndicatorView * _activityIndicator;
}

@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIScrollView *imagesContainer;
@property (nonatomic, copy) NSString * imageName;

@property (nonatomic, weak) id<TFImagePickerDelegate> delegate;

- (IBAction) okButtonTapped:(UIButton *)sender;

@end
