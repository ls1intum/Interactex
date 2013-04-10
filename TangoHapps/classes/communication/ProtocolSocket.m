
#import "ProtocolSocket.h"

#define CHUNK_SIZE 81920
#define INITIAL_HEADER_SIZE 6
#define SUBSEQUENT_HEADER_SIZE 1

@implementation ProtocolSocket

- (id)initWithSession:(GKSession*)aSession
               peerID:(NSString*)aPeerID
{
    self = [super init];
    if(self){
        session = aSession;
        peerID = aPeerID;
        receiving = NO;
        sending = NO;
        objectQueue = [NSMutableArray array];
        identifierQueue = [NSMutableArray array];
    }
    return self;
}

-(BOOL)isBusy
{
    return (sending || receiving);
}

#pragma mark - Control Flow

- (void)receiveData:(NSData*)data
{
    unsigned char *packet = (unsigned char *)[data bytes];
    ProtocolPacketHeader packetType = (ProtocolPacketHeader)packet[0];
    
    switch (packetType) {
        case kProtocolPacketInitial:{
            if(!receiving){
                //NSLog(@"<Socket> Received INITIAL packet");
                [self readInitialPacket:data];
                [self sendAcknowledgePacket];
                [self finishReceivingIfDone];
                
            }else{
                //NSLog(@"<Socket> ERROR: Received INITIAL packet while previous transfer is still in progress");
            }
            break;
        }
        case kProtocolPacketSubsequent:{
            if(receiving){
                //NSLog(@"<Socket> Received SUBSEQUENT packet");
                [self readSubsequentPacket:data];
                [self sendAcknowledgePacket];
                [self finishReceivingIfDone];
            }else{
                //NSLog(@"<Socket> ERROR: Received SUBSEQUENT packet while not or no longer receiving");
            }
            break;
        }
        case kProtocolPacketAcknowledge:{
            if(sending){
                BOOL done = [self finishSendingIfDone];
                //NSLog(@"<Socket> Received ACKNOWLEDGE packet. Done: %i", done);
                if(!done){
                    [_delegate socket:self willSendChunk:sentChunks of:sendChunksTotal];
                    sentBytes = [self sendSubsequentPackageWithBuffer:sendBuffer firstByteIndex:sentBytes];
                    sentChunks++;
                    //NSLog(@"<Socket> Sent chunks = %i", sentChunks);
                }else{
                    [self sendNextObject];
                }
            }else{
                //NSLog(@"<Socket> ERROR: Received ACKNOWLEDGE packet while not sending");
            }
            break;
        }
        case kProtocolPacketAbortReceiving:{
            if(receiving){
                //NSLog(@"<Socket> Received ABORT_RECEIVING package");
                [self abortReceiving];
            }else{
                //NSLog(@"<Socket> ERROR: Received ABORT_RECEIVING package while not receiving");
            }
            break;
        }
        case kProtocolPacketAbortSending:{
            if(sending){
                //NSLog(@"<Socket> Received ABORT_SENDING package");
                [self abortSending];
            }else{
                //NSLog(@"<Socket> ERROR: Received ABORT_SENDING package while not sending");
            }
            break;
        }
    }
}
 
- (BOOL)finishReceivingIfDone {
    BOOL done = (receivedChunks >= receiveChunksTotal);
    if(done){
        id object = [NSKeyedUnarchiver unarchiveObjectWithData:receiveBuffer];
        [_delegate socket:self didFinishReceivingObject:object withIdentifier:receivingIdentifier];
        receiving = NO;
        receiveBuffer = nil;
        //NSLog(@"<Socket> Finished receiving %d",receivingIdentifier);
    }
    return done;
}

- (void)abortReceiving {
    receiving = NO;
    receiveBuffer = nil;
    //NSLog(@"<Socket> ABORTED receiving prematurely");
    if([_delegate respondsToSelector:@selector(socket:didAbortReceivingObjectWithIdentifier:)])
        [_delegate socket:self didAbortReceivingObjectWithIdentifier:receivingIdentifier];
}

- (BOOL)finishSendingIfDone {
    BOOL done = (sentBytes >= [sendBuffer length]);
    if(done){
        sending = NO;
        sendBuffer = nil;
        [_delegate socket:self didFinishSendingObjectWithIdentifier:sendingIdentifier];
        //NSLog(@"<Socket> Finished sending");
    }
    return done;
}

-(void)abortSending {
    sending = NO;
    sendBuffer = nil;
    //NSLog(@"<Socket> ABORTED sending prematurely");
    if([_delegate respondsToSelector:@selector(socket:didAbortSendingObjectWithIdentifier:)])
        [_delegate socket:self didAbortSendingObjectWithIdentifier:sendingIdentifier];
}

