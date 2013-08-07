//
//  THClientSceneSelectionViewController.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/25/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THClientSceneSelectionViewController.h"
#import "THClientAppViewController.h"
#import "THClientGridView.h"
#import "THClientGridItem.h"
#import "THClientProject.h"
#import "THClientRealScene.h"
#import "THSimulableWorldController.h"
#import "THGridView.h"
#import "THClientFakeSceneDataSource.h"

@implementation THClientSceneSelectionViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        fakeScenesSource = [[THClientFakeSceneDataSource alloc] init];
        
        self.navigationController.delegate = self;
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor colorWithRed: 0.59f green:0.72f blue:0.9f alpha:1.0f];
    
    scenes = [THClientRealScene persistentScenes];
    
    THClientGridView *grid = (THClientGridView*)self.view;
    grid.gridDelegate = self;
    
    [self reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[self reloadData];
}

-(void) viewDidAppear:(BOOL)animated{
    if(sceneBeingInstalled && finishedInstallingProject){
        [self animateProjectInstallation];
        
        finishedInstallingProject = NO;
    }
}

-(void) increaseInstallationProgress{
    if(sceneBeingInstalled.progressBar.progress >= 1.0f){
        [installationProgressTimer invalidate];
        installationProgressTimer = nil;
        
        [self handleFinishedInstallingProject];
    }
    
    float progress = sceneBeingInstalled.progressBar.progress + 0.1f;
    sceneBeingInstalled.progressBar.progress += progress;
}

-(void) animateProjectInstallation{
    installationProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/30.0f target:self selector:@selector(increaseInstallationProgress) userInfo:nil repeats:YES];
}

-(void) handleFinishedInstallingProject{
    
    sceneBeingInstalled.progressBar.progress = 1.0f;
    sceneBeingInstalled = nil;
    [self reloadData];
}

#pragma mark - Grid View delegate

-(CGSize) gridItemSizeForGridView:(THGridView*) view{
    return CGSizeMake(100, 224);
}

-(CGPoint) gridItemPaddingForGridView:(THGridView*) view{
    return CGPointMake(5, 1);
}

-(CGPoint) gridPaddingForGridView:(THGridView*) view{
    return CGPointMake(0,5);
}

#pragma mark Interface Actions

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if([navigationController isKindOfClass:[UITabBarController class]]){
        //viewController.view
        //TODO take screenshot
    }
}

#pragma mark Interface Actions

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [(THClientGridView*)self.view setEditing:editing];
}

#pragma mark - Private

- (void)reloadData {

    THClientGridView *grid = (THClientGridView*)self.view;
    [grid reloadData];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"segueToAppView"]){
        THClientAppViewController * controller = segue.destinationViewController;
        [controller reloadApp];
    } else if([segue.identifier isEqualToString:@"segueToConnectionController"]){
        
        THClientConnectionViewController * controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

- (void)proceedToScene:(THClientRealScene*) scene {
    [self setEditing:NO];
    
    [THSimulableWorldController sharedInstance].currentScene = scene;
    [THSimulableWorldController sharedInstance].currentProject = scene.project;
    
    [self performSegueWithIdentifier:@"segueToAppView" sender:self];
}

-(void)proceedToRemote {
    [self setEditing:NO];
    [self performSegueWithIdentifier:@"segueToConnectionController" sender:self];
}

#pragma mark - Grid View Data Source

-(NSUInteger)numberOfItemsInGridView:(THClientGridView *)gridView {
    return [fakeScenesSource numFakeScenes] + scenes.count + (sceneBeingInstalled ? 1 : 0) + 1;
}

-(THClientGridItem *)gridView:(THClientGridView *)gridView viewAtIndex:(NSUInteger)index {
    
    THClientGridItem *item = nil;
    
    if(index < fakeScenesSource.numFakeScenes){
        
        THClientRealScene * scene = [fakeScenesSource.fakeScenes objectAtIndex:index];
        UIImage * image = [UIImage imageNamed:@"fakeSceneImage.png"];
        item = [[THClientGridItem alloc] initWithName:scene.name image:image];
        
    } else if(index < fakeScenesSource.numFakeScenes + scenes.count){
        
        THClientRealScene * scene = [scenes objectAtIndex:index - fakeScenesSource.numFakeScenes];
        item = [[THClientGridItem alloc] initWithName:scene.name image:scene.image];
        
    } else if(index == fakeScenesSource.numFakeScenes + scenes.count){
        
        if(sceneBeingInstalled){
            item = sceneBeingInstalled;
            
        } else {
            
            item = [[THClientGridItem alloc] initWithName:@"Remote" image:[UIImage imageNamed:@"screenRemote"]];
        }
        
    } else {
        
        item = [[THClientGridItem alloc] initWithName:@"Remote" image:[UIImage imageNamed:@"screenRemote"]];
    }

    return item;
}

-(void)gridView:(THClientGridView*)gridView didSelectViewAtIndex:(NSUInteger)index {    
    if(index < fakeScenesSource.numFakeScenes){
        
        THClientRealScene * scene = [fakeScenesSource.fakeScenes objectAtIndex:index];
        [self proceedToScene:scene];
        
    } else if(index < fakeScenesSource.numFakeScenes + scenes.count){
        
        THClientRealScene * scene = [scenes objectAtIndex:index - fakeScenesSource.numFakeScenes];
        [scene loadFromArchive];
        [self proceedToScene:scene];
        
    } else if((index == fakeScenesSource.numFakeScenes + scenes.count && !sceneBeingInstalled) || (index == fakeScenesSource.numFakeScenes + scenes.count +1 && sceneBeingInstalled)){
        [self proceedToRemote];
    }
}

-(void)gridView:(THClientGridView *)gridView didDeleteViewAtIndex:(NSUInteger)index {
    NSLog(@"deleted %d",index);
}

-(void)gridView:(THClientGridView *)gridView didRenameViewAtIndex:(NSUInteger)index newName:(NSString *)newName
{/*
    THClientProject *project = [scenes objectAtIndex:index];
    [scene renameTo:newName];*/
}

#pragma mark - ConnectionController Delegate

-(void) didStartReceivingProjectNamed:(NSString *)name {
    [self.navigationController popViewControllerAnimated:YES];
    
    sceneBeingInstalled = [[THClientGridItem alloc] initWithName:name image:nil];
    sceneBeingInstalled.progressBar.hidden = NO;
    
    [self reloadData];
    
    NSLog(@"started");
    finishedInstallingProject = NO;
}

-(void) didFinishReceivingProject:(THClientProject *)project {
    
    THClientRealScene * scene = [[THClientRealScene alloc] initWithName:project.name world:project];
    [scenes addObject:scene];
    [scene save];
    
    finishedInstallingProject = YES;
    NSLog(@"finished");
    if(self.navigationController.topViewController == self){
        [self handleFinishedInstallingProject];
    }
    
    /*
     if(self.navigationController.topViewController == self){
     [self performSegueWithIdentifier:@"segueToAppView" sender:self];
     } else {
     [clientAppViewController reloadApp];
     }*/
}

-(void) didMakeProgressForCurrentProject:(float)progress{
    
    sceneBeingInstalled.progressBar.progress = progress;
}

@end
