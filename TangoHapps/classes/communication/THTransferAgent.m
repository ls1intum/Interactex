/*
THTransferAgent.m
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


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

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
