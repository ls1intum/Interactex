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

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        _fakeScenesSource = [[THClientFakeSceneDataSource alloc] init];
        
        self.navigationController.delegate = self;
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed: 0.59f green:0.72f blue:0.9f alpha:1.0f];
    
    THClientGridView *grid = (THClientGridView*)self.view;
    grid.gridDelegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

#pragma mark - Grid View delegate

-(CGSize) gridItemSizeForGridView:(THGridView*) view{
    return CGSizeMake(100, 210);
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

-(void)setEditing:(BOOL)editing
         animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [(THClientGridView*)self.view setEditing:editing];
}

#pragma mark - Private

- (void)refresh {
    
    _scenes = [_fakeScenesSource fakeScenes];
    [_scenes addObjectsFromArray:[THClientScene persistentScenes]];
    
    
    THClientGridView *grid = (THClientGridView*)self.view;
    
    [grid reloadData];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"segueToAppView"]){
        THClientAppViewController * controller = segue.destinationViewController;
        [controller reloadApp];
    }
}

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

-(NSUInteger)numberOfItemsInGridView:(THClientGridView *)gridView
{
    return _scenes.count + 1;
}

-(THClientGridItem *)gridView:(THClientGridView *)gridView
          viewAtIndex:(NSUInteger)index {
    
    THClientGridItem *item = nil;
    
    if(index < [_fakeScenesSource numFakeScenes]){
        
        THClientScene * scene = [_scenes objectAtIndex:index];
        UIImage * image = [UIImage imageNamed:@"fakeSceneImage.png"];
        item = [[THClientGridItem alloc] initWithName:scene.name image:image];
    } else if(index < _scenes.count){
        THClientScene * scene = [_scenes objectAtIndex:index];
        item = [[THClientGridItem alloc] initWithName:scene.name image:scene.screenshot];
    } else if(index == _scenes.count ){
        item = [[THClientGridItem alloc] initWithName:@"Remote" image:[UIImage imageNamed:@"screenRemote"]];
    }
    return item;
}

-(void)gridView:(THClientGridView*)gridView
didSelectViewAtIndex:(NSUInteger)index
{    
    if(index < [_fakeScenesSource numFakeScenes]){
        
        THClientScene * scene = [_scenes objectAtIndex:index];
        [self proceedToScene:scene];
        
    } else if(index < _scenes.count){
        THClientScene * scene = [_scenes objectAtIndex:index];
        [scene loadFromArchive];
        [self proceedToScene:scene];
    } else {
        [self proceedToRemote];
    }
}

-(void)gridView:(THClientGridView *)gridView
didDeleteViewAtIndex:(NSUInteger)index
{/*
    THClientProject *project = [_scenes objectAtIndex:index];
    [scene deleteArchive];
    [_scenes removeObjectAtIndex:index];*/
}

-(void)gridView:(THClientGridView *)gridView
didRenameViewAtIndex:(NSUInteger)index
         newName:(NSString *)newName
{/*
    THClientProject *project = [scenes objectAtIndex:index];
    [scene renameTo:newName];*/
}

#pragma mark - SceneViewController Delegate
/*
-(void)sceneViewControllerDidFinish:(id)controller
{
    if(controller == sceneViewController){
        [controller viewDidUnload];
        sceneViewController = nil;
    }
}*/


@end