#pragma mark - Interface

- (void)sendObject:(id<NSCoding>)object
    withIdentifier:(ProtocolObjectIdentifier)identifier
{
    [objectQueue addObject:object];
    [identifierQueue addObject:[NSNumber numberWithInt:(int)identifier]];
    if([objectQueue count] == 1)
        [self sendNextObject];
}

- (void)cancelSendingAndEmptyQueue
{
    [self sendAbortReceivePacket];
    [self abortSending];
    [objectQueue removeAllObjects];
    [identifierQueue removeAllObjects];
}

- (void)cancelReceivingAndEmptyQueue
{
    [self sendAbortSendPacket];
    [self abortReceiving];
}

- (void)sendNextObject
{
    if([objectQueue count] == 0)
        return;
    id<NSCoding> object = [objectQueue objectAtIndex:0];
    ProtocolObjectIdentifier identifier = (ProtocolObjectIdentifier)[(NSNumber*)[identifierQueue objectAtIndex:0] integerValue];
    [objectQueue removeObjectAtIndex:0];
    [identifierQueue removeObjectAtIndex:0];
    
    sendBuffer = [[NSMutableData alloc] init];
    [sendBuffer appendData:[NSKeyedArchiver archivedDataWithRootObject:object]];
    
    sending = YES;
    sendingIdentifier = identifier;
    sendChunksTotal = [self numberOfChunksForSize:(unsigned long)[sendBuffer length]];
    sentChunks = 0;
    
    [_delegate socket:self didBeginSendingObjectWithIdentifier:sendingIdentifier];
    [_delegate socket:self willSendChunk:sentChunks of:sendChunksTotal];
    
    //NSLog(@"<Socket> Starting transfer of object with identifier: %i, total size = %i, chunks to send = %i", (int)identifier, [sendBuffer length], sendChunksTotal);
    
    sentBytes = [self sendInitialPackageWithIdentifier:identifier sendBuffer:sendBuffer];
    sentChunks++;
}

#pragma mark - Packet Receiving

-(void)readInitialPacket:(NSData*)data {
    unsigned char *packet = (unsigned char *)[data bytes];
    receiving = YES;
    receivingIdentifier = (ProtocolObjectIdentifier)packet[1];
    unsigned long totalSize = ((packet[2] << 24) + (packet[3] << 16) + (packet[4] << 8) + packet[5]);
    receiveBuffer = [[NSMutableData alloc] initWithCapacity:totalSize];
    receiveChunksTotal = [self numberOfChunksForSize:totalSize];
    receivedChunks = 1;
    [receiveBuffer appendBytes:&(packet[INITIAL_HEADER_SIZE]) length:([data length] - INITIAL_HEADER_SIZE)];
    [_delegate socket:self didBeginReceivingObjectWithIdentifier:receivingIdentifier];
    [_delegate socket:self didReceiveChunk:receivedChunks of:receiveChunksTotal];
    //NSLog(@"<Socket> Read INITIAL packet. Identifier = %i, Total size = %li, expected chunks = %i", (int)receivingIdentifier, totalSize, receiveChunksTotal);
}

-(void)readSubsequentPacket:(NSData*)data
{
    unsigned char *packet = (unsigned char *)[data bytes];
    receivedChunks++;
    [receiveBuffer appendBytes:&(packet[SUBSEQUENT_HEADER_SIZE]) length:([data length] - SUBSEQUENT_HEADER_SIZE)];
    [_delegate socket:self didReceiveChunk:receivedChunks of:receiveChunksTotal];
    //NSLog(@"<Socket> Read SUBEQUENT packet. Received chunks = %i", receivedChunks);
}

#pragma mark - Packet Sending

-(unsigned long)sendInitialPackageWithIdentifier:(ProtocolObjectIdentifier)identifier
                                      sendBuffer:(NSData*)buffer
{
    unsigned long initialPayloadLength = MIN(CHUNK_SIZE - INITIAL_HEADER_SIZE, [buffer length]);
    [self sendPackageWithHeader:kProtocolPacketInitial
                     identifier:identifier
                       sizeInfo:(unsigned long)[buffer length]
                        payload:(unsigned char *)[sendBuffer bytes]
                  payloadOffset:0
                  payloadLength:initialPayloadLength];
    //NSLog(@"<Socket> Sent INITIAL packet. Buffer range 0 - %li", initialPayloadLength);
    return initialPayloadLength;
}

