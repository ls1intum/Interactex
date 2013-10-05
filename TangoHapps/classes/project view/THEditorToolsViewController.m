/*
THEditorToolsViewController.m
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


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "THEditorToolsViewController.h"
#import "THProjectViewController.h"
#import "THEditor.h"
#import "THSimulator.h"
#import "THDirector.h"
#import "THiPhoneEditableObject.h"

@implementation THEditorToolsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        _barButtonItems = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _editingTools = [NSArray arrayWithObjects:self.connectButton, self.duplicateButton, self.removeButton, self.lilypadItem, self.hideiPhoneItem, nil];
    _lilypadTools = [NSArray arrayWithObjects:self.connectButton, self.duplicateButton, self.removeButton, self.lilypadItem, nil];
    _simulatingTools = [NSArray arrayWithObjects:self.pinsModeItem,self.pushItem,nil];
    
    //self.highlightedItemTintColor = [UIColor colorWithRed:0.2f green:0.2f blue:1.0f alpha:0.6f];
    self.highlightedItemTintColor = nil;
    self.hideiPhoneItem.tintColor = self.highlightedItemTintColor;
    self.unselectedTintColor = [UIColor grayColor];
    
    [self addEditionButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) unselectAllButtons{
    
    self.connectButton.tintColor = self.unselectedTintColor;
    self.duplicateButton.tintColor = self.unselectedTintColor;
    self.removeButton.tintColor = self.unselectedTintColor;
    self.lilypadItem.tintColor = self.unselectedTintColor;
}

-(void) updateEditingButtonsTint{
    THEditor * editor = (THEditor*) [THDirector sharedDirector].currentLayer;
    
    [self unselectAllButtons];
    
    if(editor.state == kEditorStateConnect){
        self.connectButton.tintColor = self.highlightedItemTintColor;
    } else if(editor.state == kEditorStateDuplicate){
        self.duplicateButton.tintColor = self.highlightedItemTintColor;
    } else if(editor.state == kEditorStateDelete){
        self.removeButton.tintColor = self.highlightedItemTintColor;
    }
}

-(void) updateHideIphoneButtonTint{
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    self.hideiPhoneItem.tintColor = (project.iPhone.visible ? self.highlightedItemTintColor : self.unselectedTintColor);
}

-(void) updateLilypadTint{
    
    THEditor * editor = (THEditor*) [THDirector sharedDirector].currentLayer;
    self.lilypadItem.tintColor = (editor.isLilypadMode ? self.highlightedItemTintColor : self.unselectedTintColor);
}

-(void) updatePinsModeItemTint{
    
    THSimulator * simulator = (THSimulator*) [THDirector sharedDirector].currentLayer;
    self.pinsModeItem.tintColor = (simulator.state == kSimulatorStatePins ? self.highlightedItemTintColor : self.unselectedTintColor);
}

-(void) checkSwitchToState:(TFEditorState) state{
    THProjectViewController * projectController = [THDirector sharedDirector].projectController;
    if(projectController.state == kAppStateEditor){
        THEditor * editor = (THEditor*) projectController.currentLayer;
        if(editor.state == state){
            editor.state = kEditorStateNormal;
        } else {
            editor.state = state;
        }
        [self updateEditingButtonsTint];
    }
}

- (IBAction)connectTapped:(id)sender {
    [self checkSwitchToState:kEditorStateConnect];
}

- (IBAction)duplicateTapped:(id)sender {
    
    [self checkSwitchToState:kEditorStateDuplicate];
}

- (IBAction)removeTapped:(id)sender {
    [self checkSwitchToState:kEditorStateDelete];
}

-(void) setHidden:(BOOL)hidden{
    if(!hidden){
        [self unselectAllButtons];
    }
    self.view.hidden = hidden;
}

-(BOOL) hidden{
    return self.view.hidden;
}

-(void) reloadBarButtonItems{
    
    UITabBar * tabBar = (UITabBar*) self.view;
    tabBar.items = _barButtonItems;
}

-(void) updateFrame{
    CGRect frame = self.view.frame;
    UIBarButtonItem * lastItem = [self.toolBar.items objectAtIndex:self.toolBar.items.count-1];
    UIView * view = [lastItem valueForKey:@"view"];
    frame.size.width =  view.frame.origin.x + view.frame.size.width + frame.origin.x;
}

-(void) addEditionButtons{

    self.toolBar.items = _editingTools;
    [self updateFrame];
}

-(void) addLilypadButtons{
    
    self.toolBar.items = _lilypadTools;
    [self updateFrame];
}

-(void) addSimulationButtons{
    
    self.toolBar.items = _simulatingTools;
    [self updateFrame];
    [self updatePinsModeItemTint];
}

- (IBAction)lilypadPressed:(id)sender {
    
    THEditor * editor = (THEditor*) [THDirector sharedDirector].currentLayer;
    if(editor.isLilypadMode){
        [editor stopLilypadMode];
        [self addEditionButtons];

    } else {
        [editor startLilypadMode];
        [self addLilypadButtons];
    }
    
    [self updateLilypadTint];
}

- (IBAction)pinsModePressed:(id)sender {
    THSimulator * simulator = (THSimulator*) [THDirector sharedDirector].currentLayer;
    
    if(simulator.state == kSimulatorStateNormal){
        [simulator addPinsController];
    } else {
        [simulator removePinsController];
    }
    
    [self updatePinsModeItemTint];
}

- (IBAction)pushPressed:(id)sender {
    THServerController * serverController = [THDirector sharedDirector].serverController;
    if([serverController serverIsRunning]){
        THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
        [serverController pushProjectToAllClients:project];
    }
}

- (IBAction)hideiPhonePressed:(id)sender {
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    project.iPhone.visible = !project.iPhone.visible;
    [self updateHideIphoneButtonTint];
    
    THEditor * editor = (THEditor*) [THDirector sharedDirector].currentLayer;
    [editor handleIphoneVisibilityChangedTo:project.iPhone.visible ];
}

@end
