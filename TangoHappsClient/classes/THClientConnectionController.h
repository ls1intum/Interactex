//
//  THFirstViewController.h
//  TangoHappsClient
//
//  Created by Juan Haladjian on 9/24/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "THTransferAgent.h"

@class THClientAppViewController;
@class THClientScene;
@class THClientServer;

@protocol THClientConnectionControllerDelegate <NSObject>

-(void) didStartReceivingProjectNamed:(NSString*) name;
-(void) didMakeProgressForCurrentProject:(float) progress;
-(void) didFinishReceivingProject:(THClientProject*) project;

@end

@interface THClientConnectionController : NSObject <THTransferAgentDelegate, GKSessionDelegate> {
    
    GKSession *session;
    THTransferAgent * transferAgent;
}

@property (readonly) BOOL isConnectedToServer;
@property (copy, nonatomic) NSString * connectedPeerID;
@property (weak, nonatomic) id<THClientConnectionControllerDelegate> delegate;

-(void)startClient;
-(void)stopClient;

@end
