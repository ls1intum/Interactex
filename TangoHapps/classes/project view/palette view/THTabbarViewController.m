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


#import "THTabbarViewController.h"
#import "THTabbarViewController.h"
#import "THPaletteViewController.h"
#import "THPropertiesViewController.h"
#import "THTabbarView.h"

@implementation THTabbarViewController

float const kTabbarToolbarHeight = 50;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _paletteController = [[THPaletteViewController alloc] init];
        _propertiesController = [[THPropertiesViewController alloc] init];
    }
    return self;
}

#pragma mark - View Lifecycle

-(THTabbarView*) tabbarViewForController:(UIViewController*) controller title:(NSString*) title {
    
    THTabbarView * view = [[THTabbarView alloc] initWithFrame:CGRectMake(0, 0, kTabWidth, self.view.frame.size.height - self.toolBar.frame.size.height)];

    controller.view = view;
    controller.title = title;
    [self.view addSubview:view];
    
    [controller viewDidLoad];
    
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _paletteController.view = [self tabbarViewForController:_paletteController title:@"Palette"];
    _propertiesController.view = [self tabbarViewForController:_propertiesController title:@"Properties"];
    [self showTab:0];
    
    self.view.backgroundColor = [UIColor grayColor];
    //self.view.frame = CGRectMake(0, 100, kTabWidth, 500);
}

- (void)viewDidUnload {
    
    //[self setToolbar:nil];
    [super viewDidUnload];
}

#pragma mark - Getters/Setters

-(BOOL) hidden {
    return self.view.hidden;
}

-(void) setHidden:(BOOL)hide
{
    self.view.hidden = hide;
}

#pragma mark - Actions

-(void) showTab:(NSInteger)index {
    [_paletteController.view setHidden:(index == 1)];
    [_propertiesController.view setHidden:(index == 0)];
    
    if(index == 0){
        self.paletteButton.selected = YES;
        self.propertiesButton.selected = NO;
    } else if(index == 1){
        
        self.paletteButton.selected = NO;
        self.propertiesButton.selected = YES;
    }
}

- (IBAction)paletteTapped:(id)sender {
    [self showTab:0];
}

- (IBAction)propertiesTapped:(id)sender {
    [self showTab:1];
}

#pragma mark - Dealloc

-(void) dealloc{

    _paletteController = nil;
    _propertiesController = nil;
}

@end
