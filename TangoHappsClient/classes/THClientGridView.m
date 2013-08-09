
#import "THClientGridView.h"

@implementation THClientGridView

@synthesize editing = _editing;

-(void) load{
    
    _items = [[NSMutableArray alloc] init];
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tapRecognizer.delegate = self;
    [self addGestureRecognizer:tapRecognizer];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        [self load];
    }
    return self;
}

-(id)init{
    self = [super init];
    if(self){
        [self load];

    }
    return self;
}
#pragma mark - Tap delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if([touch.view isKindOfClass:[UIControl class]]){
        return NO;
    }
    return YES;
}

-(void) tapped:(UITapGestureRecognizer*) sender{
    if(self.editing){
        self.editing = NO;
    }
}

#pragma mark - Methods

-(BOOL)editing {
    return _editing;
}

-(void)setEditing:(BOOL)doEditing {
    _editing = doEditing;
    for(THClientGridItem *item in _items)
        [item setEditing:_editing];
}

-(void)reloadData {
    
    NSUInteger count = [_dataSource numberOfItemsInGridView:self];
    for(THClientGridItem *item in _items){
        [item removeFromSuperview];
    }
    
    [_items removeAllObjects];
    for(NSUInteger i = 0; i < count; i++){
        THClientGridItem *item = [_dataSource gridView:self viewAtIndex:i];
        [self addItem:item];
    }
    
    [self recalculateContentSize];
    
    [self setNeedsLayout];
}

-(void) insertItem:(THClientGridItem*) item atPosition:(NSInteger) idx{
    [_items insertObject:item atIndex:idx];
    item.delegate = self;
    [self addSubview:item];
}

-(void) addItem:(THClientGridItem *)item{
    [self insertItem:item atPosition:self.items.count];
}

-(void) removeItem:(THClientGridItem *)item{
    
    [item removeFromSuperview];
    [_items removeObject:item];
}

-(void) recalculateContentSize {
    
    CGSize itemSize = [self.gridDelegate gridItemSizeForGridView:self];
    
    NSInteger nCols = (NSInteger) ((self.bounds.size.width - self.scrollIndicatorInsets.left) / itemSize.width);
    NSInteger nRows = ((float)self.items.count / (float)nCols) + 0.9999;

    [self setContentSize:CGSizeMake(self.bounds.size.width, nRows * itemSize.height)];
}

-(void) scrollToBottomAnimated:(BOOL) animated{
    
    CGPoint offset = CGPointMake(0, self.contentSize.height - self.bounds.size.height);
    [self setContentOffset:offset animated:YES];
    
    //[self scrollRectToVisible:item.frame animated:animated];
}

-(void) addItem:(THClientGridItem*) item animated:(BOOL) animated{
    
    NSAssert(self.items.count == [self.dataSource numberOfItemsInGridView:self]-1, @"Mismatch between dataSource and local items array when adding item. Items: %d dataSourceItems is %d",self.items.count,[self.dataSource numberOfItemsInGridView:self]);
    
    [self addItem:item];
    [self recalculateContentSize];
    
    if(animated){
        CGSize itemSize = [self.gridDelegate gridItemSizeForGridView:self];
        CGRect frame = CGRectMake(currentPosition.x, currentPosition.y, itemSize.width, itemSize.height);
        [UIView animateWithDuration: 0.3f
                              delay: 0
                            options:UIViewAnimationCurveEaseOut
                         animations:^{
                             [item setFrame:frame];
                         }
                         completion:^(BOOL finished) {}];
        
        [self scrollToBottomAnimated:YES];
    }
}

-(void) removeItem:(THClientGridItem*) item animated:(BOOL) animated{
    
    NSAssert(self.items.count == [self.dataSource numberOfItemsInGridView:self]+1, @"Mismatch between dataSource and local items array when removing item. Items: %d dataSourceItems is %d",self.items.count,[self.dataSource numberOfItemsInGridView:self]);
    
    if(animated){
        
        [UIView animateWithDuration:(animated ? 0.2 : 0)
                              delay:0
                            options:UIViewAnimationCurveEaseOut
                         animations:^{
                             [item setAlpha:0];
                         }
                         completion:^(BOOL finished){
                             [self removeItem:item];
                             [self recalculateContentSize];
                             [self setNeedsLayout];
                         }];
    } else {
        
        [self removeItem:item];
        [self recalculateContentSize];
        [self setNeedsLayout];
    }
}

-(void) replaceItem:(THClientGridItem*) item withItem:(THClientGridItem*) newItem{
    NSInteger idx = [self.items indexOfObject:item];
    [self removeItem:item];
    [self insertItem:item atPosition:idx];
    NSLog(@"idx was %d",idx);
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    currentPosition.x = self.scrollIndicatorInsets.left;
    currentPosition.y = self.scrollIndicatorInsets.top;
    
    NSTimeInterval delay = 0;
    CGSize itemSize = [self.gridDelegate gridItemSizeForGridView:self];

    for(UIView *item in _items){
        
        CGRect frame = CGRectMake(currentPosition.x, currentPosition.y, itemSize.width, itemSize.height);
        [UIView animateWithDuration:(_editing ? 0.3f : 0.01f)
                              delay:(_editing ? delay : 0)
                            options:UIViewAnimationCurveEaseOut 
                         animations:^{
                             [item setFrame:frame];
                         } 
                         completion:^(BOOL finished) {}];
        
        currentPosition.x += itemSize.width;
        if(currentPosition.x + itemSize.width > self.bounds.size.width){
            currentPosition.x = 0;
            currentPosition.y += itemSize.height;
        }
        
        delay += 0.05f;
    }
}

-(void) didLongPressGridItem:(THClientGridItem *)item{
    self.editing = YES;
}

-(void)didSelectGridItem:(THClientGridItem*)item
{
    NSUInteger index = [_items indexOfObject:item];
    [_dataSource gridView:self didSelectViewAtIndex:index];
}

-(void)didDeleteGridItem:(THClientGridItem*)item
{
    [self removeItem:item animated:YES];

    NSUInteger index = [_items indexOfObject:item];
    [_dataSource gridView:self didDeleteViewAtIndex:index];
}

-(void)didRenameGridItem:(THClientGridItem*)item newName:(NSString*)newName
{
    NSUInteger index = [_items indexOfObject:item];
    [_dataSource gridView:self
    didRenameViewAtIndex:index 
                 newName:newName];
}
@end
