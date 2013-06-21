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

#import "TFPaletteViewController.h"
#import "TFEditor.h"
#import "TFTabbarView.h"
#import "TFPalette.h"
#import "TFDragView.h"
#import "TFCustomPaletteItem.h"

@implementation TFPaletteViewController

-(id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - Populate

- (TFPalette*)emptyPalette {
    CGRect containerFrame = CGRectMake(0, 0, 230, 100);
    TFPalette *palette = [[TFPalette alloc] initWithFrame:containerFrame];
    palette.dragDelegate = self;
    palette.editionDelegate = self;
    return palette;
}

-(void) addCustomPaletteItems{
    
    for (TFCustomPaletteItem * paletteItem in _customPaletteItems) {
        TFTabbarSection * section = [((TFTabbarView*) self.view) sectionNamed:paletteItem.paletteName];
        [section.palette addDragablePaletteItem:paletteItem];
    }
}

-(void)reloadPalettes {
    [(TFTabbarView*)self.view removeAllSections];
    
    for (TFTabbarSection * section in [self.dataSource paletteSections]) {
        section.sizeDelegate = self;
        [(TFTabbarView*)self.view addPaletteSection:section];
    }
}

#pragma mark - Palette Drag Delegate

-(void)palette:(TFPalette*)palette
didStartDraggingItem:(TFPaletteItem*)item
withRecognizer:(UIPanGestureRecognizer*)recognizer {
    if(_dragView == nil){
        _dragView = [[TFDragView alloc] initWithPaletteItem:item];
        CGPoint location = [recognizer locationInView:self.view];
        _dragView.center = location;
        [self.view addSubview:_dragView];
        
        CGPoint locationEditor = [recognizer locationInView: [[CCDirector sharedDirector] openGLView]];
        
        _editorDragView = [[TFDragView alloc] initWithPaletteItem:item];
        
        [self.delegate paletteItem:_editorDragView beganDragAt:locationEditor];
    }
}

-(void)palette:(TFPalette*)palette
   didDragItem:(TFPaletteItem*)item
withRecognizer:(UIPanGestureRecognizer*)recognizer
{
    if(_dragView != nil){
        _dragView.center = [recognizer locationInView:self.view];
        CGPoint locationEditor = [recognizer locationInView: [[CCDirector sharedDirector] openGLView]];
        [self.delegate paletteItem:_editorDragView movedTo:locationEditor];
    }
}

-(void)palette:(TFPalette*)container
   didDropItem:(TFPaletteItem*)item
withRecognizer:(UIPanGestureRecognizer*)recognizer
{
    if(_dragView != nil){
        CGPoint location = [recognizer locationInView:self.view];
        if(![self.view pointInside:location withEvent:nil]){
             
            CGPoint editorLocation = [recognizer locationInView:self.view.superview];
            editorLocation = [[CCDirector sharedDirector] convertToGL: editorLocation];
            
            //CGPoint editorLocation = [recognizer locationInView: [[CCDirector sharedDirector] openGLView]];
            
            if([item canBeDroppedAt:editorLocation])
                [item dropAt:editorLocation];
        }
        [_dragView removeFromSuperview];
        [_editorDragView removeFromSuperview];
        _dragView = nil;
        _editorDragView = nil;
        [self.delegate paletteItem:_editorDragView endedAt:location];
    }
}

-(void)palette:(TFPalette*)palette didLongPressItem:(TFPaletteItem*)item withRecognizer:(UILongPressGestureRecognizer*)recognizer{
    if(item.isEditable){
        [self deselectCurrentObject];
        
        TFTabbarSection * section = [((TFTabbarView*) self.view) sectionForPalette:palette];
        section.editing = YES;
        self.isEditing = YES;
    }
    /*
    for (TFTabbarSection * section in [self.dataSource paletteSections]) {
        section.editing = YES;
    }*/
}

-(void) didTapPalette:(TFPalette*) palette{
    if(self.isEditing){
        for (TFTabbarSection * section in [self.dataSource paletteSections]) {
            section.editing = NO;
        }
        self.isEditing = NO;
    }
    [self deselectCurrentObject];
}

#pragma mark Palette Edition Delegate

-(void)palette:(TFCustomPaletteItem*)palette didRemoveItem:(TFCustomPaletteItem*)item{
    [item deleteArchive];
    [_customPaletteItems removeObject:item];
}

-(void)palette:(TFPalette*)palette didSelectItem:(TFPaletteItem*)item{
    if(!self.isEditing){
        [self deselectCurrentObject];
        [self selectObject:item];
    }
}

-(void) deselectCurrentObject{
    if(_currentPaletteItem){
        _currentPaletteItem.selected = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPaletteItemDeselected object:_currentPaletteItem];
        _currentPaletteItem = nil;
    }
}

