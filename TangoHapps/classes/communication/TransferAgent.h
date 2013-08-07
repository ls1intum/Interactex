
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "ProtocolSocket.h"

typedef enum{
    kTransferAgentModeMaster,
    kTransferAgentModeSlave
} THTransferAgentMode;

#define kNumTransferActions 6

typedef enum{
    kTransferAgentActionIdle,
    kTransferAgentActionScene,
    kTransferActionAssets,
    kTransferActionMissingAssets
} THTransferAgentAction;

extern NSString* const kTransferActionTexts[kNumTransferActions];

@class THTransferAgent;

@protocol THTransferAgentDelegate <NSObject>
- (void)agent:(THTransferAgent*)agent willBeginAction:(THTransferAgentAction)action;
- (void)agent:(THTransferAgent*)agent madeProgressForCurrentAction:(float)progress;
- (void)agent:(THTransferAgent*)agent didFinishAction:(THTransferAgentAction)action withObject:(id)object;
- (void)agent:(THTransferAgent*)agent didChangeQueueLengthTo:(NSUInteger)items;
@optional
- (void)agent:(THTransferAgent*)agent didCancelAction:(THTransferAgentAction)action;
- (void)agent:(THTransferAgent*)agent didFailAtAction:(THTransferAgentAction)action;
@end

@interface THTransferAgent : NSObject
<THProtocolSocketDelegate>
{
    NSMutableArray *actionQueue;
    NSMutableArray *objectQueue;
    NSString *peerID;
    GKSession *session;
    THTransferAgentMode mode;
    THProtocolSocket *socket;
    THTransferAgentAction currentAction;
}

@property (weak) id<THTransferAgentDelegate> delegate;
@property (readonly) BOOL isIdle;
@property (readonly) NSString *peerID;
@property (readonly) NSUInteger queuedActions;

+ (THTransferAgent*)masterAgentForClientPeerID:(NSString*)peerID session:(GKSession*)session;
+ (THTransferAgent*)slaveAgentForServerPeerID:(NSString*)peerID session:(GKSession*)session;
- (id)initWithSession:(GKSession*)session peerID:(NSString*)peerID inMode:(THTransferAgentMode)mode;
- (void)receiveData:(NSData*)data;

- (void)queueAction:(THTransferAgentAction)action withObject:(id)object;
- (void)cancelQueuedActions;
- (void)cancelCurrentAndQueuedActions;

- (NSString *)labelForAction:(THTransferAgentAction)action;

@end
