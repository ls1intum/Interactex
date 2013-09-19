//
//  THEditorToolsDataSource.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/28/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

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
