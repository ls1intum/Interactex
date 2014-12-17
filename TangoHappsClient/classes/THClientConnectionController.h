//
//  THClientConnectionController2.h
//  TangoHapps
//
//  Created by Juan Haladjian on 29/09/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MultipeerConnectivity;

@class THAssetCollection;

typedef enum{
    kReceivingStateNone,
    kReceivingStateShouldReceiveAssets,
    kReceivingStateShouldReceiveProject
} THClientReceivingState;

@protocol THClientConnectionControllerDelegate <NSObject>

-(void) didStartReceivingProjectNamed:(NSString*) name;
-(void) didMakeProgressForCurrentProject:(float) progress;
-(void) didFinishReceivingProject:(THClientProject*) project;
-(void) didReceiveAssets:(THAssetCollection*) assets;
@end

@interface THClientConnectionController : NSObject <MCSessionDelegate, MCNearbyServiceBrowserDelegate>{
    
    THClientReceivingState receivingState;
}

@property (readonly, nonatomic) MCPeerID * localPeerID;
@property (readonly, nonatomic) MCSession * session;
@property (readonly) BOOL isConnectedToServer;
@property (copy, nonatomic) NSString * connectedPeerID;
@property (weak, nonatomic) id<THClientConnectionControllerDelegate> delegate;

-(void) startClient;
-(void) stopClient;

@end
