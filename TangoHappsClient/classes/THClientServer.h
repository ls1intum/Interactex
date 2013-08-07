//
//  THClientServer.h
//  TangoHapps
//
//  Created by Juan Haladjian on 8/7/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    THClientServerStateDisconnected,
    THClientServerStateConnecting,
    THClientServerStateConnected
} THClientServerState;

@interface THClientServer : NSObject

@property (copy, nonatomic) NSString * name;
@property (copy, nonatomic) NSString * peerID;
@property (nonatomic) THClientServerState state;

@end
