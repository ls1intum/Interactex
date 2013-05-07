
#import "TransferAgent.h"

@implementation TransferAgent

+(TransferAgent *)masterAgentForClientPeerID:(NSString *)peerID
                                     session:(GKSession *)session
{
    return [[TransferAgent alloc] initWithSession:session peerID:peerID inMode:kTransferAgentModeMaster];
}

+(TransferAgent *)slaveAgentForServerPeerID:(NSString *)peerID
                                    session:(GKSession *)session
{
    return [[TransferAgent alloc] initWithSession:session peerID:peerID inMode:kTransferAgentModeSlave];
}

-(id)initWithSession:(GKSession *)newSession
              peerID:(NSString *)newPeerID
              inMode:(TransferAgentMode)newMode
{
    self = [super init];
    if(self){
        mode = newMode;
        session = newSession;
        peerID = newPeerID;
        socket = [[ProtocolSocket alloc] initWithSession:session peerID:peerID];
        [socket setDelegate:self];
        currentAction = kTransferAgentActionIdle;
        actionQueue= [NSMutableArray array];
        objectQueue = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Properties

-(BOOL)isIdle
{
    return (currentAction == kTransferAgentActionIdle);
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

- (void)queueAction:(TransferAgentAction)action
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
    
    currentAction = (TransferAgentAction)[(NSNumber*)[actionQueue objectAtIndex:0] integerValue];
    id object = [objectQueue objectAtIndex:0];
    if(object == [NSNull null]) object = nil;
    [actionQueue removeObjectAtIndex:0];
    [objectQueue removeObjectAtIndex:0];
    [_delegate agent:self willBeginAction:currentAction];
    
    //NSLog(@"<TA> Beginning queueable action: %@", [self labelForAction:currentAction]);
    
    switch (currentAction) {
        case kTransferAgentActionIdle:{
            [self finishCurrentAction];
            return;
            break;
        }
        case kTransferAgentActionScene:{
            [socket sendObject:object withIdentifier:kProtocolObjectScene];
            break;
        }
        case kTransferActionPinState:{
            [socket sendObject:object withIdentifier:kProtocolObjectPins];
            break;
        }
        case kTransferActionInputPinState:{
            [socket sendObject:object withIdentifier:kProtocolObjectInputPins];
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

- (void)finishCurrentAction
{
    [self finishCurrentActionWithObject:nil];
}

- (void)finishCurrentActionWithObject:(id)object {
    [_delegate agent:self didFinishAction:currentAction withObject:object];
    currentAction = kTransferAgentActionIdle;
    [self performNextAction];
}

- (void)finishAction:(TransferAgentAction)action withObject:(id)object {
    [_delegate agent:self didFinishAction:action withObject:object];
    currentAction = kTransferAgentActionIdle;
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

- (void)socket:(ProtocolSocket*)socket
didBeginSendingObjectWithIdentifier:(ProtocolObjectIdentifier)identifier
{

}

- (void)socket:(ProtocolSocket*)socket
 willSendChunk:(int)chunk
            of:(int)chunks
{
    [_delegate agent:self madeProgressForCurrentAction:((float)chunk / (float)chunks)];
}

- (void)socket:(ProtocolSocket*)socket
didFinishSendingObjectWithIdentifier:(ProtocolObjectIdentifier)identifier
{
    BOOL expected = NO;
    if(mode == kTransferAgentModeMaster){
        if(currentAction == kTransferAgentActionScene && identifier == kProtocolObjectScene){
            //NSLog(@"<TA:Server> Finished sending scene object");
            [self finishCurrentAction];
            expected = YES;
        } else if (currentAction == kTransferActionInputPinState && identifier == kProtocolObjectInputPins){
            //NSLog(@"<TA:Server> Finished sending scene object");
            [self finishCurrentAction];
            expected = YES;
        }
    } else {
        if(currentAction == kTransferActionPinState && identifier == kProtocolObjectPins){
            //NSLog(@"<TA:Server> Finished sending scene object");
            [self finishCurrentAction];
            expected = YES;
        }
    }
}

- (void)socket:(ProtocolSocket *)socket
didAbortSendingObjectWithIdentifier:(ProtocolObjectIdentifier)identifier
{
    
}

#pragma mark - Protocol Socket Delegate (Receiving)

- (void)socket:(ProtocolSocket*)socket
didBeginReceivingObjectWithIdentifier:(ProtocolObjectIdentifier)identifier
{
    BOOL expected = NO;
    if(mode == kTransferAgentModeSlave){
        if(currentAction == kTransferAgentActionIdle){
            if(identifier == kProtocolObjectScene){
                NSLog(@"<TA:Client> Began receiving scene object");
                currentAction = kTransferAgentActionScene;
                [_delegate agent:self willBeginAction:currentAction];
                expected = YES;
            } else if(identifier == kProtocolObjectInputPins){
                NSLog(@"<TA:Client> Began receiving scene object");
                currentAction = kTransferActionInputPinState;
                [_delegate agent:self willBeginAction:currentAction];
                expected = YES;
            }
        } 
    }
    if(currentAction == kTransferAgentActionIdle){
        
        if(identifier == kProtocolObjectPins){
            currentAction = kTransferActionPinState;
            [_delegate agent:self willBeginAction:currentAction];
            expected = YES;
        } else if(identifier == kProtocolObjectInputPins){
            currentAction = kTransferActionInputPinState;
            [_delegate agent:self willBeginAction:currentAction];
            expected = YES;
        }
    }
}

-  (void)socket:(ProtocolSocket*)socket
didReceiveChunk:(int)chunk
             of:(int)chunks
{
    [_delegate agent:self madeProgressForCurrentAction:((float)chunk / (float)chunks)];
}

-  (void)socket:(ProtocolSocket*)aSocket
didFinishReceivingObject:(id)object
          withIdentifier:(ProtocolObjectIdentifier)identifier
{
    BOOL expected = NO;
    //NSLog(@"finished with ident %d",identifier);
    if(identifier == kProtocolObjectScene){
        [self finishAction:kTransferAgentActionScene withObject:object];
        expected = YES;
    } else if(identifier == kProtocolObjectPins){
        [self finishAction:kTransferActionPinState withObject:object];
        expected = YES;
    } else if(identifier == kProtocolObjectInputPins){
        [self finishAction:kTransferActionInputPinState withObject:object];
        expected = YES;
    } else if(identifier == kProtocolObjectAssetList || identifier == kProtocolObjectAssets){
        [self finishAction:kTransferActionAssets withObject:object];
        expected = YES;
    } else if(identifier == kProtocolObjectMissingAssets){
        [self finishAction:kTransferActionMissingAssets withObject:object];
        expected = YES;
    }
}

-  (void)socket:(ProtocolSocket *)socket
didAbortReceivingObjectWithIdentifier:(ProtocolObjectIdentifier)identifier
{
    
}

-(NSString *)labelForAction:(TransferAgentAction)action
{
    NSString *label = nil;
    switch (action) {
        case kTransferAgentActionScene:
            label = (mode == kTransferAgentModeMaster ? @"Sending scene" : @"Receiving scene");
            break;
        default:
            label = nil;
            break;
    }
    return label;
}

@end
