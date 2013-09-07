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


#import "THLedPaletteItem.h"
#import "THButtonPaletteItem.h"
#import "THBuzzerPaletteItem.h"
#import "THCompassPaletteItem.h"
#import "THLightSensorPaletteItem.h"
#import "THPotentiometerPaletteItem.h"
#import "THSwitchPaletteItem.h"
#import "THThreeColorLedPaletteItem.h"
#import "THVibrationBoardPaletteItem.h"

#import "THiPhonePaletteItem.h"
#import "THiPhoneButtonPaletteItem.h"
#import "THLabelPaletteItem.h"
#import "THiSwitchPaletteItem.h"
#import "THMusicPlayerPaletteItem.h"
#import "THTouchpadPaletteItem.h"
#import "THImageViewPaletteItem.h"
#import "THSliderPaletteItem.h"
#import "THContactBookPaletteItem.h"

#import "THClothePaletteItem.h"

#import "THComparatorPaletteItem.h"
#import "THGrouperPaletteItem.h"
#import "THValuePaletteItem.h"
#import "THMapperPaletteItem.h"
#import "THProjectViewController.h"
#import "THTimerPaletteItem.h"
#import "THSoundPaletteItem.h"
#import "TFTabbarViewController.h"
#import "THBoolValuePaletteItem.h"
#import "THStringValuePaletteItem.h"

@implementation TFPaletteViewController

-(id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - Populate

-(void) addCustomPaletteItems{
    
    for (TFCustomPaletteItem * paletteItem in _customPaletteItems) {
        TFTabbarSection * section = [((TFTabbarView*) self.view) sectionNamed:paletteItem.paletteName];
        [section.palette addDragablePaletteItem:paletteItem];
    }
}

-(void)reloadPalettes {
    [self.tabView reloadData];
}

#pragma mark - Palette Drag Delegate

-(void) palette:(TFPalette*)palette
didStartDraggingItem:(TFPaletteItem*)item
 withRecognizer:(UIPanGestureRecognizer*)recognizer {
    
    if(_dragView == nil){
        _dragView = [[TFDragView alloc] initWithPaletteItem:item];
        CGPoint location = [recognizer locationInView:self.view];
        _dragView.center = location;
        [self.view addSubview:_dragView];
        
        CGPoint locationEditor = [recognizer locationInView: [CCDirector sharedDirector].view];
        
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
        CGPoint locationEditor = [recognizer locationInView: [CCDirector sharedDirector].view];
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
}

-(void) didTapPalette:(TFPalette*) palette{
    if(self.isEditing){
        for (TFTabbarSection * section in self.tabView.sections) {
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

#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tabView = (TFTabbarView*) self.view;
    
    [self.tabView setDelaysContentTouches:NO];
    
    self.tabView.dataSource = self;
    self.tabView.tabBarDelegate = self;
    
    [self loadPaletteData];
    [self.tabView reloadData];
    
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

#pragma  mark - Palette Data Source

-(NSInteger) numPaletteSectionsForPalette:(TFTabbarView*) tabBar{
    return 4;
}

-(NSString*) titleForSection:(NSInteger) section palette:(TFTabbarView*) tabBar{
    return [self.sectionNames objectAtIndex:section];
}

-(NSInteger) numPaletteItemsForSection:(NSInteger) section palette:(TFTabbarView*) tabBar{
    NSArray * items = [self.sections objectAtIndex:section];
    return items.count;
}

-(TFPaletteItem*) paletteItemForIndexPath:(NSIndexPath*) indexPath palette:(TFTabbarView*) tabBar{
    NSArray * items = [self.sections objectAtIndex:indexPath.section];
    return [items objectAtIndex:indexPath.row];
}

-(void) loadPaletteData {
    
    NSArray * clothesArray = [NSArray arrayWithObjects:[[THClothePaletteItem alloc] initWithName:@"tshirt"], nil];
    
    NSArray * uiArray = [NSArray arrayWithObjects:[[THiPhonePaletteItem alloc] initWithName:@"iphone"],
                         [[THiPhoneButtonPaletteItem alloc] initWithName:@"ibutton"],
                         [[THLabelPaletteItem alloc] initWithName:@"label"],
                         [[THiSwitchPaletteItem alloc] initWithName:@"iswitch"],
                         [[THSliderPaletteItem alloc] initWithName:@"slider"],
                         [[THTouchpadPaletteItem alloc] initWithName:@"touchpad"],
                         [[THMusicPlayerPaletteItem alloc] initWithName:@"musicplayer"],
                         [[THImageViewPaletteItem alloc] initWithName:@"imageview"],
                         [[THContactBookPaletteItem alloc] initWithName:@"contactBook"],
                         nil];
    
    
    NSArray * hardwareArray = [NSArray arrayWithObjects:
                               [[THLedPaletteItem alloc] initWithName:@"led"],
                               [[THButtonPaletteItem alloc] initWithName:@"button"],
                               [[THSwitchPaletteItem alloc] initWithName:@"switch"],
                               [[THBuzzerPaletteItem alloc] initWithName:@"buzzer"],
                               [[THCompassPaletteItem alloc] initWithName:@"compass"],
                               [[THLightSensorPaletteItem alloc] initWithName:@"lightSensor"],
                               [[THPotentiometerPaletteItem alloc] initWithName:@"potentiometer"],
                               [[THThreeColorLedPaletteItem alloc] initWithName:@"threeColorLed"],
                               [[THVibrationBoardPaletteItem alloc] initWithName:@"vibeBoard"],
                               nil];
    
    
    NSArray * programmingArray = [NSArray arrayWithObjects:
                                  [[THComparatorPaletteItem alloc] initWithName:@"comparator"],
                                  [[THGrouperPaletteItem alloc] initWithName:@"grouper"],
                                  [[THMapperPaletteItem alloc] initWithName:@"mapper"],
                                  [[THTimerPaletteItem alloc] initWithName:@"timer"],
                                  [[THSoundPaletteItem alloc] initWithName:@"sound"],
                                  [[THValuePaletteItem alloc] initWithName:@"value"],
                                  [[THBoolValuePaletteItem alloc] initWithName:@"boolValue"],
                                  [[THStringValuePaletteItem alloc] initWithName:@"stringValue"],
                                  nil];
    
    self.sections = [NSMutableArray arrayWithObjects:clothesArray, uiArray, hardwareArray, programmingArray, nil];
    self.sectionNames = [NSMutableArray arrayWithObjects:@"Clothes", @"UI Elements", @"Hardware", @"Programming", nil];
}

-(void) tabBar:(TFTabbarView*) tabBar didAddSection:(TFTabbarSection*) section{
    section.palette.dragDelegate = self;
    section.palette.editionDelegate = self;
}
@end
