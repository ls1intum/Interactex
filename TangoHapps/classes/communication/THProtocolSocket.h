
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

typedef enum {
    kProtocolObjectSceneName,
    kProtocolObjectScene,
    kProtocolObjectAssetList,
    kProtocolObjectMissingAssets,
    kProtocolObjectAssets,
    kProtocolObjectUndefined
} THProtocolObjectIdentifier;

typedef enum {
    kProtocolPacketInitial = 0x00,
    kProtocolPacketSubsequent = 0x01,
    kProtocolPacketAcknowledge = 0x02,
    kProtocolPacketAbortReceiving = 0xFA,
    kProtocolPacketAbortSending = 0xFB
} THProtocolPacketHeader;

@class THProtocolSocket;

@protocol THProtocolSocketDelegate <NSObject>
// Sending callbacks
- (void)socket:(THProtocolSocket*)socket didBeginSendingObjectWithIdentifier:(THProtocolObjectIdentifier)identifier;
- (void)socket:(THProtocolSocket*)socket willSendChunk:(int)chunk of:(int)chunks;
- (void)socket:(THProtocolSocket*)socket didFinishSendingObjectWithIdentifier:(THProtocolObjectIdentifier)identifier;
// Receiving callbacks
- (void)socket:(THProtocolSocket*)socket didBeginReceivingObjectWithIdentifier:(THProtocolObjectIdentifier)identifier;
- (void)socket:(THProtocolSocket*)socket didReceiveChunk:(int)chunk of:(int)chunks;
- (void)socket:(THProtocolSocket*)socket didFinishReceivingObject:(id)object withIdentifier:(THProtocolObjectIdentifier)identifier;
@optional
// Abort and error callbacks
- (void)socket:(THProtocolSocket*)socket didAbortReceivingObjectWithIdentifier:(THProtocolObjectIdentifier)identifier;
- (void)socket:(THProtocolSocket*)socket didAbortSendingObjectWithIdentifier:(THProtocolObjectIdentifier)identifier;
- (void)socket:(THProtocolSocket*)socket didFailSendingDataWithError:(NSError*)error;
@end

@interface THProtocolSocket : NSObject {
    BOOL sending;
    THProtocolObjectIdentifier sendingIdentifier;
    NSMutableArray *objectQueue;
    NSMutableArray *identifierQueue;
    NSMutableData *sendBuffer;
    unsigned long sentBytes;
    NSUInteger sentChunks;
    NSUInteger sendChunksTotal;

    BOOL receiving;
    THProtocolObjectIdentifier receivingIdentifier;
    NSMutableData *receiveBuffer;
    NSUInteger receivedChunks;
    NSUInteger receiveChunksTotal;
    
    GKSession *session;
    NSString *peerID;
}

@property (weak) id<THProtocolSocketDelegate> delegate;
@property (readonly) BOOL isBusy;

- (id)initWithSession:(GKSession*)session peerID:(NSString*)peerID;
- (void)sendObject:(id<NSCoding>)object withIdentifier:(THProtocolObjectIdentifier)identifier;
- (void)cancelSendingAndEmptyQueue;
- (void)receiveData:(NSData*)data;
@end
