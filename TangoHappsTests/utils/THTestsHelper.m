//
//  THTestsHelper.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/30/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

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
