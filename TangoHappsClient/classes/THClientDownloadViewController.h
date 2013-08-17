//
//  THClientDownloadViewController.h
//  TangoHapps
//
//  Created by Juan Haladjian on 8/16/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THClientConnectionController.h"

const NSTimeInterval kMinInstallationDuration;
const float kIconInstallationUpdateFrequency;

@interface THClientDownloadViewController : UIViewController<THClientConnectionControllerDelegate>{
    
    NSTimer * installationProgressTimer;
    NSTimeInterval timeWhenInstallationStarted;
    float installationUpdateRate;
}

@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentActivityLabel;

@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@property (weak, nonatomic) NSArray * scenes;
@property (nonatomic, strong) THClientConnectionController * connectionController;

@end
