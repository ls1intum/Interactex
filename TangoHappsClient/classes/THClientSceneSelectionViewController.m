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
#import "THClientPresetsGenerator.h"
#import "THClientDownloadViewController.h"

@implementation THClientSceneSelectionViewController


-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
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
    
    THClientPresetsGenerator * fakeScenesSource = [[THClientPresetsGenerator alloc] init];
    self.presets = fakeScenesSource.fakeScenes;
    self.scenes = [THClientScene persistentScenes];
    
    self.gridView.gridDelegate = self;
    self.gridView.dataSource = self;
    
    self.presetsGridView.gridDelegate = self;
    self.presetsGridView.dataSource = self;
    
    [self reloadData];
}

-(void) viewWillDisappear:(BOOL)animated{
    
    self.gridView.editing = NO;
    self.presetsGridView.editing = NO;
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

/*
#pragma mark Interface Actions

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.gridView setEditing:editing];
}*/

#pragma mark - Private

- (void)reloadData {

    [self.gridView reloadData];
    [self.presetsGridView reloadData];
}

- (void)proceedToScene:(THClientScene*) scene {
    //[self setEditing:NO];
    [self.gridView setEditing:NO];
    [self.presetsGridView setEditing:NO];
    
    [THSimulableWorldController sharedInstance].currentScene = scene;
    [THSimulableWorldController sharedInstance].currentProject = scene.project;
    
    [self performSegueWithIdentifier:@"segueToAppView" sender:self];
}

#pragma mark - Grid View Data Source

-(NSUInteger)numberOfItemsInGridView:(THClientGridView *)gridView {
    
    if(gridView == self.presetsGridView){
        
        NSLog(@"%d",self.presets.count);
        return self.presets.count;
        
    } else if(gridView == self.gridView){

        return self.scenes.count;
    }
    
    return 0;
}

-(THClientGridItem *)gridView:(THClientGridView *)gridView viewAtIndex:(NSUInteger)index {
    
    THClientGridItem *item = nil;
    
    if(gridView == self.presetsGridView){
        
        THClientScene * scene = [self.presets objectAtIndex:index];
        
        UIImage * image = [UIImage imageNamed:@"fakeSceneImage.png"];
        item = [[THClientGridItem alloc] initWithName:scene.name image:image];
        
    } else if(gridView == self.gridView){
        
        THClientScene * scene = [self.scenes objectAtIndex:index];
        item = [[THClientGridItem alloc] initWithName:scene.name image:scene.image];
        item.editable = YES;
        
    }
    
    return item;
}

-(void) gridView:(THClientGridView*)gridView didSelectViewAtIndex:(NSUInteger)index {
    
    if(gridView == self.presetsGridView){
        
        THClientScene * scene = [self.presets objectAtIndex:index];
        [self proceedToScene:scene];
        
    } else if(gridView == self.gridView){
        
        THClientScene * scene = [self.scenes objectAtIndex:index];
        [scene loadFromArchive];
        [self proceedToScene:scene];
    }
}

-(void) gridView:(THClientGridView *)gridView didDeleteViewAtIndex:(NSUInteger)index {
    
    if(index < self.scenes.count){
        
        THClientScene * scene = [self.scenes objectAtIndex:index];
        [self.scenes removeObjectAtIndex:index];
        
        [scene deleteArchive];
    }
}

-(void) gridView:(THClientGridView *)gridView didRenameViewAtIndex:(NSUInteger)index newName:(NSString *)newName {/*
    THClientProject *project = [scenes objectAtIndex:index];
    [scene renameTo:newName];*/
}

#pragma mark - Segue

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"segueToDownloadApp"]){
        THClientDownloadViewController * controller = segue.destinationViewController;
        controller.scenes = (NSArray*) self.scenes;
    }
}

#pragma mark - UI Interaction

-(void) updateGridViewsVisibility{
    
    if(self.showingCustomApps){
        self.gridView.hidden = NO;
        self.presetsGridView.hidden = YES;
    } else {
        self.gridView.hidden = YES;
        self.presetsGridView.hidden = NO;
    }
}

- (IBAction)filterControlChanged:(id)sender {
    [self updateGridViewsVisibility];
}

- (IBAction)editTapped:(id)sender {
    
    if(self.showingCustomApps){
        
        self.gridView.editing = YES;
        
    } else {
        
        self.presetsGridView.editing = YES;
    }
}


#pragma mark - Other

-(BOOL) showingCustomApps{
    
    return (self.filterControl.selectedSegmentIndex == 0);
}

@end
