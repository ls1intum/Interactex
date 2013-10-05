/*
THEditorToolsDataSource.m
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

#import "THEditorToolsDataSource.h"
#import "THEditor.h"
#import "THSimulator.h"
#import "THProjectViewController.h"
#import "THTabbarViewController.h"

@implementation THEditorToolsDataSource

-(id) init{
    self = [super init];
    if(self){
        //editor
        UIImage * lilypadImage = [UIImage imageNamed:@"lilypadmode"];
        UIBarButtonItem * lilypadItem = [[UIBarButtonItem alloc] initWithImage:lilypadImage style:UIBarButtonItemStylePlain target:self action:@selector(lilypadPressed:)];
        
        UIImage * pushImage = [UIImage imageNamed:@"push"];
        UIBarButtonItem * pushItem = [[UIBarButtonItem alloc] initWithImage:pushImage style:UIBarButtonItemStylePlain target:self action:@selector(pushPressed:)];
        pushItem.enabled = NO;
        
        _editingTools = [NSArray arrayWithObjects:pushItem, lilypadItem, nil];
        
        //simulator
        UIImage * pinsModeImage = [UIImage imageNamed:@"pinsmode"];
        UIBarButtonItem * pinsModeItem = [[UIBarButtonItem alloc] initWithImage:pinsModeImage style:UIBarButtonItemStylePlain target:self action:@selector(pinsModePressed:)];
        pushItem.enabled = NO;
        
        _simulatingTools = [NSArray arrayWithObject:pinsModeItem];
        
    }
    return self;
}

#pragma Mark - TFEditorToolsDataSource

-(NSInteger) numberOfToolbarButtonsForState:(TFAppState) state{
    if(state == kAppStateEditor){
        return 2;
    } else {
        return 1;
    }
}

-(UIBarButtonItem*) toolbarButtonAtIdx:(NSInteger) idx forState:(TFAppState) state{
    if(state == kAppStateEditor){
        return [_editingTools objectAtIndex:idx];
    } else {
        return [_simulatingTools objectAtIndex:idx];
    }
}

#pragma Mark - Lilypad

-(UIBarButtonItem*) lilypadItem{
    return [_editingTools objectAtIndex:1];
}

-(void) stopLilypadMode{
    THDirector * director = [THDirector sharedDirector];
    
    THEditor * editor = (THEditor*) director.currentLayer;
    [editor stopLilypadMode];
    [self.lilypadItem setImage:[UIImage imageNamed:@"lilypadmode"]];
}

-(void) startLilypadMode{
    
    THDirector * director = [THDirector sharedDirector];
    THEditor * editor = (THEditor*) director.currentLayer;
    [editor startLilypadMode];
    [self.lilypadItem setImage:[UIImage imageNamed:@"editormode"]];
}

- (void) lilypadPressed:(id)sender {
    THEditor * editor = (THEditor*) [THDirector sharedDirector].currentLayer;
    if(editor.isLilypadMode){
        [self stopLilypadMode];
    } else {
        [self startLilypadMode];
    }
}


#pragma Mark - Push

-(UIBarButtonItem*) serverItem{
    return [_editingTools objectAtIndex:0];
}


- (void) pushPressed:(id)sender {
    THServerController * serverController = [THDirector sharedDirector].serverController;
    if([serverController serverIsRunning]){
        THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
        [serverController pushProjectToAllClients:project];
    }
}

#pragma Mark - Pins

-(void) pinsModePressed:(id)sender {
    THSimulator * simulator = (THSimulator*) [THDirector sharedDirector].currentLayer;
    
    if(simulator.state == kSimulatorStateNormal){
        [simulator addPinsController];
    } else {
        [simulator removePinsController];
    }
}

@end