-(void) selectObject:(TFPaletteItem*) item{
    item.selected = YES;
    _currentPaletteItem = item;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPaletteItemSelected object:item];
}

#pragma mark TFEditorDragDelegate

-(void) removeCurrentDragView{
    
    [_dragView removeFromSuperview];
    _dragView = nil;
}

-(void) paletteItem:(TFPaletteItem*) paletteItem didEnterPaletteAtLocation:(CGPoint) location{
    if(!self.isEditing){
        _dragView = [[TFDragView alloc] initWithPaletteItem:paletteItem];
        location = [TFHelper ConvertFromCocosToUI:location];
        
        UIScrollView * scrollView = (UIScrollView*) self.view;
        location = [self.view.superview convertPoint:location fromView:self.view];
        location = ccpSub(location,scrollView.contentOffset);
        
        _dragView.center = location;
        [self.view addSubview:_dragView];
    }
}

-(void) checkDeselectCurrentSection {
    
    if(_selectedSection){
        [_selectedSection.palette removeTemporaryPaletteItem];
        _selectedSection = nil;
    }
}

-(void) selectSection:(TFTabbarSection*) section {
    
    [self checkDeselectCurrentSection];
    _selectedSection = section;
}
 
-(void) paletteItem:(TFPaletteItem*) paletteItem didMoveToLocation:(CGPoint) location{
    if(!self.isEditing){
        
        UIScrollView * scrollView = (UIScrollView*) self.view;
        location = [TFHelper ConvertFromCocosToUI:location];
        location = ccpAdd(location,scrollView.contentOffset);
        
        _dragView.center = location;
        
        TFTabbarView * tabView = (TFTabbarView*) self.view;
        TFTabbarSection * section = [tabView sectionAtLocation:location];
        if(section){
            _dragView.state = kPaletteItemStateDroppable;
            if(section != _selectedSection){
                [self selectSection:section];
                TFCustomPaletteItem * customPaletteItem = [TFCustomPaletteItem paletteItemWithName:paletteItem.name];
                [_selectedSection.palette temporaryAddPaletteItem:customPaletteItem];
            }
        } else {
            _dragView.state = kPaletteItemStateNormal;
            [self checkDeselectCurrentSection];
        }
    }
}

-(void) paletteItem:(TFCustomPaletteItem*) paletteItem didDropAtLocation:(CGPoint) location{
    if(!self.isEditing){
        location = [TFHelper ConvertFromCocosToUI:location];
        
        [self removeCurrentDragView];
        
        TFTabbarView * tabView = (TFTabbarView*) self.view;
        TFTabbarSection * section = [tabView sectionAtLocation:location];
        [section.palette addDragablePaletteItem:paletteItem];
        
        paletteItem.paletteName = section.title;
        paletteItem.name = [TFFileUtils resolvePaletteNameConflictFor:paletteItem.name];
        [_customPaletteItems addObject:paletteItem];
        [paletteItem save];
        
        [self checkDeselectCurrentSection];
    }
}

-(void) paletteItemDidExitPalette:(TFPaletteItem *)paletteItem{
    if(!self.isEditing){
        [self removeCurrentDragView];
        [self checkDeselectCurrentSection];
    }
}

-(void) tabbarSection:(TFTabbarSection *)section changedSize:(CGSize)size{
    [(TFTabbarView*) self.view relayoutSections];
}

#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [(UIScrollView*)self.view setDelaysContentTouches:NO];
    
    [self loadCustomPaletteItems];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSelectionLost) name:kNotificationObjectSelected object:nil];
}

-(void) viewWillDisappear:(BOOL)animated{
    [self deselectCurrentObject];
}

-(void) handleSelectionLost{
    _currentPaletteItem.selected = NO;
    _currentPaletteItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIDeviceOrientationLandscapeRight);
}

-(void) loadCustomPaletteItems{
    _customPaletteItems = [NSMutableArray array];
    NSArray * files = [TFFileUtils filesInDirectory:kPaletteItemsDirectory];
    for (NSString * file in files) {
        NSString * filePath = [TFFileUtils dataFile:file
                                        inDirectory:kPaletteItemsDirectory];
        TFCustomPaletteItem * paletteItem = [TFCustomPaletteItem customPaletteItemWithArchiveName:filePath];
        [_customPaletteItems addObject:paletteItem];
    }
    
}

-(void) save{
    for (TFCustomPaletteItem * paletteItem in _customPaletteItems) {
        [paletteItem save];
    }
}

-(void) prepareToDie{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
