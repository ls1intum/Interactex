//
//  THServerController2.h
//  TangoHapps
//
//  Created by Juan Haladjian on 18/09/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MultipeerConnectivity;

@class THServerController2;

@protocol THServerControllerDelegate <NSObject>
- (void)server:(THServerController2*)controller peerConnected:(NSString*)peerName;
- (void)server:(THServerController2*)controller peerDisconnected:(NSString*)peerName;
- (void)server:(THServerController2*)controller isReadyForSceneTransfer:(BOOL)ready;
- (void)server:(THServerController2*)controller isRunning:(BOOL)running;
- (void)server:(THServerController2*)controller isTransferring:(BOOL)transferring;
@end

@interface THServerController2 : NSObject <MCNearbyServiceAdvertiserDelegate, MCSessionDelegate>
{
    
}

@property (readonly, nonatomic) MCPeerID * localPeerId;
@property (readonly, nonatomic) MCSession * session;
//@property (readonly) BOOL serverIsRunning;
@property (weak, nonatomic) id<THServerControllerDelegate> delegate;

-(void) pushProjectToAllClients:(THProject*)project;
-(void) startServer;
-(void) stopServer;

@end


