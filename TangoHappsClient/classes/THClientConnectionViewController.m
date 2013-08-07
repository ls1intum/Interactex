//
//  THFirstViewController.m
//  TangoHappsClient
//
//  Created by Juan Haladjian on 9/24/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THClientConnectionViewController.h"
#import "THClientRealScene.h"
#import "THClientAppViewController.h"
#import "THClientRealScene.h"
#import "THLilyPad.h"
#import "THPinValue.h"
#import "THPin.h"
#import "THBoardPin.h"
#import "THClientProject.h"
#import "THAssetCollection.h"
#import "THClientServer.h"
#import "THClientServerCell.h"

@implementation THClientConnectionViewController

-(BOOL)isConnectedToServer {
    return (self.connectedServer);
}

- (void)viewDidAppear:(BOOL)animated{
    [self.table reloadData];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    servers = [NSMutableArray array];
}

-(void) viewWillAppear:(BOOL)animated{
        
    [self startClient];
}

-(void) viewWillDisappear:(BOOL)animated{
    [self stopClient];
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
    }
}

- (IBAction)refreshTapped:(id)sender {
    session.available = YES;
}

-(void)disconnectFromServer {
    if(self.connectedServer){
        [session cancelConnectToPeer:self.connectedServer.peerID];
        [session disconnectFromAllPeers];
    }
    _connectedServer = nil;
    transferAgent = nil;
}


-(void)connectToServer:(THClientServer*)server {
    
    if(self.isConnectedToServer){
        [self disconnectFromServer];
    }
    _connectedServer = server;
    [session connectToPeer:server.peerID withTimeout:10];
}

#pragma mark - Session Delegate

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
}

-(void)session:(GKSession *)aSession
          peer:(NSString *)peerID
didChangeState:(GKPeerConnectionState)state {
    NSString *serverName = [session displayNameForPeer:peerID];
    
   // NSLog(@"name: %@ peerID: %@ state: %d",serverName,peerID,state);
    
    switch (state) {
        case GKPeerStateUnavailable:{
            [self removeServerWithPeerId:peerID];
            transferAgent = nil;
            break;
        }
            
        case GKPeerStateAvailable:{
            THClientServer * server = [[THClientServer alloc] init];
            server.name = serverName;
            server.state = state;
            server.peerID = peerID;
            [servers addObject:server];
            
            break;
        }
            
        case GKPeerStateConnecting:{
            
            THClientServer * server = [self serverWithPeerId:peerID];
            if(server){
                server.state = THClientServerStateConnecting;
            }
            
            break;
        }
            
        case GKPeerStateConnected:{

            THClientServer * server = [self serverWithPeerId:peerID];
            if(server){
                server.name = serverName;
                server.state = THClientServerStateConnected;
                
                transferAgent = [THTransferAgent slaveAgentForServerPeerID:peerID session:session];
                transferAgent.delegate = self;
            }
            break;
        }

        case GKPeerStateDisconnected:{
            THClientServer * server = [self serverWithPeerId:peerID];
            if(server){
                transferAgent = nil;
                server.state = THClientServerStateDisconnected;
                
                if(![self isPeerAvailable:peerID]){
                    [servers removeObject:server];
                }
            }
            break;
        }
            
        default:
            break;
    }
    [self.table reloadData];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return servers.count;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    THClientServerCell *cell = (THClientServerCell*) [self.table dequeueReusableCellWithIdentifier:@"clientConnectionCell"];
    THClientServer * server = [servers objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = server.name;
    
    if(server.state == THClientServerStateConnected){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [cell.activityIndicator stopAnimating];
        cell.progressLabel.hidden = NO;
        cell.progressLabel.text = @"Ready for scene transfer";
    } else if(server.state == THClientServerStateConnecting){
        [cell.activityIndicator startAnimating];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell.activityIndicator stopAnimating];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    [self.table deselectRowAtIndexPath:indexPath animated:YES];
    if(!session)
        return;
    
    THClientServer * server = [servers objectAtIndex:indexPath.row];
    server.state = THClientServerStateConnecting;
    [self connectToServer:server];
        
    THClientServerCell * cell = (THClientServerCell*) [self.table cellForRowAtIndexPath:indexPath];
    [cell.activityIndicator startAnimating];
}

#pragma mark - Transfer Agent Delegate
/*
-(THClientServerCell*) cellForCurrentServer{
    
    NSInteger idx = [servers indexOfObject:self.connectedServer];
    if(idx >= 0 && idx < servers.count){
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        return (THClientServerCell*) [self.table cellForRowAtIndexPath:indexPath];
    }
    return nil;
}*/

-(void) agent:(THTransferAgent *)agent madeProgressForCurrentAction:(float)progress{
       
    [self.delegate didMakeProgressForCurrentProject:progress];
}

- (void)agent:(THTransferAgent*)anAgent willBeginAction:(THTransferAgentAction)action {
    if(action == kTransferActionAssets){
        //[self.delegate didStartReceivingProjectNamed:@"New Project"];
    }
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
        /*
    NSInteger idx = [servers indexOfObject:self.connectedServer];
    if(idx >= 0 && idx < servers.count){
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        THClientServerCell * cell = (THClientServerCell*) [self.table cellForRowAtIndexPath:indexPath];
        
        cell.progressView.hidden = YES;
        cell.progressLabel.hidden = YES;
    }*/
    
    if(action == kTransferAgentActionScene){
        
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

- (void)agent:(THTransferAgent *)agent
didChangeQueueLengthTo:(NSUInteger)items {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    NSLog(@"deallocing ");
}

@end
