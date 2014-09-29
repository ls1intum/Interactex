//
//  THClientConnectionController2.h
//  TangoHapps
//
//  Created by Juan Haladjian on 29/09/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MultipeerConnectivity;

@protocol THClientConnectionControllerDelegate <NSObject>

-(void) didStartReceivingProjectNamed:(NSString*) name;
-(void) didMakeProgressForCurrentProject:(float) progress;
-(void) didFinishReceivingProject:(THClientProject*) project;

@end

@interface THClientConnectionController2 : NSObject <MCSessionDelegate, MCNearbyServiceBrowserDelegate>{

}

@property (readonly, nonatomic) MCPeerID * localPeerID;
@property (readonly, nonatomic) MCSession * session;
@property (readonly) BOOL isConnectedToServer;
@property (copy, nonatomic) NSString * connectedPeerID;
@property (weak, nonatomic) id<THClientConnectionControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray * foundPeers;

-(void) startClient;
-(void) stopClient;

@end
