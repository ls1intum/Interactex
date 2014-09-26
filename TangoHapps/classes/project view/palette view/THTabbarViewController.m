/*
THTabbarViewController.m
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
    
    //THTabbarView * view = [[THTabbarView alloc] initWithFrame:CGRectMake(0, 0, kTabWidth, self.view.frame.size.height - self.toolBar.frame.size.height)]; // Nazmus commented
    THTabbarView * view = [[THTabbarView alloc] initWithFrame:CGRectMake(0, self.toolBarView.frame.size.height-10, kTabWidth, self.view.frame.size.height - self.toolBarView.frame.size.height+10)]; // Nazmus added
    
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
    
    //self.view.backgroundColor = [UIColor grayColor]; // NS commented 24 Aug 14
    self.view.backgroundColor = [UIColor whiteColor]; // NS added 24 Aug 14
    [self.view bringSubviewToFront:self.toolBarView];
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
        
        /// Nazmus 28 June 14
        [UIView transitionFromView:_propertiesController.view
                            toView:_paletteController.view
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        completion:^(BOOL finished){
                            [self.view bringSubviewToFront:self.toolBarView];
                        }];
        ///
    } else if(index == 1){
        
        self.paletteButton.selected = NO;
        self.propertiesButton.selected = YES;
        /// Nazmus 28 June 14
        [UIView transitionFromView:_paletteController.view
                            toView:_propertiesController.view
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL finished){
                            [self.view bringSubviewToFront:self.toolBarView];
                        }];
        ///
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
