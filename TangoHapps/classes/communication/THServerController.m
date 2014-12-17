//
//  THServerController2.m
//  TangoHapps
//
//  Created by Juan Haladjian on 18/09/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THServerController.h"
#import "THAssetCollection.h"
#import "THClientProject.h"

@interface THServerController()

@property (retain, nonatomic) MCNearbyServiceAdvertiser * advertiser;

@end


@implementation THServerController

- (id)init {
    if (self = [super init]) {
        
        _localPeerId = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];

        _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.localPeerId discoveryInfo:nil serviceType:kConnectionServiceType];
        _advertiser.delegate = self;
        
        _invitationHandlers = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    [_session disconnect];
}

//delete this
- (NSString *)stringForPeerConnectionState:(MCSessionState)state
{
    switch (state) {
        case MCSessionStateConnected:
            return @"Connected";
            
        case MCSessionStateConnecting:
            return @"Connecting";
            
        case MCSessionStateNotConnected:
            return @"Not Connected";
    }
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler{
    
    NSLog(@"received invitation");
    
    _session = [[MCSession alloc] initWithPeer:self.localPeerId];
    _session.delegate = self;
    
    invitationHandler(YES,_session);
}

#pragma mark - Public methods

-(void)startServer{
    [self.advertiser startAdvertisingPeer];
}

-(void)stopServer{
    [self.advertiser stopAdvertisingPeer];
    
}

-(NSString*) projectNameMessageForProject:(THProject*) project{
    
    return [NSString stringWithFormat:@"%@",project.name];
}

-(void) pushProjectToAllClients:(THProject*)project {
    [project nonEditableProject];
    
    if(self.session.connectedPeers.count > 0){
        [self sendMessage:[self projectNameMessageForProject:project]];
        
        THClientProject * clientProject = [project nonEditableProject];
        [self sendObject: clientProject];
    }
}

-(void) sendObject:(id<NSCoding>) object {
    NSMutableData * sendBuffer = [[NSMutableData alloc] init];
    [sendBuffer appendData:[NSKeyedArchiver archivedDataWithRootObject:object]];
    
    [self.session sendData:sendBuffer toPeers:self.session.connectedPeers withMode:MCSessionSendDataReliable error:nil];//check for last param
}

- (void) sendData:(NSData *) data {

    NSError *error;
    [self.session sendData:data toPeers:self.session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
    
    if (error) {
        NSLog(@"Error sending message to peers [%@]", error);
    }
}

// Instance method for sending a string bassed text message to all remote peers
- (void)sendMessage:(NSString *)message {
    
    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];

    NSError *error;
    [self.session sendData:messageData toPeers:self.session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
    
    if (error) {
        NSLog(@"Error sending message to peers [%@]", error);
    }
}

#pragma mark - MCSessionDelegate methods

// Override this method to handle changes to peer session state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSLog(@"Peer [%@] changed state to %@", peerID.displayName, [self stringForPeerConnectionState:state]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(state == MCSessionStateConnected){
            [self.delegate server:self peerConnected:peerID.displayName];
        } else if(state == MCSessionStateNotConnected){
            [self.delegate server:self peerDisconnected:peerID.displayName];
        }
    });
}

// MCSession Delegate callback when receiving data from a peer in a given session
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {

    //NSString *receivedMessage = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    //NSLog(@"got msg %@",receivedMessage);
}

// MCSession delegate callback when we start to receive a resource from a peer in a given session
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    //NSLog(@"Start receiving resource [%@] from peer %@ with progress [%@]", resourceName, peerID.displayName, progress);
}

// MCSession delegate callback when a incoming resource transfer ends (possibly with error)
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    if (error) {
        NSLog(@"Error [%@] receiving resource from peer %@ ", [error localizedDescription], peerID.displayName);
    } else {
    }
}

// Streaming API not utilized in this sample code
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    //NSLog(@"Received data over stream with name %@ from peer %@", streamName, peerID.displayName);
}

- (void) session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler
{
    certificateHandler(YES);
}

@end
