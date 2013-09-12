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

#import "THDraggedPaletteItem.h"

@implementation THDraggedPaletteItem
@dynamic image;

- (id)initWithPaletteItem:(THPaletteItem*) item {
    self = [super init];
    if (self) {
        _item = item;
        _imageView = [[UIImageView alloc] initWithImage:item.image];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setAlpha:kDragViewDefaultOpacity];
        self.frame = _imageView.frame;
        [self addSubview:_imageView];
    }
    return self;
}

-(void) setState:(THPaletteItemState)state{
    if(state != _state){
        _state = state;
        if(_state == kPaletteItemStateDroppable){
            
            UIImage * image = [UIImage imageNamed:@"add"];
            _addImageView = [[UIImageView alloc] initWithImage:image];
            CGRect imageFrame = self.frame;
            _addImageView.center = ccp(imageFrame.size.width,imageFrame.size.height);
            [self addSubview:_addImageView];
            _imageView.alpha = 1.0f;
        } else {
            [_addImageView removeFromSuperview];
            _imageView.alpha = kDragViewDefaultOpacity;
        }
    }
}

-(void) setImage:(UIImage*)image{
    _imageView.image = image;
}

-(UIImage*) image{
    return _imageView.image;
}

-(void) addToView:(UIView*) view{
    //[self removeFromSuperview];
    [view addSubview:self];
}

- (BOOL)canBeDroppedAt:(CGPoint)location {
    return [_item canBeDroppedAt:location];
}

- (void) dropAt:(CGPoint)location
{
    [_item dropAt:location];
}

@end
