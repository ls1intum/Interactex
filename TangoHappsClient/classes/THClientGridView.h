
#import <UIKit/UIKit.h>
#import "THClientGridItem.h"

@class THClientGridView;

@protocol THClientGridViewDataSource <NSObject>
-(NSUInteger)numberOfItemsInGridView:(THClientGridView*)gridView;
-(THClientGridItem*)gridView:(THClientGridView*)gridView viewAtIndex:(NSUInteger)index;
-(void)gridView:(THClientGridView*)gridView didSelectViewAtIndex:(NSUInteger)index;
-(void)gridView:(THClientGridView*)gridView didDeleteViewAtIndex:(NSUInteger)index;
-(void)gridView:(THClientGridView*)gridView didRenameViewAtIndex:(NSUInteger)index newName:(NSString*)newName;
@end

@protocol THClientGridViewDelegate <NSObject>
-(CGSize) gridItemSizeForGridView:(THClientGridView*) view;
-(CGPoint) gridItemPaddingForGridView:(THClientGridView*) view;
-(CGPoint) gridPaddingForGridView:(THClientGridView*) view;
@end

@interface THClientGridView : UIScrollView <TFClientGridItemDelegate>
{
    CGPoint currentPosition;
}

@property (nonatomic, weak) id<THClientGridViewDataSource> dataSource;
@property (nonatomic, weak) id<THClientGridViewDelegate> gridDelegate;
@property (readonly) NSMutableArray *items;
@property (nonatomic) BOOL editing;

@property (nonatomic) NSInteger columnsCount;
@property (nonatomic) NSInteger rowsCount;

//adding and removing items
-(void) addItem:(THClientGridItem*) item animated:(BOOL) animated;
-(void) insertItem:(THClientGridItem*) item atIndex:(NSInteger)idx animated:(BOOL) animated;
-(void) removeItem:(THClientGridItem*) item animated:(BOOL) animated;
-(void) replaceItem:(THClientGridItem*) item withItem:(THClientGridItem*) newItem;

//finding items
-(THClientGridItem*) itemAtPosition:(CGPoint) position;
-(NSInteger) indexForPosition:(CGPoint) position;
-(CGPoint) positionForIndex:(NSInteger) index;

//editing
-(void) startEditingItem:(THClientGridItem*) item;

-(void) reloadData;
-(void) scrollToBottomAnimated:(BOOL) animated;

@end
