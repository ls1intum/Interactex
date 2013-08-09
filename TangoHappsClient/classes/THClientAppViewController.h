//
//  THFirstViewController.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/24/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum{
    kClientStateNormal,
    kClientStateWaiting
} THClientState;

@class THTransferAgent;

@interface THClientAppViewController : UIViewController {//<LeDiscoveryDelegate, BleServiceDelegate> {
    
    NSTimer * _realTransferTimer;
    UIActivityIndicatorView * _activityIndicator;
}

-(IBAction)modeButtonTapped:(id)sender;

@property (nonatomic, readonly) THClientState state;

@property (nonatomic) THTransferAgent  * transferAgent;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *modeButton;
//@property (strong, nonatomic) BleService *bleService;

@end
