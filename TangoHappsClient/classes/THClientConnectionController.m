//
//  THFirstViewController.m
//  TangoHappsClient
//
//  Created by Juan Haladjian on 9/24/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THClientConnectionController.h"
#import "THClientScene.h"
#import "THClientAppViewController.h"
#import "THClientScene.h"
#import "THLilyPad.h"
#import "THPinValue.h"
#import "THPin.h"
#import "THBoardPin.h"
#import "THClientProject.h"
#import "THAssetCollection.h"

@implementation THClientConnectionController

-(id) init{
    self = [super init];
    if(self){
        //servers = [NSMutableArray array];
    }
    return self;
}

-(BOOL)isConnectedToServer {
    return (self.connectedPeerID);
}

-(void)startClient {
    if(session)
        [self stopClient];
    session = [[GKSession alloc] initWithSessionID:kGameKitSessionId displayName:nil sessionMode:GKSessionModeClient];
    [session setDelegate:self];
    [session setDataReceiveHandler:self withContext:nil];
    [session setAvailable:YES];
}

-(void)stopClient {
    if(session){
        [session disconnectFromAllPeers];
        [session setAvailable:NO];
        [session setDataReceiveHandler:nil withContext:nil];
        [session setDelegate:nil];
        session = nil;
        self.connectedPeerID = nil;
    }
}

-(void)disconnectFromServer {
    if(self.isConnectedToServer){
        [session cancelConnectToPeer:self.connectedPeerID];
        [session disconnectFromAllPeers];
    }
    self.connectedPeerID = nil;
    transferAgent = nil;
}

-(void)connectToServerWithPeerID:(NSString*)peerID {
    
    if(!self.isConnectedToServer){
        //[self disconnectFromServer];
        
        //connectedPeerID = peerID;
        [session connectToPeer:peerID withTimeout:10];
    }
}

#pragma mark - Session Delegate
/*
-(THClientServer*) serverWithPeerId:(NSString*) peerId{

    for (THClientServer * server in servers) {
        if([server.peerID isEqualToString:peerId]){
            return server;

        }
    }
    return nil;
}

-(void) removeServerWithPeerId:(NSString*) peerId{
    THClientServer * toRemove = [self serverWithPeerId:peerId];
    if(toRemove){
        [servers removeObject:toRemove];
    }
}

-(BOOL) isPeerAvailable:(NSString*) peerID{
    NSArray * availablePeers = [session peersWithConnectionState:GKPeerStateAvailable];
    for (NSString * aPeerID in availablePeers) {
        if([aPeerID isEqualToString:peerID]){
            return YES;
        }
    }
    return NO;
}*/

-(void)session:(GKSession *)aSession
          peer:(NSString *)peerID
didChangeState:(GKPeerConnectionState)state {
    
    switch (state) {
        case GKPeerStateUnavailable:{
            //[self removeServerWithPeerId:peerID];
            transferAgent = nil;
            break;
        }
            
        case GKPeerStateAvailable:{//connect to first thing available
            
            [self connectToServerWithPeerID:peerID];
            
            break;
        }

        case GKPeerStateConnected:{
            self.connectedPeerID = peerID;
            
            transferAgent = [THTransferAgent slaveAgentForServerPeerID:peerID session:session];
            transferAgent.delegate = self;
            break;
        }

        case GKPeerStateDisconnected:{
            if([peerID isEqualToString:self.connectedPeerID]){
                self.connectedPeerID = nil;
                transferAgent = nil;
            }
            break;
        }
            
        default:
            break;
    }
}

-(void) session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error{
    NSLog(@"connection failed: %@",error);
}

-(void) session:(GKSession *)session didFailWithError:(NSError *)error{
    NSLog(@"failed %@",error);
}

- (void)receiveData:(NSData *)data
           fromPeer:(NSString *)peer
          inSession:(GKSession *)session
            context:(void *)context {
    if(transferAgent)
        [transferAgent receiveData:data];
}

#pragma mark - Transfer Agent Delegate

-(void) agent:(THTransferAgent *)agent madeProgressForCurrentAction:(float)progress{
       
    [self.delegate didMakeProgressForCurrentProject:progress];
}

- (void)agent:(THTransferAgent*)anAgent willBeginAction:(THTransferAgentAction)action {
   
}

-(void) updateLilypadPinsWithPins:(NSMutableArray*) pins{
    //NSLog(@"received: %d", pins.count);
    /*
    THClientProject * project = [THSimulableWorldController sharedInstance].currentProject;
    if(project != nil){
        THLilyPad * lilypad = project.lilypad;
        for (THPinValue * pinvalue in pins) {
            THBoardPin * pin;
            if(pinvalue.type == kPintypeDigital) {
                pin = [lilypad digitalPinWithNumber:pinvalue.number];
            } else if(pinvalue.type == kPintypeAnalog){
                pin = [lilypad analogPinWithNumber:pinvalue.number];
            }
            
            pin.currentValue = pinvalue.value;
        }
    }*/
}

- (void)agent:(THTransferAgent*)agent didFinishAction:(THTransferAgentAction)action withObject:(id)object {
    
    if(action == kTransferActionSceneName){
        
        [self.delegate didStartReceivingProjectNamed:object];
        
    } else if(action == kTransferActionScene){
        
        [self.delegate didFinishReceivingProject:object];
        
    } else if(action == kTransferActionAssets){
        /*
        if([object isKindOfClass:[NSArray class]]){
            NSLog(@"asset list");
            
            NSArray * assetDescriptions = [THAssetCollection assetDescriptionsWithMissingAssetsIn:(NSArray*) object];
            [transferAgent queueAction:kTransferActionMissingAssets withObject:assetDescriptions];
            
        } else if([object isKindOfClass:[THAssetCollection class]]){
            // Received exported assets, import to local library and finish
            NSLog(@"<TA:Client> Finished receiving exported assets object from server");
            NSArray * assets = (NSArray*)object;
            [THAssetCollection importAssets:assets];
        }*/
    }
}

- (void)agent:(THTransferAgent *)agent didChangeQueueLengthTo:(NSUInteger)items {
    
}

@end
