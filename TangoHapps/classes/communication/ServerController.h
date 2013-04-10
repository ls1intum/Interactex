
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "TransferAgent.h"

@class ServerController;
@class THClientProject;

@protocol ServerControllerDelegate <NSObject>
- (void)server:(ServerController*)controller peerConnected:(NSString*)peerName;
- (void)server:(ServerController*)controller peerDisconnected:(NSString*)peerName;
- (void)server:(ServerController*)controller isReadyForSceneTransfer:(BOOL)ready;
- (void)server:(ServerController*)controller isRunning:(BOOL)running;
- (void)server:(ServerController*)controller isTransferring:(BOOL)transferring;
@end

@interface ServerController : NSObject
<TransferAgentDelegate, GKSessionDelegate>
{
    GKSession *session;
    NSTimer * _transferTimer;
}

@property (weak) id<ServerControllerDelegate> delegate;
@property (readonly) BOOL serverIsRunning;

@property (nonatomic,strong) NSMutableDictionary * peers;
@property (nonatomic,strong) NSMutableDictionary * agents;

-(void)startServer;
-(void)stopServer;

-(void) pushProjectToAllClients:(THCustomProject*)project;
-(void) startPushingLilypadStateToAllClients;
-(void) stopPushingLilypadState;

@end
