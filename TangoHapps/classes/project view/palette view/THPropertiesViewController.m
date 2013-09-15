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

#import "THPropertiesViewController.h"
#import "TFEditor.h"
#import "THEditableObjectProperties.h"
#import "THTabbarView.h"
#import "THTabbarSection.h"
#import "TFEditableObject.h"

@implementation THPropertiesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custominitialization
        _controllers = [NSMutableArray array];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

-(void) addEditorObserver
{
    id c = [NSNotificationCenter defaultCenter];
    [c addObserver:self selector:@selector(handleObjectSelected:) name:kNotificationObjectSelected object:nil];
    [c addObserver:self selector:@selector(handleObjectDeselected) name:kNotificationObjectDeselected object:nil];
    [c addObserver:self selector:@selector(handlePaletteItemSelected:) name:kNotificationPaletteItemSelected object:nil];
    [c addObserver:self selector:@selector(handleObjectDeselected) name:kNotificationPaletteItemDeselected object:nil];
}

-(void) removeEditorObservers
{
    id c = [NSNotificationCenter defaultCenter];
    [c removeObserver:self name:kNotificationObjectSelected object:nil];
    [c removeObserver:self name:kNotificationObjectDeselected object:nil];
}

-(void) removeAllViews{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
}

- (void)addPropertiesController:(THEditableObjectProperties*)controller
                      object:(TFEditableObject*)object {
    //[self addObjectsPalette];
    
    THTabbarView * sidebar = (THTabbarView*)self.view;
    
    THTabbarSection * section = [THTabbarSection sectionWithTitle:controller.title];
    [section addView:controller.view];
    
    [(THTabbarView*)self.view addPaletteSection:section];
    
    controller.sizeDelegate = self;
    controller.editableObject = object;
    controller.scrollView = sidebar;
    
    [_controllers addObject:controller];
}

-(void) removeAllControllers{
    THTabbarView *sidebar = (THTabbarView*)self.view;
    [sidebar removeAllSections];
    
    [_controllers removeAllObjects];
}

-(void) handleObjectSelected:(NSNotification *) notification{
    [self handleObjectDeselected];
    
    TFEditableObject * object = notification.object;
    for(THEditableObjectProperties * controller in object.propertyControllers){
        [self addPropertiesController:controller object:object];
    }
}

-(void) handleObjectDeselected{
    [self removeAllControllers];
    [self removeAllViews];
}

-(void) relayoutControllers{
    if(_controllers.count > 0){
        THEditableObjectProperties * controller = [_controllers objectAtIndex:0];
        
        TFEditableObject * object = (TFEditableObject*) controller.editableObject;
        
        [self removeAllControllers];
        [self removeAllViews];
        
        for(THEditableObjectProperties * controller in object.propertyControllers){
            [self addPropertiesController:controller object:object];
        }
    }
}

-(void) handlePaletteItemSelected:(NSNotification *) notification{
    [self handleObjectDeselected];
    
    TFEditableObject * object = notification.object;
    
    for(THEditableObjectProperties * controller in object.propertyControllers){
        [self addPropertiesController:controller object:object];
    }
}

-(void) properties:(THEditableObjectProperties*) properties didChangeSize:(CGSize) newSize{

    THTabbarView * tabView = (THTabbarView*)self.view;
    for (THTabbarSection * section in tabView.sections) {
        if([section.subviews containsObject:properties.view]){
            CGPoint origin = section.frame.origin;
            CGSize size = section.frame.size;
            section.frame = CGRectMake(origin.x,origin.y,size.width, newSize.height + kPaletteContainerTitleHeight);
        }
    }
    [tabView relayoutSections];
}

#pragma mark - View lifecycle

-(void) addTabBarImage:(NSString*) fileName
{
    UIImage * tabBarImage = [UIImage imageNamed:fileName];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:tabBarImage tag:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addEditorObserver];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self removeEditorObservers];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        return YES;
    return NO;
}

@end