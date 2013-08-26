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
}

/*
-(THClientScene*) sceneNamed:(NSString*) name{
    
    THClientScene * toReturn = nil;
    for (THClientScene * scene in scenes) {
        if([scene.name isEqualToString:name]){
            toReturn = scene;
            break;
        }
    }
    return toReturn;
}*/

/*
 -(void) replaceSceneNamed:(NSString*) name{
 
 THClientScene * toRemove = [self sceneNamed:name];
 
 if(toRemove){
 
 previousSceneIdx = [scenes indexOfObject:toRemove];
 [scenes removeObjectAtIndex:previousSceneIdx];
 [toRemove deleteArchive];
 
 sceneBeingInstalled = [[THClientGridItem alloc] initWithName:name image:nil];
 sceneBeingInstalled.progressBar.hidden = NO;
 
 THClientGridView * gridView = (THClientGridView*) self.view;
 THClientGridItem * item = [gridView.items objectAtIndex:previousSceneIdx + self.fakeScenesSource.numFakeScenes];
 [gridView replaceItem:item withItem:sceneBeingInstalled];
 
 }
 }*/

-(void) didStartReceivingProjectNamed:(NSString *)name {
    
    timeWhenInstallationStarted = CACurrentMediaTime();
    
    [self.activityIndicator startAnimating];
    self.instructionsLabel.hidden = YES;
    self.descriptionLabel.hidden = NO;
    self.currentActivityLabel.hidden = NO;
    self.instructionsLabel.hidden = NO;
    self.progressBar.hidden = NO;
    
    /*
    THClientGridView * gridView = (THClientGridView*) self.view;
    if(gridView.editing){
        gridView.editing = NO;
    }
    
    alreadyExistingSceneBeingInstalled = [self sceneNamed:name];
    if(alreadyExistingSceneBeingInstalled){
        
        NSInteger idx = [scenes indexOfObject:alreadyExistingSceneBeingInstalled];
        THClientGridView * gridView = (THClientGridView*) self.view;
        gridItemBeingInstalled = [gridView.items objectAtIndex:idx + self.fakeScenesSource.numFakeScenes];
        
    } else {
        
        gridItemBeingInstalled = [[THClientGridItem alloc] initWithName:name image:nil];
        gridItemBeingInstalled.progressBar.hidden = NO;
        
        [gridView addItem:gridItemBeingInstalled animated:YES];
    }
    */
}

-(void) didFinishReceivingProject:(THClientProject *)project {
    
    //THClientScene * scene = [[THClientScene alloc] initWithName:project.name];
    
    /*
    if(alreadyExistingSceneBeingInstalled){
        
        scene = alreadyExistingSceneBeingInstalled;
        scene.project = project;
        
    } else {
        
        scene = [[THClientScene alloc] initWithName:project.name world:project];
        [scenes addObject:scene];
    }*/
    
    //[scene save];
    //scene.project = nil;
    
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