-(unsigned long)sendSubsequentPackageWithBuffer:(NSData*)buffer
                                 firstByteIndex:(unsigned long)offset
{
    unsigned long payloadLength = MIN(CHUNK_SIZE - 1, [buffer length] - offset);
    [self sendPackageWithHeader:kProtocolPacketSubsequent
                     identifier:kProtocolObjectUndefined
                       sizeInfo:0
                        payload:(unsigned char *)[sendBuffer bytes]
                  payloadOffset:offset
                  payloadLength:payloadLength];
    //NSLog(@"<Socket> Sent SUBEQUENT packet. Buffer range %li - %li", offset, offset + payloadLength);
    return offset + payloadLength;
}

- (void)sendAcknowledgePacket
{
    [self sendPackageWithHeader:kProtocolPacketAcknowledge
                     identifier:kProtocolObjectUndefined
                       sizeInfo:0 payload:NULL
                  payloadOffset:0
                  payloadLength:0];
    //NSLog(@"<Socket> Sent ACKNOWLEDGE packet");
}

- (void)sendAbortReceivePacket
{
    [self sendPackageWithHeader:kProtocolPacketAbortReceiving
                     identifier:kProtocolObjectUndefined
                       sizeInfo:0 payload:NULL
                  payloadOffset:0
                  payloadLength:0];
    //NSLog(@"<Socket> Sent ABORT_RECEIVING packet");
}

- (void)sendAbortSendPacket
{
    [self sendPackageWithHeader:kProtocolPacketAbortSending
                     identifier:kProtocolObjectUndefined
                       sizeInfo:0 payload:NULL
                  payloadOffset:0
                  payloadLength:0];
    //NSLog(@"<Socket> Sent ABORT_SENDING packet");
}

-(void)sendPackageWithHeader:(ProtocolPacketHeader)type
                  identifier:(ProtocolObjectIdentifier)identifier
                    sizeInfo:(unsigned long)size
                     payload:(unsigned char*)payload
               payloadOffset:(unsigned long)payloadOffset
               payloadLength:(unsigned long)payloadLength
{
    int headerSize = 1; // <- First byte = package type
    if(type == kProtocolPacketInitial)
        // An initial package also contains the type (1 byte) and the total size info (4 bytes)
        headerSize += 5;
    // Allocate memory for the package data
    unsigned char *packet = (unsigned char *)malloc(MIN(CHUNK_SIZE, [sendBuffer length] + headerSize));
    packet[0] = (int)type; // Set the package type byte
    if(type == kProtocolPacketInitial){
        // Set the identifier byte
        packet[1] = (int)identifier;
        // Set the total size bytes
        packet[2] = (int)((size >> 24) & 0xFF);
        packet[3] = (int)((size >> 16) & 0xFF);
        packet[4] = (int)((size >> 8) & 0XFF);
        packet[5] = (int)((size & 0XFF));
    }
    if(payloadLength > 0){
        // Copy data from payloadBuffer (with offset and length) to the packet
        for(unsigned long i = payloadOffset; i < (MIN(CHUNK_SIZE - headerSize, payloadLength) + payloadOffset); i++){
            packet[(i - payloadOffset) + headerSize] = payload[i];
        }
    }
    // Create data object from packet bytes
    NSData *data = [NSData dataWithBytesNoCopy:packet
                                        length:MIN(CHUNK_SIZE, payloadLength + headerSize)
                                  freeWhenDone:YES];
    // Finally send the packet via the gamekit session
    NSError *error;
    BOOL success = [session sendData:data
                             toPeers:[NSArray arrayWithObject:peerID]
                        withDataMode:GKSendDataReliable
                               error:&error];
//    BOOL success = [session sendDataToAllPeers:data
//                                  withDataMode:GKSendDataReliable
//                                         error:&error];
    if(!success){
        NSLog(@"ObjectProtocol could not send package: %@", [error localizedDescription]);
        if([_delegate respondsToSelector:@selector(socket:didFailSendingDataWithError:)])
            [_delegate socket:self didFailSendingDataWithError:error];
    }
}

- (NSUInteger)numberOfChunksForSize:(unsigned long)size
{
    // Calculate the number of chunks required for a data size
    int remainder = (NSUInteger)size - (CHUNK_SIZE - INITIAL_HEADER_SIZE);
    NSUInteger subsequentChunks = (remainder > 0) ? ceil((float)remainder / (float)(CHUNK_SIZE - SUBSEQUENT_HEADER_SIZE)) : 0;
    return (subsequentChunks + 1);
}

@end
