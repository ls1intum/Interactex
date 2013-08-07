//
//  THFirstViewController.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/24/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum{
    kClientModeVirtual,
    kClientModeReal
} THClientMode;

typedef enum{
    kClientStateNormal,
    kClientStateWaiting
} THClientState;

@class THTransferAgent;

@interface THClientAppViewController : UIViewController {//<LeDiscoveryDelegate, BleServiceDelegate> {
    
    NSTimer * _virtualTransferTimer;
    NSTimer * _realTransferTimer;
    UIActivityIndicatorView * _activityIndicator;
    
    UIButton * _infoButton;
    
    UITextView * _textView;
}

- (void) reloadApp;
- (IBAction)modeButtonTapped:(id)sender;

@property (nonatomic, readonly) THClientMode mode;
@property (nonatomic, readonly) THClientState state;

@property (nonatomic) THTransferAgent  * transferAgent;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *modeButton;
//@property (strong, nonatomic) BleService *bleService;

@end
