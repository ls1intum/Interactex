
#import <UIKit/UIKit.h>
#import "THGridItem.h"

@class THGridView;

@protocol THGridViewDataSource <NSObject>
-(NSUInteger)numberOfItemsInGridView:(THGridView*)gridView;
-(THGridItem*)gridView:(THGridView*)gridView viewAtIndex:(NSUInteger)index;
-(void)gridView:(THGridView*)gridView didSelectViewAtIndex:(NSUInteger)index;
-(void)gridView:(THGridView*)gridView didDeleteViewAtIndex:(NSUInteger)index;
-(void)gridView:(THGridView*)gridView didRenameViewAtIndex:(NSUInteger)index newName:(NSString*)newName;
@end

@protocol THGridViewDelegate <NSObject>
-(CGSize) gridItemSizeForGridView:(THGridView*) view;
-(CGPoint) gridItemPaddingForGridView:(THGridView*) view;
-(CGPoint) gridPaddingForGridView:(THGridView*) view;
@end

@interface THGridView : UIScrollView <THGridItemDelegate, UIGestureRecognizerDelegate>
{
}

@property (nonatomic, weak) id<THGridViewDataSource> dataSource;
@property (nonatomic, weak) id<THGridViewDelegate> gridDelegate;
@property (readonly) NSMutableArray *items;
@property (nonatomic) BOOL editing;

- (void)reloadData;
@end
