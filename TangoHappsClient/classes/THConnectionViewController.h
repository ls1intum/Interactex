//
//  THFirstViewController.h
//  TangoHappsClient
//
//  Created by Juan Haladjian on 9/24/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "TransferAgent.h"

@class THClientAppViewController;
@class THClientScene;

@interface THConnectionViewController : UIViewController
<TransferAgentDelegate, UITableViewDataSource, UITableViewDelegate, GKSessionDelegate>
{
    NSMutableDictionary *servers;
    IBOutlet UITableView *tableView;
    IBOutlet UILabel *statusLabel;
    IBOutlet UIProgressView *progressBar;
    
    GKSession *session;
    NSString *connectedPeerID;
    TransferAgent * _transferAgent;
    
    THClientAppViewController * _clientAppViewController;
    UINavigationController * _navigationController;
}


@property (readonly) BOOL isConnectedToServer;
@property (weak) UIProgressView *externalProgressBar;

-(void)startClient;
-(void)stopClient;

@end
