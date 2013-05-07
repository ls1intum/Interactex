//
//  THFirstViewController.m
//  TangoHappsClient
//
//  Created by Juan Haladjian on 9/24/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THConnectionViewController.h"
#import "THClientScene.h"
#import "THClientAppViewController.h"
#import "THSimulableWorldController.h"
#import "THClientScene.h"
#import "THLilyPad.h"
#import "THPinValue.h"
#import "THPin.h"
#import "THBoardPin.h"
#import "THClientProject.h"
#import "THAssetCollection.h"

@implementation THConnectionViewController


-(BOOL)isConnectedToServer
{
    return (connectedPeerID != nil);
}

- (void)viewDidAppear:(BOOL)animated{
    [tableView reloadData];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    servers = [NSMutableDictionary dictionary];
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = NO;
    tableView.backgroundView = nil;
    progressBar.hidden = YES;
    statusLabel.hidden = YES;
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
    if(!session)
        return;
    [session disconnectFromAllPeers];
    [session setAvailable:NO];
    [session setDataReceiveHandler:nil withContext:nil];
    [session setDelegate:nil];
    session = nil;
}

-(void)disconnectFromServer {
    if(connectedPeerID){
        [session cancelConnectToPeer:connectedPeerID];
        [session disconnectFromAllPeers];
    }
    connectedPeerID = nil;
    _transferAgent = nil;
}

-(void)connectToServerWithID:(NSString*)peerID {
    if(!session) return;
    NSMutableDictionary *server = [servers objectForKey:peerID];
    if(!server) return;
    GKPeerConnectionState state = (GKPeerConnectionState)[(NSNumber*)[server objectForKey:@"state"] integerValue];
    if(state == GKPeerStateAvailable){
        if(connectedPeerID)
            [self disconnectFromServer];
        connectedPeerID = peerID;
        [session connectToPeer:peerID withTimeout:10];
    }
}

#pragma mark - Session Delegate

-(void)session:(GKSession *)aSession
          peer:(NSString *)peerID
didChangeState:(GKPeerConnectionState)state {
    NSString *serverName = [session displayNameForPeer:peerID];
    switch (state) {
        case GKPeerStateUnavailable:{
           // NSLog(@"<Client> peer %@ became unavailable", peerID);
            [servers removeObjectForKey:peerID];
            _transferAgent = nil;
            break;
        }
        case GKPeerStateAvailable:{
           // NSLog(@"<Client> peer %@ became available", peerID);
            NSMutableDictionary *server = [NSMutableDictionary dictionary];
            [server setObject:serverName forKey:@"name"];
            [server setObject:[NSNumber numberWithInt:state] forKey:@"state"];
            [servers setObject:server forKey:peerID];
            break;
        }
        case GKPeerStateConnected:{
            //NSLog(@"<Client> peer %@ connected", peerID);
            NSMutableDictionary *server = [servers objectForKey:peerID];
            if(server != nil){
                [server setObject:serverName forKey:@"name"];
                [server setObject:[NSNumber numberWithInt:state] forKey:@"state"];
                _transferAgent = [TransferAgent slaveAgentForServerPeerID:peerID session:session];
                [_transferAgent setDelegate:self];
            }
            break;
        }
        case GKPeerStateDisconnected:{
           // NSLog(@"<Client> peer %@ disconnected", peerID);
            NSMutableDictionary *server = [servers objectForKey:peerID];
            if(server != nil){
                _transferAgent = nil;
                [(NSMutableDictionary*)server setObject:[NSNumber numberWithInt:state] forKey:@"state"];
                [servers removeObjectForKey:peerID];
            }
            break;
        }
        default:
            break;
    }
    [tableView reloadData];
}

- (void)receiveData:(NSData *)data
           fromPeer:(NSString *)peer
          inSession:(GKSession *)session
            context:(void *)context {
    if(_transferAgent)
        [_transferAgent receiveData:data];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWifiCellHeightCollapsed;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [servers count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"clientCell";
    NSMutableDictionary *server = [servers objectForKey:[[servers allKeys] objectAtIndex:indexPath.row]];
    GKPeerConnectionState state = (GKPeerConnectionState)[(NSNumber*)[server objectForKey:@"state"] integerValue];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell){
       NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"PeerCellClient" owner:self options:nil];
        cell = [views objectAtIndex:0];
    }
    
    [(UILabel*)[cell viewWithTag:1] setText:[server objectForKey:@"name"]];
    [(UIImageView*)[cell viewWithTag:2] setImage:[UIImage imageNamed:@"server_peer.png"]];
    if(state == GKPeerStateConnected){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    if(state == GKPeerStateConnecting){
        [(UIActivityIndicatorView*)[cell viewWithTag:3] startAnimating];
    }else{
        [(UIActivityIndicatorView*)[cell viewWithTag:3] stopAnimating];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)aTableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(!session)
        return;
    NSString *peerID = [[servers allKeys] objectAtIndex:indexPath.row];
    [self connectToServerWithID:peerID];
}

#pragma mark - Transfer Agent Delegate

- (void)agent:(TransferAgent*)anAgent
willBeginAction:(TransferAgentAction)action {
    NSString *label = [_transferAgent labelForAction:action];
    if(label){
        [progressBar setProgress:0.0f];
        [statusLabel setText:label];
    }
    progressBar.hidden = (label == nil);
    statusLabel.hidden = (label == nil);
    _externalProgressBar.hidden = (label == nil);
}

- (void)agent:(TransferAgent*)agent
madeProgressForCurrentAction:(float)progress {
    [progressBar setProgress:progress];
    [_externalProgressBar setProgress:progress];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    _clientAppViewController = segue.destinationViewController;
    _clientAppViewController.transferAgent = _transferAgent;
    [_clientAppViewController reloadApp];
}

-(void) viewWillAppear:(BOOL)animated{
    
    [THSimulableWorldController sharedInstance].currentScene = nil;
    [THSimulableWorldController sharedInstance].currentProject = nil;
    
    [self startClient];
}

-(void) updateLilypadPinsWithPins:(NSMutableArray*) pins{
    //NSLog(@"received: %d", pins.count);
    
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
    }
}

- (void)agent:(TransferAgent*)agent
didFinishAction:(TransferAgentAction)action
     withObject:(id)object {
    progressBar.hidden = YES;
    statusLabel.hidden = YES;
    _externalProgressBar.hidden = YES;

    if(action == kTransferAgentActionScene){
        THClientProject * project = object;
        
        [THSimulableWorldController sharedInstance].currentProject = project;       
        
        if(self.navigationController.topViewController == self){
            [self performSegueWithIdentifier:@"segueToAppView" sender:self];
        } else {
            [_clientAppViewController reloadApp];
        }
        
    } else if(action == kTransferActionInputPinState){
        [self updateLilypadPinsWithPins:object];
    } else if(action == kTransferActionAssets){
        if([object isKindOfClass:[NSArray class]]){
            NSLog(@"asset list");
            
            NSArray * assetDescriptions = [THAssetCollection assetDescriptionsWithMissingAssetsIn:(NSArray*) object];
            [_transferAgent queueAction:kTransferActionMissingAssets withObject:assetDescriptions];
            
        } else if([object isKindOfClass:[THAssetCollection class]]){
            // Received exported assets, import to local library and finish
            NSLog(@"<TA:Client> Finished receiving exported assets object from server");
            NSArray * assets = (NSArray*)object;
            [THAssetCollection importAssets:assets];
        }
    }
}

- (void)agent:(TransferAgent *)agent
didChangeQueueLengthTo:(NSUInteger)items {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
