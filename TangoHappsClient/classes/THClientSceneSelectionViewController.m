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
#import "THClientScene.h"
#import "THSimulableWorldController.h"
#import "THGridView.h"
#import "THClientFakeSceneDataSource.h"

@implementation THClientSceneSelectionViewController


const NSTimeInterval kMinInstallationDuration = 1.0f;
const float kIconInstallationUpdateFrequency = 1.0f/30.0f;

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        self.fakeScenesSource = [[THClientFakeSceneDataSource alloc] init];
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    THClientProject * project = [[THClientProject alloc] initWithName:@"halloProject"];
    THClientRealScene * scene = [[THClientRealScene alloc] initWithName:@"halloScene" world:project];
    [scene save];*/
    
    self.connectionController = [[THClientConnectionController alloc] init];
    self.connectionController.delegate = self;
    
    scenes = [THClientScene persistentScenes];
    
    THClientGridView *grid = (THClientGridView*)self.view;
    grid.gridDelegate = self;
    
    [self reloadData];
}

-(void) viewWillAppear:(BOOL)animated{
    
    [self.connectionController startClient];
}

-(void) viewWillDisappear:(BOOL)animated{
    
    [self.connectionController stopClient];
}

/*
-(void) viewDidAppear:(BOOL)animated{
    if(sceneBeingInstalled && finishedInstallingProject){
        [self animateProjectInstallation];
        
        finishedInstallingProject = NO;
    }
}*/

-(void) increaseInstallationProgress{
    if(gridItemBeingInstalled.progressBar.progress >= 1.0f){
        [installationProgressTimer invalidate];
        installationProgressTimer = nil;
        
        [self handleFinishedInstallingProject];
    }
    
    float progress = gridItemBeingInstalled.progressBar.progress + 0.01;
    gridItemBeingInstalled.progressBar.progress += progress;
}

-(void) animateProjectInstallationWithDuration:(float) duration{
    installationUpdateRate = kIconInstallationUpdateFrequency / duration;
    
    installationProgressTimer = [NSTimer scheduledTimerWithTimeInterval:kIconInstallationUpdateFrequency target:self selector:@selector(increaseInstallationProgress) userInfo:nil repeats:YES];
}

-(void) handleFinishedInstallingProject{
    
    gridItemBeingInstalled.progressBar.progress = 1.0f;
    gridItemBeingInstalled = nil;
    
    THClientGridView * gridView = (THClientGridView*) self.view;
    if(gridView.editing){
        gridView.editing = NO;
    }
    
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

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [(THClientGridView*)self.view setEditing:editing];
}

#pragma mark - Private

- (void)reloadData {

    THClientGridView *grid = (THClientGridView*)self.view;
    [grid reloadData];
}
/*
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"segueToAppView"]){
        THClientAppViewController * controller = segue.destinationViewController;
        [controller reloadApp];
    }
}*/

- (void)proceedToScene:(THClientScene*) scene {
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
    return [self.fakeScenesSource numFakeScenes] + scenes.count + (gridItemBeingInstalled ? 1 : 0);
}

-(THClientGridItem *)gridView:(THClientGridView *)gridView viewAtIndex:(NSUInteger)index {
    
    THClientGridItem *item = nil;
    
    if(index < self.fakeScenesSource.numFakeScenes){

        THClientScene * scene = [self.fakeScenesSource.fakeScenes objectAtIndex:index];

        UIImage * image = [UIImage imageNamed:@"fakeSceneImage.png"];
        item = [[THClientGridItem alloc] initWithName:scene.name image:image];
        
    } else if(index < self.fakeScenesSource.numFakeScenes + scenes.count){
        
        THClientScene * scene = [scenes objectAtIndex:index - self.fakeScenesSource.numFakeScenes];
        item = [[THClientGridItem alloc] initWithName:scene.name image:scene.image];
        item.editable = YES;
        
    } else if(index == self.fakeScenesSource.numFakeScenes + scenes.count){
        
        item = gridItemBeingInstalled;
    }

    return item;
}

-(void)gridView:(THClientGridView*)gridView didSelectViewAtIndex:(NSUInteger)index {
    
    if(index < self.fakeScenesSource.numFakeScenes){
        
        THClientScene * scene = [self.fakeScenesSource.fakeScenes objectAtIndex:index];
        [self proceedToScene:scene];
        
    } else if(index < self.fakeScenesSource.numFakeScenes + scenes.count){
        
        THClientScene * scene = [scenes objectAtIndex:index - self.fakeScenesSource.numFakeScenes];
        [scene loadFromArchive];
        [self proceedToScene:scene];
    }
}

-(void)gridView:(THClientGridView *)gridView didDeleteViewAtIndex:(NSUInteger)index {
    
    NSInteger realIdx = index - self.fakeScenesSource.numFakeScenes;
    
    if(realIdx >= 0 && realIdx < self.fakeScenesSource.numFakeScenes){
        
        THClientScene * scene = [scenes objectAtIndex:realIdx];
        [scenes removeObjectAtIndex:realIdx];
        
        [scene deleteArchive];
    }
}

-(void)gridView:(THClientGridView *)gridView didRenameViewAtIndex:(NSUInteger)index newName:(NSString *)newName
{/*
    THClientProject *project = [scenes objectAtIndex:index];
    [scene renameTo:newName];*/
}

#pragma mark - ConnectionController Delegate

-(THClientScene*) sceneNamed:(NSString*) name{
    
    THClientScene * toReturn = nil;
    for (THClientScene * scene in scenes) {
        if([scene.name isEqualToString:name]){
            toReturn = scene;
            break;
        }
    }
    return toReturn;
}
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
}

-(void) didFinishReceivingProject:(THClientProject *)project {
    
    THClientScene * scene;
    
    if(alreadyExistingSceneBeingInstalled){
        
        scene = alreadyExistingSceneBeingInstalled;
        scene.project = project;
        
    } else {
        
        scene = [[THClientScene alloc] initWithName:project.name world:project];
        [scenes addObject:scene];
        
    }
    
    [scene save];
    scene.project = nil;
    
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
