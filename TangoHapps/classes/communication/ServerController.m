
#import "ServerController.h"
#import "THClientProject.h"
#import "THLilypadEditable.h"
#import "THLilyPad.h"
#import "THBoardPin.h"
#import "THPinValue.h"
#import "THClientProject.h"
#import "THAssetCollection.h"

@implementation ServerController
@dynamic serverIsRunning;

/*
-(id)initWithNibName:(NSString *)nibNameOrNil 
              bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        _peers = [NSMutableDictionary dictionary];
        _agents = [NSMutableDictionary dictionary];
    }
    return self;
}*/

-(id) init{
    self = [super init];
    if(self){
        _peers = [NSMutableDictionary dictionary];
        _agents = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Properties

-(BOOL)serverIsRunning
{
    return (session != nil);
}

-(CGSize)contentSizeForViewInPopover
{
    return CGSizeMake(320, 200);
}

/*
#pragma mark - View Lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table View Data Source

- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section
{
    return @"Connected devices";
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView 
numberOfRowsInSection:(NSInteger)section
{
    return _peers.count;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *peer = [_peers objectForKey:[[_peers allKeys] objectAtIndex:indexPath.row]];
    NSString *action = [peer objectForKey:@"action"];
    return (action == nil ? kWifiCellHeightCollapsed : kWifiCellHeightExtended);
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *peer = [_peers objectForKey:[[_peers allKeys] objectAtIndex:indexPath.row]];
    static NSString *peerCellId = @"clientCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:peerCellId];
    if(cell == nil){
        //cell = [[NSBundle mainBundle] loadNibNamed:@"PeerCellServer" owner:self options:nil];
        
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"PeerCellServer" owner:nil options:nil];
        cell = [views objectAtIndex:0];
    }
    [(UILabel*)[cell viewWithTag:1] setText:[peer objectForKey:@"name"]];
    [(UIImageView*)[cell viewWithTag:2] setImage:[UIImage imageNamed:@"client_peer.png"]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSString *action = [peer objectForKey:@"action"];
    if(action){
        float progress = [(NSNumber*)[peer objectForKey:@"progress"] floatValue];
        [(UILabel*)[cell viewWithTag:4] setText:action];
        [(UIProgressView*)[cell viewWithTag:5] setProgress:progress];
    }
    
    return cell;
}
*/

#pragma mark - Server Control

-(void)startServer
{
    if(session) 
        [self stopServer];
    session = [[GKSession alloc] initWithSessionID:kGameKitSessionId displayName:nil sessionMode:GKSessionModeServer];
    [session setDelegate:self];
    [session setAvailable:YES];
    [session setDataReceiveHandler:self withContext:nil];
    [_delegate server:self isRunning:YES];
}

-(void)stopServer
{
    if(!session)
        return;
    [_delegate server:self isRunning:NO];
    [_delegate server:self isReadyForSceneTransfer:NO];
    [session disconnectFromAllPeers];
    [session setAvailable:NO];
    [session setDataReceiveHandler: nil withContext: nil];
    [session setDelegate:nil];
    session = nil;
    [_peers removeAllObjects];
}

#pragma mark- Transfer Agent Hub

-(void) startPushingLilypadStateToAllClients{
    
    _transferTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(pushLilypadStateToAllClients) userInfo:nil repeats:YES];
}

-(void) stopPushingLilypadState{
    [_transferTimer invalidate];
    _transferTimer = nil;
}

-(void) pushLilypadStateToAllClients{
    THCustomProject * project = (THCustomProject*) [TFDirector sharedDirector].currentProject;
    THLilyPadEditable * lilypadEditable = project.lilypad;
    THLilyPad * lilypad = (THLilyPad*) lilypadEditable.simulableObject;
    
    NSArray * lilypins = lilypad.pins;
    NSMutableArray * pins = [NSMutableArray array];
    
    for (THBoardPin * pin in lilypins) {
        if(pin.mode == kPinModeDigitalInput && pin.hasChanged){
            THPinValue * pinValue = [[THPinValue alloc] init];
            pinValue.type = pin.type;
            pinValue.value = pin.currentValue;
            pinValue.number = pin.number;
            [pins addObject:pinValue];
            
            pin.hasChanged = NO;
        }
    }
    
    //NSLog(@"transferring: %d pins",pins.count);
    
    [self queueTransferAgentActionOnAllClients:kTransferActionInputPinState withObject:pins];
}

-(void)pushAssetListToAllClients:(NSArray*)assetList
{
    NSLog(@"queing assets: %d",assetList.count);
    [self queueTransferAgentActionOnAllClients:kTransferActionAssets withObject:assetList];
}

-(void)pushProjectToAllClients:(THCustomProject*)project
{
    THClientProject * cientProject = [project nonEditableProject];
    THAssetCollection * assetCollection = project.assetCollection;
    [self pushAssetListToAllClients:assetCollection.assetDescriptions];
    [self queueTransferAgentActionOnAllClients:kTransferAgentActionScene withObject:cientProject];
}

- (void)queueTransferAgentActionOnAllClients:(TransferAgentAction)action
                                  withObject:(id)object
{
    for(NSString *peerID in _agents.allKeys){
        [self queueTransferAgentAction:action onClient:peerID withObject:object];
    }
}

- (void)queueTransferAgentAction:(TransferAgentAction)action
                        onClient:(NSString*)peerID
                      withObject:(id)object
{
    TransferAgent *agent = (TransferAgent*)[_agents objectForKey:peerID];
    [agent queueAction:action withObject:object];
}

#pragma mark - Session Delegate

- (void)session:(GKSession *)aSession 
didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
    NSError *error;
    [session acceptConnectionFromPeer:peerID error:&error];
}

