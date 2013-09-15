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

#import "THPaletteItem.h"

@class THCustomPaletteItem;
@class THPaletteItem;
@class THPalette;

@protocol THPaletteDragDelegate <NSObject>
-(void)palette:(THPalette*)palette didStartDraggingItem:(THPaletteItem*)item withRecognizer:(UIPanGestureRecognizer*)recognizer;
-(void)palette:(THPalette*)palette didDragItem:(THPaletteItem*)item withRecognizer:(UIPanGestureRecognizer*)recognizer;
-(void)palette:(THPalette*)palette didDropItem:(THPaletteItem*)item withRecognizer:(UIPanGestureRecognizer*)recognizer;
-(void)palette:(THPalette*)palette didLongPressItem:(THPaletteItem*)item withRecognizer:(UILongPressGestureRecognizer*)recognizer;
-(void) didTapPalette:(THPalette*) palette;
@end

@protocol THPaletteEditionDelegate <NSObject>
-(void)palette:(THPalette*)palette didRemoveItem:(THCustomPaletteItem*)item;
-(void)palette:(THPalette*)palette didSelectItem:(THCustomPaletteItem*)item;
@end

@protocol TFPaletteSizeDelegate <NSObject>
-(void) palette:(THPalette*) palette didChangeSize:(CGSize) newSize;
@end

@interface THPalette : UIScrollView
< TFPaletteItemDelegate>
{
    NSMutableArray * _paletteItems;
    UIImageView * _dragView;
    THPaletteItem * _tempPaletteItem;
}

@property (nonatomic,weak) id<THPaletteDragDelegate> dragDelegate;
@property (nonatomic,weak) id<THPaletteEditionDelegate> editionDelegate;
@property (nonatomic,weak) id<TFPaletteSizeDelegate> sizeDelegate;
@property (nonatomic) BOOL editing;

//adding, removing, searching palette items
-(void)addPaletteItem:(THPaletteItem*)paletteItem;
-(void)addDragablePaletteItem:(THPaletteItem*)paletteItem;
-(THPaletteItem*)paletteItemAtIndex:(NSInteger)index;
-(THPaletteItem*)paletteItemAtLocation:(CGPoint)location;
-(void) removePaletteItem:(THPaletteItem*) paletteItem;
-(void)removeAllPaletteItems;

//temporary palette item
-(void) temporaryAddPaletteItem:(THPaletteItem*) paletteItem;
-(void) removeTemporaryPaletteItem;

-(void)dragItem:(UIPanGestureRecognizer*)sender;
-(void)resizeToFitContents;

@end
