//
//  THClientConnectionController2.m
//  TangoHapps
//
//  Created by Juan Haladjian on 29/09/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THClientConnectionController.h"
#import "THAssetCollection.h"

@interface THClientConnectionController()

@property (retain, nonatomic) MCNearbyServiceBrowser * browser;

@end

@implementation THClientConnectionController

NSString * const kNotConnectedText = @"Browsing for peers...";

#pragma mark - MCSessionDelegate methods

- (id)init{
    if (self = [super init]) {
        
        _localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
        self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:_localPeerID serviceType:kConnectionServiceType];
        self.browser.delegate = self;
        
    }
    return self;
}

- (void)dealloc {
    [self.browser stopBrowsingForPeers];
    [self.session disconnect];
}


#pragma mark - Browser methods

-(void) startClient{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate appendStatusMessage:kNotConnectedText];
        [self.browser startBrowsingForPeers];
        
    });
}

-(void) stopClient{
    [self.browser stopBrowsingForPeers];
    [self.session disconnect];
    self.remotePeerID = nil;
}

//delete this method
- (NSString *)stringForPeerConnectionState:(MCSessionState)state {
    switch (state) {
        case MCSessionStateConnected:
            return @"Connected";
            
        case MCSessionStateConnecting:
            return @"Connecting...";
            
        case MCSessionStateNotConnected:
            return kNotConnectedText;
    }
}

#pragma mark - Browser delegate

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info{
    
    _session = [[MCSession alloc] initWithPeer:_localPeerID securityIdentity:nil encryptionPreference:MCEncryptionNone];
    _session.delegate = self;
    self.remotePeerID = peerID;
    
    [self inviteCurrentPeer];
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID{
    self.remotePeerID = nil;
    
    //NSLog(@"lost peer");
}

-(void) browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error{
    //NSLog(@"failed to browse");
}

-(void) inviteCurrentPeer{
    [self.browser invitePeer:self.remotePeerID toSession:self.session withContext:nil timeout:0];
    [self.delegate appendStatusMessage:@"Invited peer..."];
}

#pragma mark - MCSessionDelegate methods

// Override this method to handle changes to peer session state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    
    //NSLog(@"%@",[self stringForPeerConnectionState:state]);
    
    [self.delegate appendStatusMessage:[self stringForPeerConnectionState:state]];
    
    if(state == MCSessionStateNotConnected && session.connectedPeers.count == 0 && self.remotePeerID != nil){
        
        [self inviteCurrentPeer];
    }
}

// MCSession Delegate callback when receiving data from a peer in a given session
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(receivingState == kReceivingStateNone){
            
            NSString *projectName = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
            
            [self.delegate didStartReceivingProjectNamed:projectName];
            
            receivingState = kReceivingStateShouldReceiveProject;
            
        } else if(receivingState == kReceivingStateShouldReceiveAssets){
            /*
             THAssetCollection * assets = [NSKeyedUnarchiver unarchiveObjectWithData:data];
             [self.delegate didReceiveAssets:assets];
             */
            receivingState = kReceivingStateShouldReceiveProject;
            
        } else if(receivingState == kReceivingStateShouldReceiveProject){
            
            THClientProject * project = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            [self.delegate didFinishReceivingProject:project];
            
            receivingState = kReceivingStateNone;
        }
    });
}

// MCSession delegate callback when we start to receive a resource from a peer in a given session
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
    NSLog(@"Start receiving resource [%@] from peer %@ with progress [%@]", resourceName, peerID.displayName, progress);
    [self.delegate appendStatusMessage:[NSString stringWithFormat:@"Start receiving resource [%@] from peer %@ with progress [%@]...", resourceName, peerID.displayName, progress]];
}


// MCSession delegate callback when a incoming resource transfer ends (possibly with error)
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    // If error is not nil something went wrong
    if (error) {
        NSLog(@"Error [%@] receiving resource from peer %@ ", [error localizedDescription], peerID.displayName);
        [self.delegate appendStatusMessage:[NSString stringWithFormat:@"Error [%@] receiving resource from peer %@ ", [error localizedDescription], peerID.displayName]];
    }  else  {
        // No error so this is a completed transfer.  The resources is located in a temporary location and should be copied to a permenant locatation immediately.
        // Write to documents directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *copyPath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], resourceName];
        if (![[NSFileManager defaultManager] copyItemAtPath:[localURL path] toPath:copyPath error:nil])
        {
            NSLog(@"Error copying resource to documents directory");
            [self.delegate appendStatusMessage:[NSString stringWithFormat:@"Error copying resource to documents directory"]];
        }
        else {
        }
    }
}

// Streaming API not utilized in this sample code
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    NSLog(@"Received data over stream with name %@ from peer %@", streamName, peerID.displayName);
    [self.delegate appendStatusMessage:[NSString stringWithFormat:@"Received data over stream with name %@ from peer %@...", streamName, peerID.displayName]];
}

- (void) session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler
{
    certificateHandler(YES);
}
@end
