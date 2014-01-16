/*
THClientDownloadViewController.m
Interactex Client

Created by Juan Haladjian on 16/08/2013.

iGMP is an App to control an Arduino board over Bluetooth 4.0. iGMP uses the GMP protocol (based on Firmata): www.firmata.org

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany, 
	
Contacts:
juan.haladjian@cs.tum.edu
k.zhang@utwente.nl
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
It has been created with funding from EIT ICT, as part of the activity "Connected Textiles".


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "THClientDownloadViewController.h"
#import "THClientScene.h"
#import "THClientAppDelegate.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    THClientAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.connectionController = appDelegate.connectionController;
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
    
    NSLog(@"started receiving a project %@",name);
    
    timeWhenInstallationStarted = CACurrentMediaTime();
    
    [self.activityIndicator startAnimating];
    self.instructionsLabel.hidden = YES;
    self.descriptionLabel.text = [NSString stringWithFormat:@"Project Name: %@",name];
    self.descriptionLabel.hidden = NO;
    self.currentActivityLabel.hidden = NO;
    self.progressBar.hidden = NO;
    self.progressBar.progress = 0;
    self.checkImageView.hidden = YES;
}

-(void) didFinishReceivingProject:(THClientProject *)project {
    
    NSLog(@"received a project");
    
    self.progressBar.hidden = YES;
    
    [self.delegate didFinishReceivingProject:project];
        
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
