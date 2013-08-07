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
@class THClientRealScene;
@class THClientServer;

@protocol THClientConnectionControllerDelegate <NSObject>

-(void) didStartReceivingProjectNamed:(NSString*) name;
-(void) didMakeProgressForCurrentProject:(float) progress;
-(void) didFinishReceivingProject:(THClientProject*) project;

@end

@interface THClientConnectionViewController : UIViewController
<THTransferAgentDelegate, UITableViewDataSource, UITableViewDelegate, GKSessionDelegate> {
    NSMutableArray *servers;
    
    GKSession *session;
    THTransferAgent * transferAgent;
}

@property (readonly) BOOL isConnectedToServer;
@property (weak, readonly) THClientServer* connectedServer;

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) id<THClientConnectionControllerDelegate> delegate;

-(void)startClient;
-(void)stopClient;
- (IBAction)refreshTapped:(id)sender;

@end
