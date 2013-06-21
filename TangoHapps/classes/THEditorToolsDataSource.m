//
//  THEditorToolsDataSource.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/28/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

#import "THEditorToolsDataSource.h"
#import "THCustomEditor.h"
#import "THCustomSimulator.h"
#import "THProjectViewController.h"
#import "TFTabbarViewController.h"

@implementation THEditorToolsDataSource

@dynamic lilypadItem;

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
        
        _serverController = [[ServerController alloc] init];
        [_serverController startServer];
        _serverController.delegate = self;
        
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
    
    THCustomEditor * editor = (THCustomEditor*) director.currentLayer;
    [editor stopLilypadMode];
    [self.lilypadItem setImage:[UIImage imageNamed:@"lilypadmode"]];
    
    [director.projectController.tabController showAllPalettes];
}

-(void) startLilypadMode{
    
    THDirector * director = [THDirector sharedDirector];
    THCustomEditor * editor = (THCustomEditor*) director.currentLayer;
    [editor startLilypadMode];
    [self.lilypadItem setImage:[UIImage imageNamed:@"editormode"]];
    
    TFTabbarViewController * tabController = director.projectController.tabController;
    
    [tabController hidePaletteWithIdx:0];
    [tabController hidePaletteWithIdx:2];
    [tabController hidePaletteWithIdx:3];
    [tabController hidePaletteWithIdx:4];
}

- (void) lilypadPressed:(id)sender {
    THCustomEditor * editor = (THCustomEditor*) [THDirector sharedDirector].currentLayer;
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
    if([_serverController serverIsRunning]){
        THCustomProject * project = (THCustomProject*) [THDirector sharedDirector].currentProject;
        [_serverController pushProjectToAllClients:project];
    }
}

#pragma Mark - Server Delegate

-(void) updateServerButtonState{
    BOOL enabled = _serverController.peers.count > 0;
    if(enabled != self.serverItem.enabled){
        self.serverItem.enabled = enabled;
        if(enabled){
            [[SimpleAudioEngine sharedEngine] playEffect:@"peer_connected.mp3"];
        } else {
            [[SimpleAudioEngine sharedEngine] playEffect:@"peer_disconnected.mp3"];
        }
    }
}

-(void) server:(ServerController*)controller
 peerConnected:(NSString*)peerName {
    [self updateServerButtonState];
}

-(void) server:(ServerController*)controller peerDisconnected:(NSString*)peerName {
    [self updateServerButtonState];
}

-(void) server:(ServerController*)controller isReadyForSceneTransfer:(BOOL)ready {
    //self.serverItem.enabled = enabled;
}

-(void) server:(ServerController*)controller
isTransferring:(BOOL)transferring {
    /*
    UIImage * image;
    if(transferring){
        image = [UIImage imageNamed:@"server_busy"];
    }else{
        image = [UIImage imageNamed:@"server_online"];
    }
    wirelessButton.image = image;*/
}

- (void) server:(ServerController*)controller isRunning:(BOOL)running{
    //[self updateWirelessButtonTo:running];
}

#pragma Mark - Pins

-(void) pinsModePressed:(id)sender {
    THCustomSimulator * simulator = (THCustomSimulator*) [THDirector sharedDirector].currentLayer;
    
    if(simulator.state == kSimulatorStateNormal){
        [simulator addPinsController];
    } else {
        [simulator removePinsController];
    }
}

@end
