
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

-(BOOL)editing
{
    return _editing;
}

-(void)setEditing:(BOOL)doEditing
{
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
        item.delegate = self;
        [_items addObject:item];
        [self addSubview:item];
    }
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat currentX = self.scrollIndicatorInsets.left;
    CGFloat currentY = self.scrollIndicatorInsets.top;
    NSTimeInterval delay = 0;
    CGSize itemSize = [self.gridDelegate gridItemSizeForGridView:self];
    for(UIView *item in _items){
        CGRect frame = CGRectMake(currentX, currentY, itemSize.width, itemSize.height);
        [UIView animateWithDuration:(_editing ? 0.3f : 0.01f)
                              delay:(_editing ? delay : 0)
                            options:UIViewAnimationCurveEaseOut 
                         animations:^{
                             [item setFrame:frame];
                         } 
                         completion:^(BOOL finished) {}];
        currentX += itemSize.width;
        if(currentX + itemSize.width > self.bounds.size.width){
            currentX = 0;
            currentY += itemSize.height;
        }
        delay += 0.05f;
    }
    [self setContentSize:CGSizeMake(self.bounds.size.width, currentY + itemSize.height)];
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
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         //[item setTransform:CGAffineTransformMakeScale(2, 2)];
                         [item setAlpha:0];
                     }
                     completion:^(BOOL finished){
                         [item removeFromSuperview];
                         [_items removeObject:item];
                         [self setNeedsLayout];
                     }];

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