- (void)session:(GKSession *)aSession 
           peer:(NSString *)peerID 
 didChangeState:(GKPeerConnectionState)state
{
    if(state == GKPeerStateDisconnected){
        NSLog(@"<Server> peer %@ disconnected", peerID);
        // Remove the peer info dict and its agent
        [_peers removeObjectForKey:peerID];
        [_agents removeObjectForKey:peerID];
        [_delegate server:self peerDisconnected:[session displayNameForPeer:peerID]];
    }
    if(state == GKPeerStateConnected){
        NSLog(@"<Server> peer %@ connected", peerID);
        // Create an info dict for the peer
        NSString *peerName = [session displayNameForPeer:peerID];
        NSMutableDictionary *peer = [NSMutableDictionary dictionary];
        [peer setObject:peerName forKey:@"name"];
        [peer setObject:[NSNumber numberWithInt:state] forKey:@"state"];
        [peer setObject:[NSNumber numberWithInt:0] forKey:@"queued_actions"];
        [_peers setValue:peer forKey:peerID];
        
        // Create an agent for the peer
        TransferAgent *agent = [TransferAgent masterAgentForClientPeerID:peerID session:session];
        [agent setDelegate:self];
        [_agents setObject:agent forKey:peerID];
        [_delegate server:self peerConnected:peerName];
    }
    [self updateBusyState];
    //[self.tableView reloadData];
    [_delegate server:self isReadyForSceneTransfer:([_agents count] > 0)];
}

- (void)receiveData:(NSData *)data
           fromPeer:(NSString *)peer
          inSession:(GKSession *)session
            context:(void *)context
{
    // Pass the received data along to the responsible agent
    TransferAgent *agent = (TransferAgent*)[_agents objectForKey:peer];
    if(agent){
        [agent receiveData:data];
    }
}

#pragma mark - Transfer Agent Delegate

-  (void)agent:(TransferAgent*)agent
willBeginAction:(TransferAgentAction)action
{
    NSString *label = [agent labelForAction:action];
    NSMutableDictionary *peer = (NSMutableDictionary*)[_peers objectForKey:[agent peerID]];
    if(label){
        [peer setObject:[NSNumber numberWithFloat:0.0f] forKey:@"progress"];
        [peer setObject:label forKey:@"action"];
    }else{
        [peer removeObjectForKey:@"action"];
    }
    //[self.tableView reloadData];
    [self updateBusyState];
}

- (void)agent:(TransferAgent*)agent
madeProgressForCurrentAction:(float)progress
{
    NSMutableDictionary *peer = (NSMutableDictionary*)[_peers objectForKey:[agent peerID]];
    [peer setObject:[NSNumber numberWithFloat:progress] forKey:@"progress"];
    //[self.tableView reloadData];
}

-   (void)agent:(TransferAgent*)agent
didFinishAction:(TransferAgentAction)action
     withObject:(id)object
{
    NSMutableDictionary *peer = (NSMutableDictionary*)[_peers objectForKey:[agent peerID]];
    [peer removeObjectForKey:@"action"];
    //[self.tableView reloadData];
    [self updateBusyState];
    
    //[[THCustomSimulator sharedInstance] updateLilypadPinsWithPins:object];
}

- (void)agent:(TransferAgent*)agent
didChangeQueueLengthTo:(NSUInteger)items
{
    NSMutableDictionary *peer = (NSMutableDictionary*)[_peers objectForKey:[agent peerID]];
    [peer setObject:[NSNumber numberWithInt:items] forKey:@"queued_actions"];
    //[self.tableView reloadData];
}

- (void)updateBusyState
{
    int busyAgents = 0;
    for(NSString* peerID in _agents){
        TransferAgent *agent = [_agents objectForKey:peerID];
        if(![agent isIdle]) busyAgents++;
    }
    [_delegate server:self isTransferring:(busyAgents > 0)];
}

@end
