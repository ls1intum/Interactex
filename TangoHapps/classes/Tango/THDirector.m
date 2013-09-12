//
//  THDirector.m
//  TangoHapps
//
//  Created by Juan Haladjian on 1/11/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "TFLayer.h"
#import "THTabbarViewController.h"
#import "THPropertiesViewController.h"

#import "THDirector.h"
#import "THProjectProxy.h"
#import "THProjectViewController.h"
#import "THEditorToolsDataSource.h"
#import "THServerController.h"
#import "THEditorToolsViewController.h"

@implementation THDirector

#pragma mark - Singleton

static THDirector * _sharedInstance = nil;

+(THDirector*)sharedDirector {
    @synchronized([THDirector class]){
        if (!_sharedInstance)
            _sharedInstance = [[THDirector alloc] init];
        
        return _sharedInstance;
    }
    
    return nil;
}

+(id)alloc {
    @synchronized([THDirector class]) {
        NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedInstance = [super alloc];
        return _sharedInstance;
    }
    
    return nil;
}

-(void) preload{
    [[SimpleAudioEngine sharedEngine] preloadEffect:kConnectionMadeEffect];
}

-(id) init{
    self = [super init];
    if(self){
        
        [self loadProjects];
        
        self.serverController = [[THServerController alloc] init];
        self.serverController.delegate = self;
        
        [self preload];
        
    }
    return self;
}

#pragma mark - Methods

-(void) loadProjects {
    
    NSString * directory = [TFFileUtils dataDirectory:kProjectsDirectory];
    NSArray * files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:nil];
    self.projectProxies = [[NSMutableArray alloc] init];
    for(NSString *archivePath in files){
        THProjectProxy * proxy = [THProjectProxy proxyWithName:[archivePath lastPathComponent]];
        [self.projectProxies addObject:proxy];
    }
}

/*
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if(viewController == self.selectionController){
        if(_alreadyStartedEditor){
            [self saveCurrentProject];
            [self.currentProject prepareToDie];
            self.currentProject = nil;
            [self.projectController.tabController.propertiesController removeAllControllers];
        }
        [self.projectDelegate willStopEditingProject:self.currentProject];
        [self.selectionController reloadData];
        
        [self.serverController stopServer];
        
    } else {
        _alreadyStartedEditor = YES;
        [self.projectDelegate willStartEditingProject:self.currentProject];
        [self.serverController startServer];
    }
}*/

-(BOOL) renameProjectFile:(NSString*) name toName:(NSString*) newName{
    
    BOOL renamed = [TFFileUtils renameDataFile:name to:newName inDirectory:kProjectsDirectory];
    if(!renamed){
        return NO;
    }
    
    NSString * imageName = [name stringByAppendingString:@".png"];
    NSString * newImageName = [newName stringByAppendingString:@".png"];
    [TFFileUtils renameDataFile:imageName to:newImageName inDirectory:kProjectImagesDirectory];
    return YES;
}

-(void) renameCurrentProjectToName:(NSString*) newName{
    if([self renameProjectFile:self.currentProject.name toName:newName]){
        _currentProxy.name = newName;
        self.currentProject.name = newName;
    }
}

#pragma mark - Layer

-(TFLayer*) currentLayer{
    return self.projectController.currentLayer;
}


#pragma Mark - Server Delegate

-(void) updateServerButtonState{
    
    THServerController * serverController = self.serverController;
    BOOL enabled = serverController.peers.count > 0;
    if(enabled){
        [[SimpleAudioEngine sharedEngine] playEffect:@"peer_connected.mp3"];
    } else {
        [[SimpleAudioEngine sharedEngine] playEffect:@"peer_disconnected.mp3"];
    }
    
    if(self.projectController.toolsController.pushItem.enabled != enabled){
        self.projectController.toolsController.pushItem.enabled = enabled;
    }
}

-(void) server:(THServerController*)controller
 peerConnected:(NSString*)peerName {
    [self updateServerButtonState];
}

-(void) server:(THServerController*)controller peerDisconnected:(NSString*)peerName {
    [self updateServerButtonState];
}

-(void) server:(THServerController*)controller isReadyForSceneTransfer:(BOOL)ready {
    //self.serverItem.enabled = enabled;
}

-(void) server:(THServerController*)controller
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

- (void) server:(THServerController*)controller isRunning:(BOOL)running{
    //[self updateWirelessButtonTo:running];
}

@end
