
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "ProtocolSocket.h"

typedef enum{
    kTransferAgentModeMaster,
    kTransferAgentModeSlave
} TransferAgentMode;

typedef enum{
    kTransferAgentActionIdle,
    kTransferAgentActionScene,
    kTransferActionPinState,
    kTransferActionInputPinState,
    kTransferActionAssets,
    kTransferActionMissingAssets
} TransferAgentAction;

@class TransferAgent;

@protocol TransferAgentDelegate <NSObject>
- (void)agent:(TransferAgent*)agent willBeginAction:(TransferAgentAction)action;
- (void)agent:(TransferAgent*)agent madeProgressForCurrentAction:(float)progress;
- (void)agent:(TransferAgent*)agent didFinishAction:(TransferAgentAction)action withObject:(id)object;
- (void)agent:(TransferAgent*)agent didChangeQueueLengthTo:(NSUInteger)items;
@optional
- (void)agent:(TransferAgent*)agent didCancelAction:(TransferAgentAction)action;
- (void)agent:(TransferAgent*)agent didFailAtAction:(TransferAgentAction)action;
@end

@interface TransferAgent : NSObject
<ProtocolSocketDelegate>
{
    NSMutableArray *actionQueue;
    NSMutableArray *objectQueue;
    NSString *peerID;
    GKSession *session;
    TransferAgentMode mode;
    ProtocolSocket *socket;
    TransferAgentAction currentAction;
}

@property (weak) id<TransferAgentDelegate> delegate;
@property (readonly) BOOL isIdle;
@property (readonly) NSString *peerID;
@property (readonly) NSUInteger queuedActions;

+ (TransferAgent*)masterAgentForClientPeerID:(NSString*)peerID session:(GKSession*)session;
+ (TransferAgent*)slaveAgentForServerPeerID:(NSString*)peerID session:(GKSession*)session;
- (id)initWithSession:(GKSession*)session peerID:(NSString*)peerID inMode:(TransferAgentMode)mode;
- (void)receiveData:(NSData*)data;

- (void)queueAction:(TransferAgentAction)action withObject:(id)object;
- (void)cancelQueuedActions;
- (void)cancelCurrentAndQueuedActions;

- (NSString *)labelForAction:(TransferAgentAction)action;

@end
