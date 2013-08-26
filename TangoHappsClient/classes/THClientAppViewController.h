//
//  THFirstViewController.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/24/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFFirmataController.h"
#import "BLEDiscovery.h"

@class THTransferAgent;

@interface THClientAppViewController : UIViewController <BLEDiscoveryDelegate, BLEServiceDelegate, IFFirmataControllerDelegate> {
    
    UIActivityIndicatorView * _activityIndicator;
}

-(IBAction) modeButtonTapped:(id)sender;

@property (nonatomic) THTransferAgent  * transferAgent;
@property (weak, nonatomic) IBOutlet UIBarButtonItem * modeButton;
@property (strong, nonatomic) IFFirmataController  * firmataController;

@end
