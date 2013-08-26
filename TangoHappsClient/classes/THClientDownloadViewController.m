//
//  THClientDownloadViewController.m
//  TangoHapps
//
//  Created by Juan Haladjian on 8/16/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THClientDownloadViewController.h"
#import "THClientScene.h"


const NSTimeInterval kMinInstallationDuration = 1.0f;
const float kIconInstallationUpdateFrequency = 1.0f/30.0f;

@implementation THClientDownloadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.connectionController = [[THClientConnectionController alloc] init];
    self.connectionController.delegate = self;
}

-(void) viewWillAppear:(BOOL)animated{
    
    [self.connectionController startClient];
}

-(void) viewWillDisappear:(BOOL)animated{
    
    [self.connectionController stopClient];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ConnectionController Delegate

-(void) increaseInstallationProgress{
    if(self.progressBar.progress >= 1.0f){
        [installationProgressTimer invalidate];
        installationProgressTimer = nil;
        
        [self handleFinishedInstallingProject];
    }
    
    float progress = self.progressBar.progress + 0.01;
    self.progressBar.progress += progress;
}

-(void) animateProjectInstallationWithDuration:(float) duration{
    installationUpdateRate = kIconInstallationUpdateFrequency / duration;
    
    installationProgressTimer = [NSTimer scheduledTimerWithTimeInterval:kIconInstallationUpdateFrequency target:self selector:@selector(increaseInstallationProgress) userInfo:nil repeats:YES];
}

-(void) handleFinishedInstallingProject{
    
    self.progressBar.progress = 1.0f;
    [self.activityIndicator stopAnimating];
    self.currentActivityLabel.text = @"Download Complete";
    self.checkImageView.hidden = NO;
}

-(void) didStartReceivingProjectNamed:(NSString *)name {
    
    timeWhenInstallationStarted = CACurrentMediaTime();
    
    [self.activityIndicator startAnimating];
    self.instructionsLabel.hidden = YES;
    self.descriptionLabel.text = [NSString stringWithFormat:@"Project Name: %@",name];
    self.descriptionLabel.hidden = NO;
    self.currentActivityLabel.hidden = NO;
    self.instructionsLabel.hidden = NO;
    self.progressBar.hidden = NO;
    self.progressBar.progress = 0;
    self.checkImageView.hidden = YES;
}

-(void) didFinishReceivingProject:(THClientProject *)project {
    
    //THClientScene * scene = [[THClientScene alloc] initWithName:project.name];
    
    
    //scene.project = nil;
    
    [self.delegate didFinishReceivingProject:project];
    
    [project save];
    
    NSTimeInterval currentTime = CACurrentMediaTime();
    if(currentTime - timeWhenInstallationStarted > kMinInstallationDuration){
        
        [self handleFinishedInstallingProject];
        
    } else {
        
        [self animateProjectInstallationWithDuration:2.0f];
    }
}

-(void) didMakeProgressForCurrentProject:(float)progress{
    
    //sceneBeingInstalled.progressBar.progress = progress;
}


@end
