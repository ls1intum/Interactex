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


#import "TFTabbarViewController.h"
#import "TFEditor.h"
#import "TFTabbarViewController.h"
#import "TFPaletteViewController.h"
#import "TFPropertiesViewController.h"
#import "TFTabbarView.h"

@implementation TFTabbarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _paletteController = [[TFPaletteViewController alloc] init];
        _propertiesController = [[TFPropertiesViewController alloc] init];
        
        _paletteController.view = [self tabbarViewForController:_paletteController title:@"Palette"];
        _propertiesController.view = [self tabbarViewForController:_propertiesController title:@"Properties"];
        
        CGRect toolbarFrame = CGRectMake(0, 0, 200, 50);
        self.toolbar = [[UIToolbar alloc] initWithFrame:toolbarFrame];
        
        [self showTab:0];
    }
    return self;
}

#pragma mark - View Lifecycle

-(TFTabbarView*) tabbarViewForController:(UIViewController*) controller title:(NSString*) title {
    TFTabbarView * view = [[TFTabbarView alloc] initWithFrame:CGRectMake(0, 0, kTabWidth, 680)];
    controller.view = view;
    controller.title = title;
    [self.view addSubview:view];
    
    [controller viewDidLoad];
    
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, kTabWidth, 768);
    self.view.backgroundColor = [UIColor grayColor];
    
}

- (void)viewDidUnload {
    
    [self setToolbar:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTab:0];
}


#pragma mark - Getters/Setters

-(BOOL) hidden
{
    return self.view.hidden;
}

-(void) setHidden:(BOOL)hide
{
    self.view.hidden = hide;
}

#pragma mark - Actions

-(void)showTab:(NSInteger)index {
    [_paletteController.view setHidden:(index != 0)];
    [_propertiesController.view setHidden:(index != 1)];
    //TFPalette *view = (TFPalette*)(index == 0 ? _paletteController.view : _propertiesController.view);
    //[self sidebarView:view didResizeTo:view.contentSize];
}

- (IBAction)paletteTapped:(id)sender {
    [self showTab:0];
}

- (IBAction)propertiesTapped:(id)sender {
    [self showTab:1];
}

#pragma mark - Showing/Hidding palettes

-(void) hidePaletteWithIdx:(NSInteger) idx{/*
    _showPalette[idx] = NO;
    [self reloadPalettes];*/
}

-(void) showPaletteWithIdx:(NSInteger) idx{/*
    _showPalette[idx] = YES;
    [self reloadPalettes];*/
}

-(void) showAllPalettes{
    /*
    for (int i = 0; i < kNumPalettes; i++) {
        _showPalette[i] = YES;
    }
    [self reloadPalettes];*/
}

/*
-(void) unselectAllButtons{
}

-(IBAction)connectToolPressed:(id)sender
{
    TFEditor * editor = [TFEditor sharedInstance];
    UIButton* button = (UIButton*) sender;
    if(editor.state == kEditorStateConnect){
        editor.state = kEditorStateNormal;
        button.selected = NO;
    } else {
        [self unselectAllButtons];
        editor.state = kEditorStateConnect;
        button.selected = YES;
    }
}*/

#pragma mark - Dealloc

-(void) dealloc{

    _paletteController = nil;
    _propertiesController = nil;
}

@end
