/*
THClientDownloadViewController.m
Interactex Client

Created by Juan Haladjian on 16/08/2013.

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

Martijn ten Bhömer from TU Eindhoven contributed PureData support. Contact: m.t.bhomer@tue.nl.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

#import "THClientDownloadViewController.h"
#import "THClientScene.h"
#import "THClientAppDelegate.h"

const NSTimeInterval kMinInstallationDuration = 1.0f;
const float kIconInstallationUpdateFrequency = 1.0f/20.0f;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self.connectionController selector:@selector(startClient) name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void) viewWillDisappear:(BOOL)animated{
    
    [self.connectionController stopClient];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ConnectionController Delegate

-(void) increaseInstallationProgress{
    NSLog(@"progress to %f",self.progressBar.progress);
    
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
    
    NSLog(@"firign after %f secs",installationUpdateRate);
    
    installationProgressTimer = [NSTimer scheduledTimerWithTimeInterval:installationUpdateRate target:self selector:@selector(increaseInstallationProgress) userInfo:nil repeats:YES];
    
//    [installationProgressTimer fire];
}

-(void) handleFinishedInstallingProject{
    
    self.progressBar.progress = 1.0f;
    [self.activityIndicator stopAnimating];
    self.currentActivityLabel.text = @"Download Complete";
    self.checkImageView.hidden = NO;
}

-(void) didStartReceivingProjectNamed:(NSString *)name {
    
    NSLog(@"started receiving a project %@",name);
    
    [self appendStatusMessage:[NSString stringWithFormat:@"Started receiving a project named '%@'",name]];
    
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
    
    [self appendStatusMessage:[NSString stringWithFormat:@"Received project '%@'",project.name]];
    
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

-(void) didReceiveAssets:(THAssetCollection *)assets{
    
}

-(void) appendStatusMessage:(NSString *)msg {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        //Your code goes in here
        [self.statusTextView setText:[NSString stringWithFormat:@"%@ \n%@",self.statusTextView.text, msg]];
        self.statusTextView.showsVerticalScrollIndicator = YES;
        
        // Refresh user Interface
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CoreDataUpdatedNotification"
                                                            object:self];
    }];
    
    NSLog(@"From ClientDowloadViewController %@",msg);;
    //[self.statusTextView setNeedsDisplay];
}

@end
