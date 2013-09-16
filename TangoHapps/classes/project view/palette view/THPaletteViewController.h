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
#import "THPaletteItem.h"
#import "THPalette.h"
#import "THTabbarSection.h"
#import "THTabbarView.h"
#import "THEditor.h"

@class PaletteItemContainer;
@class THDraggedPaletteItem;
@class THTabbarSection;
@class THTabbarView;

typedef enum {
    kDraggingInTab,
    kDraggingInEditor
} TFDraggingState;

@interface THPaletteViewController : UIViewController
<THPaletteDragDelegate, THPaletteEditionDelegate, THEditorDragDelegate, TFTabbarViewDataSource, TFTabBarViewDelegate>
{
    THDraggedPaletteItem * _dragView;
    THDraggedPaletteItem * _editorDragView;
    
    NSMutableArray * _customPaletteItems;
    THTabbarSection * _selectedSection;
}

@property (nonatomic, weak) id<TFPaletteViewControllerDelegate> delegate;
@property (nonatomic, readonly) THPaletteItem * currentPaletteItem;
@property (nonatomic, readonly) THTabbarView * tabView;
@property (nonatomic) BOOL isEditing;

@property (nonatomic, strong) NSArray * clothesSectionArray;
@property (nonatomic, strong) NSArray * uiSectionArray;
@property (nonatomic, strong) NSArray * hardwareSectionArray;
@property (nonatomic, strong) NSArray * programmingSectionArray;

@property (nonatomic, copy) NSString * clothesSectionName;
@property (nonatomic, copy) NSString * uiSectionArrayName;
@property (nonatomic, copy) NSString * hardwareSectionName;
@property (nonatomic, copy) NSString * programmingSectionName;

@property (nonatomic, strong) NSMutableArray * sections;
@property (nonatomic, strong) NSMutableArray * sectionNames;

-(void) reloadPalettes;
-(void) useDefaultPaletteSections;
-(void) addCustomPaletteItems;
-(void) save;
-(void) prepareToDie;

@end
