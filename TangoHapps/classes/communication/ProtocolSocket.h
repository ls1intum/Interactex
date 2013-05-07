
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

typedef enum {
    kProtocolObjectScene,
    kProtocolObjectPins,
    kProtocolObjectInputPins,
    kProtocolObjectAssetList,
    kProtocolObjectMissingAssets,
    kProtocolObjectAssets,
    kProtocolObjectUndefined
} ProtocolObjectIdentifier;

typedef enum {
    kProtocolPacketInitial = 0x00,
    kProtocolPacketSubsequent = 0x01,
    kProtocolPacketAcknowledge = 0x02,
    kProtocolPacketAbortReceiving = 0xFA,
    kProtocolPacketAbortSending = 0xFB
} ProtocolPacketHeader;

@class ProtocolSocket;

@protocol ProtocolSocketDelegate <NSObject>
// Sending callbacks
- (void)socket:(ProtocolSocket*)socket didBeginSendingObjectWithIdentifier:(ProtocolObjectIdentifier)identifier;
- (void)socket:(ProtocolSocket*)socket willSendChunk:(int)chunk of:(int)chunks;
- (void)socket:(ProtocolSocket*)socket didFinishSendingObjectWithIdentifier:(ProtocolObjectIdentifier)identifier;
// Receiving callbacks
- (void)socket:(ProtocolSocket*)socket didBeginReceivingObjectWithIdentifier:(ProtocolObjectIdentifier)identifier;
- (void)socket:(ProtocolSocket*)socket didReceiveChunk:(int)chunk of:(int)chunks;
- (void)socket:(ProtocolSocket*)socket didFinishReceivingObject:(id)object withIdentifier:(ProtocolObjectIdentifier)identifier;
@optional
// Abort and error callbacks
- (void)socket:(ProtocolSocket*)socket didAbortReceivingObjectWithIdentifier:(ProtocolObjectIdentifier)identifier;
- (void)socket:(ProtocolSocket*)socket didAbortSendingObjectWithIdentifier:(ProtocolObjectIdentifier)identifier;
- (void)socket:(ProtocolSocket*)socket didFailSendingDataWithError:(NSError*)error;
@end

@interface ProtocolSocket : NSObject
{
    BOOL sending;
    ProtocolObjectIdentifier sendingIdentifier;
    NSMutableArray *objectQueue;
    NSMutableArray *identifierQueue;
    NSMutableData *sendBuffer;
    unsigned long sentBytes;
    NSUInteger sentChunks;
    NSUInteger sendChunksTotal;

    BOOL receiving;
    ProtocolObjectIdentifier receivingIdentifier;
    NSMutableData *receiveBuffer;
    NSUInteger receivedChunks;
    NSUInteger receiveChunksTotal;
    
    GKSession *session;
    NSString *peerID;
}

@property (weak) id<ProtocolSocketDelegate> delegate;
@property (readonly) BOOL isBusy;

- (id)initWithSession:(GKSession*)session peerID:(NSString*)peerID;
- (void)sendObject:(id<NSCoding>)object withIdentifier:(ProtocolObjectIdentifier)identifier;
- (void)cancelSendingAndEmptyQueue;
- (void)receiveData:(NSData*)data;
@end
