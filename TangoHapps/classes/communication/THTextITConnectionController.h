//
//  THClientConnectionController2.h
//  TangoHapps
//
//  Created by Juan Haladjian on 29/09/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MultipeerConnectivity;
@class THCustomComponent;

@protocol THTextITConnectionControllerDelegate <NSObject>

-(void) didStartReceivingProjectNamed:(NSString*) name;
-(void) didMakeProgressForCurrentProject:(float) progress;
-(void) didFinishReceivingObject:(THCustomComponent*) project;
-(void) appendStatusMessage:(NSString *)msg;
@end

typedef enum{
    kReceivingStateNone,
    kReceivingStateShouldReceiveProject
} THTextITClientReceivingState;

@interface THTextITConnectionController : NSObject <MCSessionDelegate, MCNearbyServiceBrowserDelegate>{
    
    THTextITClientReceivingState receivingState;
}

@property (readonly, nonatomic) MCPeerID * localPeerID;
@property (strong, nonatomic) MCPeerID * remotePeerID;
@property (readonly, nonatomic) MCSession * session;
@property (readonly) BOOL isConnectedToServer;
@property (copy, nonatomic) NSString * connectedPeerID;
@property (weak, nonatomic) id<THTextITConnectionControllerDelegate> delegate;

-(void) startClient;
-(void) stopClient;

@end
