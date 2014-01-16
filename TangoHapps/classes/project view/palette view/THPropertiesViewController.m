/*
THPropertiesViewController.m
Interactex Designer

Created by Juan Haladjian on 05/10/2013.

Interactex Designer is a configuration tool to easily setup, simulate and connect e-Textile hardware with smartphone functionality. Interactex Client is an app to store and replay projects made with Interactex Designer.

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
The first version of the software was designed and implemented as part of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was founded by Telekom Innovation Laboratories Berlin. It has been extended with funding from EIT ICT, as part of the activity "Connected Textiles".

Interactex is built using the Tango framework developed by TU Munich.

In the Interactex software, we use the GHUnit (a test framework for iOS developed by Gabriel Handford) and cocos2D libraries (a framework for building 2D games and graphical applications developed by Zynga Inc.). 
www.cocos2d-iphone.org
github.com/gabriel/gh-unit

Interactex also implements the Firmata protocol. Its software serial library is based on the original Arduino Firmata library.
www.firmata.org

All hardware part graphics in Interactex Designer are reproduced with kind permission from Fritzing. Fritzing is an open-source hardware initiative to support designers, artists, researchers and hobbyists to work creatively with interactive electronics.
www.frizting.org

Martijn ten Bhömer from TU Eindhoven contributed PureData support. Contact: m.t.bhomer@tue.nl.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

#import "THPropertiesViewController.h"
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