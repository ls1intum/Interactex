/*
THProtocolSocket.h
Interactex Designer

Created by Juan Haladjian on 05/10/2013.

Interactex Designer is a configuration tool to easily setup, simulate and connect e-Textile hardware with smartphone functionality. Interactex Client is an app to store and replay projects made with Interactex Designer.

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
The first version of the software was designed and implemented as part of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was founded by Telekom Innovation Laboratories Berlin. It has been extended with funding from EIT ICT, as part of the activity "Connected Textiles".

Interactex is built using the Tango framework developed by TU Munich.

In the Interactex software, we use the GHUnit (a test framework for iOS developed by Gabriel Handford) and cocos2D libraries (a framework for building 2D games and graphical applications developed by Zynga Inc.). 
www.cocos2d-iphone.org
github.com/gabriel/gh-unit

Interactex also implements the Firmata protocol. Its software serial library is based on the original Arduino Firmata library.
www.firmata.org

All hardware part graphics in Interactex Designer are reproduced with kind permission from Fritzing. Fritzing is an open-source hardware initiative to support designers, artists, researchers and hobbyists to work creatively with interactive electronics.
www.frizting.org

Martijn ten Bhömer from TU Eindhoven contributed PureData support. Contact: m.t.bhomer@tue.nl.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

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
