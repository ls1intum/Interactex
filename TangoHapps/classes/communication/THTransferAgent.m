
#import "THTransferAgent.h"

@implementation THTransferAgent

NSString * const kTransferActionTexts[kNumTransferActions] = {@"Idle",@"Scene Name", @"Scene",@"Assets",@"Missing Assets"};

+(THTransferAgent *)masterAgentForClientPeerID:(NSString *)peerID
                                     session:(GKSession *)session
{
    return [[THTransferAgent alloc] initWithSession:session peerID:peerID inMode:kTransferAgentModeMaster];
}

+(THTransferAgent *)slaveAgentForServerPeerID:(NSString *)peerID
                                    session:(GKSession *)session
{
    return [[THTransferAgent alloc] initWithSession:session peerID:peerID inMode:kTransferAgentModeSlave];
}

-(id)initWithSession:(GKSession *)newSession
              peerID:(NSString *)newPeerID
              inMode:(THTransferAgentMode)newMode
{
    self = [super init];
    if(self){
        mode = newMode;
        session = newSession;
        peerID = newPeerID;
        socket = [[THProtocolSocket alloc] initWithSession:session peerID:peerID];
        [socket setDelegate:self];
        currentAction = kTransferActionIdle;
        actionQueue= [NSMutableArray array];
        objectQueue = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Properties

-(BOOL)isIdle
{
    return (currentAction == kTransferActionIdle);
}

-(NSString *)peerID
{
    return peerID;
}

-(NSUInteger)queuedActions
{
    return [objectQueue count];
}

#pragma mark - Data reception

-(void)receiveData:(NSData *)data
{
    [socket receiveData:data];
}

#pragma mark - Actions

- (void)queueAction:(THTransferAgentAction)action
         withObject:(id)object {
    
    if(object == nil) {
        [objectQueue addObject:[NSNull null]];
    } else {
        [objectQueue addObject:object];
    }
    
    [actionQueue addObject:[NSNumber numberWithInt:(int)action]];
    
    if([self isIdle])
        [self performNextAction];
}

- (void)performNextAction {
    
    if([objectQueue count] == 0)
        return;
    
    currentAction = (THTransferAgentAction)[(NSNumber*)[actionQueue objectAtIndex:0] integerValue];
    id object = [objectQueue objectAtIndex:0];
    if(object == [NSNull null]) object = nil;
    [actionQueue removeObjectAtIndex:0];
    [objectQueue removeObjectAtIndex:0];
    [self.delegate agent:self willBeginAction:currentAction];
        
    switch (currentAction) {
        case kTransferActionIdle:{
            [self finishCurrentAction];
            break;
        }
        case kTransferActionSceneName:{
            [socket sendObject:object withIdentifier:kProtocolObjectSceneName];
            break;
        }
        case kTransferActionScene:{
            [socket sendObject:object withIdentifier:kProtocolObjectScene];
            break;
        }
        case kTransferActionAssets:{
            [socket sendObject:object withIdentifier:kProtocolObjectAssets];
            break;
        }
        case kTransferActionMissingAssets:{
            [socket sendObject:object withIdentifier:kProtocolObjectMissingAssets];
            break;
        }
    }
}

- (void)finishCurrentAction {
    [self finishCurrentActionWithObject:nil];
}

- (void)finishCurrentActionWithObject:(id)object {
    [self.delegate agent:self didFinishAction:currentAction withObject:object];
    currentAction = kTransferActionIdle;
    [self performNextAction];
}

- (void)finishAction:(THTransferAgentAction)action withObject:(id)object {
    [self.delegate agent:self didFinishAction:action withObject:object];
    currentAction = kTransferActionIdle;
    [self performNextAction];
}

- (void)cancelQueuedActions {
    [actionQueue removeAllObjects];
    [objectQueue removeAllObjects];
}

- (void)cancelCurrentAndQueuedActions {
    [socket cancelSendingAndEmptyQueue];
    [self cancelQueuedActions];
}

#pragma mark - Protocol Socket Delegate (Sending)

- (void)socket:(THProtocolSocket*)socket didBeginSendingObjectWithIdentifier:(THProtocolObjectIdentifier) identifier {

}

- (void)socket:(THProtocolSocket*)socket willSendChunk:(int)chunk of:(int)chunks {
    [self.delegate agent:self madeProgressForCurrentAction:((float)chunk / (float)chunks)];
}

- (void)socket:(THProtocolSocket*)socket didFinishSendingObjectWithIdentifier:(THProtocolObjectIdentifier)identifier {
    if(mode == kTransferAgentModeMaster){
        if((currentAction == kTransferActionSceneName && identifier == kProtocolObjectSceneName) ||
           (currentAction == kTransferActionScene && identifier == kProtocolObjectScene) ||
           (currentAction == kTransferActionAssets && identifier == kProtocolObjectAssets)){
            [self finishCurrentAction];
        }
    }
}

- (void)socket:(THProtocolSocket *)socket
didAbortSendingObjectWithIdentifier:(THProtocolObjectIdentifier)identifier
{
    
}

#pragma mark - Protocol Socket Delegate (Receiving)

- (void)socket:(THProtocolSocket*)socket didBeginReceivingObjectWithIdentifier:(THProtocolObjectIdentifier)identifier {
    
    if(mode == kTransferAgentModeSlave){
        switch (identifier) {
                
            case kProtocolObjectSceneName:
                currentAction = kTransferActionSceneName;
                break;
                
            case kProtocolObjectScene:
                currentAction = kTransferActionScene;
                break;
                
            case kProtocolObjectMissingAssets:
                currentAction = kTransferActionMissingAssets;
                break;
                
            case kProtocolObjectAssets:
                currentAction = kTransferActionAssets;
                break;
                
            default:
                break;
        }
        
        [self.delegate agent:self willBeginAction:currentAction];
    }
}

- (void)socket:(THProtocolSocket*)socket didReceiveChunk:(int)chunk of:(int)chunks {
    [self.delegate agent:self madeProgressForCurrentAction:((float)chunk / (float)chunks)];
}

-  (void)socket:(THProtocolSocket*)aSocket didFinishReceivingObject:(id)object withIdentifier: (THProtocolObjectIdentifier)identifier {
    
    switch (identifier) {
            
        case kProtocolObjectSceneName:
            currentAction = kTransferActionSceneName;
            break;
            
        case kProtocolObjectScene:
            currentAction = kTransferActionScene;
            break;
            
        case kProtocolObjectMissingAssets:
            currentAction = kTransferActionMissingAssets;
            break;
            
        case kProtocolObjectAssetList:
        case kProtocolObjectAssets:
            currentAction = kTransferActionAssets;
            break;
            
        default:
            break;
    }
    
    [self.delegate agent:self didFinishAction:currentAction withObject:object];
}

-  (void)socket:(THProtocolSocket *)socket didAbortReceivingObjectWithIdentifier:(THProtocolObjectIdentifier)identifier {
    
}

-(NSString *)labelForAction:(THTransferAgentAction)action {
    return kTransferActionTexts[action];
}

@end
