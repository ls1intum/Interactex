/*
THTestsHelper.m
Interactex Designer

Created by Juan Haladjian on 05/11/2012.

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

#import "THTestsHelper.h"
#import "THButtonEditableObject.h"
#import "THLedEditableObject.h"
#import "THProjectDelegate.h"
#import "THPaletteDataSource.h"
#import "THEditorToolsDataSource.h"
#import "THEditor.h"
#import "THProjectViewController.h"

@implementation THTestsHelper

static THEditor * _editor;

+(THProject*) emptyProject{
    
    THProject * project = (THProject*) [[THDirector sharedDirector].projectDelegate newCustomProject];
    [TFDirector sharedDirector].currentProject = project;
     return project;
}

+(void) startDirector{
    THProjectDelegate * projectDelegate = [[THProjectDelegate alloc] init];
    
    THDirector * director = [THDirector sharedDirector];
    director.paletteDataSource = [[THPaletteDataSource alloc] init];
    director.projectDelegate = projectDelegate;
    director.editorToolsDataSource = [[THEditorToolsDataSource alloc] init];
    director.gridDelegate = projectDelegate;
}

+(void) startCocos2d {
    [[CCDirector sharedDirector] stopAnimation];
    if(![CCDirector setDirectorType:kCCDirectorTypeDisplayLink])
        [CCDirector setDirectorType:kCCDirectorTypeDefault];
    
    CCDirector *director = [CCDirector sharedDirector];
    
    EAGLView * glview = [EAGLView viewWithFrame:CGRectMake(0, 0, 1024, 724)
                                    pixelFormat:kEAGLColorFormatRGB565
                                    depthFormat:0];
    
    [director setOpenGLView:glview];
    [director setAnimationInterval:1.0/60];
    [director enableRetinaDisplay:YES];
    
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    glClearColor(0, 0, 0, 0);
}

+(void) startEditor {
    
    _editor = [THEditor node];
    
    [_editor willAppear];
    CCScene * scene = [CCScene node];
    [scene addChild:_editor];
    [[CCDirector sharedDirector] runWithScene:scene];
}

+(void) startWithEditor {
    
    [self startDirector];
    [self startCocos2d];
    //[self startEditor];
    
    THProjectViewController * projectController = [THDirector sharedDirector].projectController;
    [CCDirector sharedDirector].openGLView = projectController.glview;
    
     [projectController startWithEditor];
}

+(void) stop{
    [[CCDirector sharedDirector] end];
    [[THDirector sharedDirector] stop];
    
    /*
    TFLayer * layer = [TFDirector sharedDirector].currentLayer;
    
    [layer prepareToDie];*/
    //[[CCDirector sharedDirector] popScene];
    
    /*
    TFProjectViewController * projectController = [TFDirector sharedDirector].projectController;
    [projectController cleanUp];*/
}

/*
+(THWorld*) startClientSimulation{
    
    World * world = [THWorldController sharedInstance].currentWorld;
    THWorld * thworld = [world nonEditableWorld];
    [THSimulableWorldController sharedInstance].currentWorld = thworld;
    
    [THWorldController sharedInstance].currentWorld = nil;
    world = nil;
    
    THWorld * neWorld = [THSimulableWorldController sharedInstance].currentWorld;
    if(neWorld){
        [neWorld startSimulating];
    }
    return thworld;
}*/

+(void) startSimulation{
    
    TFProject * project = [TFDirector sharedDirector].currentProject;
    [project willStartSimulation];
    [project didStartSimulation];
}

+(void) stopSimulation{
    
    TFProject * project = [TFDirector sharedDirector].currentProject;
    [project prepareForEdition];
}

//should do the same as editor 
+(TFMethodInvokeAction*) registerActionForObject:(TFEditableObject*) source target:(TFEditableObject*) target event:(NSString*) eventName method:(NSString*) methodName{
    
    TFMethod * method = [target methodNamed:methodName];
    TFMethodInvokeAction * action = [[TFMethodInvokeAction alloc] initWithTarget:target method:method];
    action.source = source;
    TFEvent * event = [source eventNamed:eventName];
    
    if(method.numParams > 0){
        action.firstParam = event.param1;
    }
    
    TFMethodSelectionPopup * popup = [[TFMethodSelectionPopup alloc] init];
    popup.object1 = source;
    popup.object2 = target;
    
    THEditor * editor = (THEditor*) [THDirector sharedDirector].currentLayer;
    [editor methodSelectionPopup:popup didSelectAction:action forEvent:event];
    
    return action;
}


@end
