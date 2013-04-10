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

#import <Foundation/Foundation.h>
#import "TFEditable.h"

@class TFPaletteItem;

@protocol TFDroppable <NSObject>
-(BOOL) canBeDroppedAt:(CGPoint) location;
-(void) dropAt:(CGPoint) location;
@end

@protocol TFPaletteItemDelegate <NSObject>
-(void) didTapPaletteItem:(TFPaletteItem*) item;
-(void) didRemovePaletteItem:(TFPaletteItem*) item;
@end

@interface TFPaletteItem : UIView <NSCoding, TFDroppable, UITextFieldDelegate, TFEditable> {
    UIButton * _deleteButton;
    UIView * _container;
    UIImageView * _imageView;
    UILabel * _label;
    UITextField * _textField;
}

@property (nonatomic, readonly) CGPoint center;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * imageName;
@property (nonatomic) UIImage * image;
@property (nonatomic) BOOL editing;
@property (nonatomic) BOOL isEditable;
@property (nonatomic) BOOL selected;
@property (nonatomic, weak) id<TFPaletteItemDelegate> delegate;

-(BOOL) testHit:(CGPoint) location;

+(id) paletteItemWithName:(NSString*) name;
+(id) paletteItemWithName:(NSString*) name imageName:(NSString*) imageName;

-(id)initWithName:(NSString*) name;
-(id)initWithName:(NSString*) name imageName:(NSString*) imageName;

@end
