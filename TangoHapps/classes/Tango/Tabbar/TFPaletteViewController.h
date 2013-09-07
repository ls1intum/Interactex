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
#import "TFPaletteItem.h"
#import "TFPalette.h"
#import "TFEditor.h"
#import "TFTabbarSection.h"
#import "TFTabbarView.h"

@class PaletteItemContainer;
@class TFDragView;
@class TFTabbarSection;
@class TFTabbarView;

typedef enum {
    kDraggingInTab,
    kDraggingInEditor
} TFDraggingState;

@interface TFPaletteViewController : UIViewController
<THPaletteDragDelegate, THPaletteEditionDelegate, TFEditorDragDelegate, TFTabbarViewDataSource, TFTabBarViewDelegate>
{
    TFDragView * _dragView;
    TFDragView * _editorDragView;
    
    NSMutableArray * _customPaletteItems;
    TFTabbarSection * _selectedSection;
}

@property (nonatomic, weak) id<TFPaletteViewControllerDelegate> delegate;
@property (nonatomic, readonly) TFPaletteItem * currentPaletteItem;
@property (nonatomic, readonly) TFTabbarView * tabView;
@property (nonatomic) BOOL isEditing;

@property (nonatomic, strong) NSMutableArray * sections;
@property (nonatomic, strong) NSMutableArray * sectionNames;

-(void) reloadPalettes;
-(void) addCustomPaletteItems;
-(void) save;
-(void) prepareToDie;

@end
