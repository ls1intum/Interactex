//
//  THClientConnectionController2.m
//  TangoHapps
//
//  Created by Juan Haladjian on 29/09/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THClientConnectionController2.h"
#import "THAssetCollection.h"

@interface THClientConnectionController2()

@property (retain, nonatomic) MCNearbyServiceBrowser * browser;

@end

@implementation THClientConnectionController2

#pragma mark - MCSessionDelegate methods

// Session container designated initializer
- (id)init{
    if (self = [super init]) {
        
        _localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
        
        _browser = [[MCNearbyServiceBrowser alloc] initWithPeer:_localPeerID serviceType:kConnectionServiceType];
        
        _browser.delegate = self;
        
        //self.foundPeers = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    [_browser stopBrowsingForPeers];
    [_session disconnect];
}


#pragma mark - Browser methods

-(void) startClient{
    [self.browser startBrowsingForPeers];
}

-(void) stopClient{
    [self.browser stopBrowsingForPeers];
    [self.session disconnect];
}

//delete this method
- (NSString *)stringForPeerConnectionState:(MCSessionState)state {
    switch (state) {
        case MCSessionStateConnected:
            return @"Connected";
            
        case MCSessionStateConnecting:
            return @"Connecting";
            
        case MCSessionStateNotConnected:
            return @"Not Connected";
    }
}

#pragma mark - Browser delegate

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info{
    
    _session = [[MCSession alloc] initWithPeer:_localPeerID securityIdentity:nil encryptionPreference:MCEncryptionNone];
    _session.delegate = self;
    
    [browser invitePeer:peerID toSession:self.session withContext:nil timeout:0];
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID{
    //[self.foundPeers removeObject:peerID];
}

#pragma mark - MCSessionDelegate methods

// Override this method to handle changes to peer session state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    //NSLog(@"Peer [%@] changed state to %@", peerID.displayName, [self stringForPeerConnectionState:state]);
    /*
    NSString *adminMessage = [NSString stringWithFormat:@"'%@' is %@", peerID.displayName, [self stringForPeerConnectionState:state]];
    NSLog(@"%@",adminMessage);*/
    
    /*
    // Create an local transcript
    Transcript *transcript = [[Transcript alloc] initWithPeerID:peerID message:adminMessage direction:TRANSCRIPT_DIRECTION_LOCAL];
    
    // Notify the delegate that we have received a new chunk of data from a peer
    [self.delegate receivedTranscript:transcript];*/
}

// MCSession Delegate callback when receiving data from a peer in a given session
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    if(receivingState == kReceivingStateNone){
        
        NSString *projectName = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate didStartReceivingProjectNamed:projectName];
        });
                       
        receivingState = kReceivingStateShouldReceiveProject;
        
    } else if(receivingState == kReceivingStateShouldReceiveAssets){
        /*
        THAssetCollection * assets = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self.delegate didReceiveAssets:assets];
         */
        receivingState = kReceivingStateShouldReceiveProject;
        
    } else if(receivingState == kReceivingStateShouldReceiveProject){
        
        THClientProject * project = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate didFinishReceivingProject:project];
        });
        
        receivingState = kReceivingStateNone;
    }
    
    /*
    // Create an received transcript
    Transcript *transcript = [[Transcript alloc] initWithPeerID:peerID message:receivedMessage direction:TRANSCRIPT_DIRECTION_RECEIVE];
    
    // Notify the delegate that we have received a new chunk of data from a peer
    [self.delegate receivedTranscript:transcript];*/
}

// MCSession delegate callback when we start to receive a resource from a peer in a given session
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    NSLog(@"Start receiving resource [%@] from peer %@ with progress [%@]", resourceName, peerID.displayName, progress);
    /*
    // Create a resource progress transcript
    Transcript *transcript = [[Transcript alloc] initWithPeerID:peerID imageName:resourceName progress:progress direction:TRANSCRIPT_DIRECTION_RECEIVE];
    // Notify the UI delegate
    [self.delegate receivedTranscript:transcript];*/
}


// MCSession delegate callback when a incoming resource transfer ends (possibly with error)
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    // If error is not nil something went wrong
    if (error)
    {
        NSLog(@"Error [%@] receiving resource from peer %@ ", [error localizedDescription], peerID.displayName);
    }  else  {
        // No error so this is a completed transfer.  The resources is located in a temporary location and should be copied to a permenant locatation immediately.
        // Write to documents directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *copyPath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], resourceName];
        if (![[NSFileManager defaultManager] copyItemAtPath:[localURL path] toPath:copyPath error:nil])
        {
            NSLog(@"Error copying resource to documents directory");
        }
        else {
            /*
            // Get a URL for the path we just copied the resource to
            NSURL *imageUrl = [NSURL fileURLWithPath:copyPath];
            
            // Create an image transcript for this received image resource
            Transcript *transcript = [[Transcript alloc] initWithPeerID:peerID imageUrl:imageUrl direction:TRANSCRIPT_DIRECTION_RECEIVE];
            [self.delegate updateTranscript:transcript];*/
        }
    }
}

// Streaming API not utilized in this sample code
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    NSLog(@"Received data over stream with name %@ from peer %@", streamName, peerID.displayName);
}

- (void) session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler
{
    certificateHandler(YES);
}
@end
