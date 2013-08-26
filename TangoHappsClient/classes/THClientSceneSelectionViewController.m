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
#import "THClientSceneCell.h"
#import "THClientSceneDraggableCell.h"
#import "THClientAppDelegate.h"

@implementation THClientSceneSelectionViewController


-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
    }
    return self;
}

#pragma mark - View Lifecycle

-(void) generateRandomScenes{
    NSMutableArray * array = [NSMutableArray array];
    
    for (int i = 0; i < 7; i ++) {
        
        NSString * name = [NSString stringWithFormat:@"halloProject %d",i];
        THClientScene * scene = [[THClientScene alloc] initWithName:name];
        [array addObject:scene];
    }
    
    [THClientScene persistScenes:array];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadGestureRecognizers];
    
    //[self generateRandomScenes];
    
    self.fakeScenesSource = [[THClientPresetsGenerator alloc] init];
    self.presets = self.fakeScenesSource.scenes;
    
    THClientAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.scenes =  appDelegate.scenes;
    
    [self.scenesCollectionView reloadData];
    
    [self reloadData];
}

-(void) loadGestureRecognizers{
    ///tap
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
    
    //move
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moved:)];
    panRecognizer.delegate = self;
    [self.view addGestureRecognizer:panRecognizer];
    
    //long Press
    longpressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressedLong:)];
    longpressRecognizer.delegate = self;
    [self.view addGestureRecognizer:longpressRecognizer];
}

-(void) viewWillDisappear:(BOOL)animated{
    
    [self stopEditingScenes];
        
}

/*
#pragma mark - Grid View delegate

-(CGSize) gridItemSizeForGridView:(THGridView*) view{
    return CGSizeMake(100, 224);
}

-(CGPoint) gridItemPaddingForGridView:(THGridView*) view{
    return CGPointMake(5, 1);
}

-(CGPoint) gridPaddingForGridView:(THGridView*) view{
    return CGPointMake(0,5);
}*/

/*
#pragma mark Interface Actions

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.gridView setEditing:editing];
}*/

#pragma mark - Private

- (void)reloadData {
/*
    [self.gridView reloadData];
    [self.presetsGridView reloadData];*/
}

- (void)proceedToScene:(THClientScene*) scene {
    [THSimulableWorldController sharedInstance].currentScene = scene;
    [THSimulableWorldController sharedInstance].currentProject = [self.fakeScenesSource projectNamed:scene.name];
    
    [self performSegueWithIdentifier:@"segueToAppView" sender:self];
}


#pragma mark - Collection DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView == self.scenesCollectionView){
        return self.scenes.count;
    } else {
        return self.presets.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    THClientSceneCell * cell;
    
    if(collectionView == self.scenesCollectionView){
                
        THClientScene * scene = [self.scenes objectAtIndex:indexPath.row];
        cell = (THClientSceneCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"sceneCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.title = scene.name;
        cell.imageView.image = scene.image;
        cell.editing = NO;
        cell.titleTextField.hidden = NO;
        
//        cell.titleTextField.hidden = NO;
        
    } else {
        
        THClientScene * preset = [self.presets objectAtIndex:indexPath.row];
        
        cell = (THClientSceneCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"presetCell" forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"fakeSceneImage.png"];
        cell.title = preset.name;
    }
    
    return cell;
}



#pragma mark - Editing

-(void) startEditingScenes{
    
    NSMutableArray * currentScenes = self.currentScenesArray;
    UICollectionView * currentCollection = self.currentCollectionView;
    
    for(int i = 0 ; i < currentScenes.count ; i++){
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        THClientSceneCell * cell =  (THClientSceneCell*) [currentCollection cellForItemAtIndexPath:indexPath];
        cell.editing = YES;
    }
    
    self.editingScenes = YES;
}

-(void) stopEditingScenes{
    
    NSMutableArray * currentScenes = self.currentScenesArray;
    UICollectionView * currentCollection = self.currentCollectionView;
    
    for(int i = 0 ; i < currentScenes.count ; i++){
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        THClientSceneCell * cell =  (THClientSceneCell*) [currentCollection cellForItemAtIndexPath:indexPath];
        cell.editing = NO;
    }
    
    self.editingScenes = NO;
}

#pragma mark - Gestures

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if([touch.view isKindOfClass:[UIControl class]]){
        return NO;
    }
    return YES;
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if(self.editingScenes && currentScene && (gestureRecognizer == panRecognizer || otherGestureRecognizer == panRecognizer)) {
        
        return NO;
    }
    
    if((gestureRecognizer == tapRecognizer && otherGestureRecognizer == longpressRecognizer) || (gestureRecognizer == longpressRecognizer && otherGestureRecognizer == tapRecognizer)){
        return self.editingScenes;
    }
    
    return YES;
}

-(void) handleStartedMoving:(CGPoint) position{
    
    NSIndexPath * indexPath = [self.currentCollectionView indexPathForItemAtPoint:position];
    
    if(indexPath){
        
        currentSceneCell = (THClientSceneCell*) [self.currentCollectionView cellForItemAtIndexPath:indexPath];
        currentScene = [self.currentScenesArray objectAtIndex:indexPath.row];
        
        if(currentSceneCell.editing){
            
            currentDraggableCell = [[THClientSceneDraggableCell alloc] initWithFrame:currentSceneCell.frame];
            currentDraggableCell.imageView.image = currentSceneCell.imageView.image;
            currentDraggableCell.imageView.frame = currentSceneCell.imageView.frame;
            
            [self.currentScenesArray removeObject:currentScene];
            NSArray * indexPaths = [NSArray arrayWithObjects:indexPath, nil];
            [self.currentCollectionView deleteItemsAtIndexPaths:indexPaths];
            
            [self.view addSubview:currentDraggableCell];
        }
    }
}

-(void) handleStoppedMoving{
    
    if(currentSceneCell){
        
        NSIndexPath * indexPath = [self.currentCollectionView indexPathForItemAtPoint:currentDraggableCell.center];
        
        if(!indexPath){
            indexPath = [NSIndexPath indexPathForRow:self.currentScenesArray.count inSection:0];
        }
        
        [self.currentScenesArray insertObject:currentScene atIndex:indexPath.row];
        [currentDraggableCell removeFromSuperview];
        
        NSArray * indexPaths = [NSArray arrayWithObject:indexPath];
        [self.currentCollectionView insertItemsAtIndexPaths:indexPaths];
        
        currentSceneCell = nil;
        currentScene = nil;
        currentDraggableCell = nil;
        
        [self stopEditingScenes];
        
    }
}

-(void) moved:(UIPanGestureRecognizer*) recognizer{
    
    if(self.editingScenes){
        
        CGPoint position = [recognizer locationInView:self.currentCollectionView];
        
        if(recognizer.state == UIGestureRecognizerStateBegan){
            
            [self handleStartedMoving:position];
            
        } else if(recognizer.state == UIGestureRecognizerStateChanged){
                        
            currentDraggableCell.center = position;
            
        } else if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded){
            
            [self handleStoppedMoving];
        }
    }
}

-(void) pressedLong:(UILongPressGestureRecognizer*) recognizer{
    
    if(recognizer.state == UIGestureRecognizerStateBegan &&  !self.editingScenes){
        
        CGPoint position = [recognizer locationInView:self.currentCollectionView];
        NSIndexPath * indexPath = [self.currentCollectionView indexPathForItemAtPoint:position];
        THClientSceneCell * cell = (THClientSceneCell*) [self.currentCollectionView cellForItemAtIndexPath: indexPath];
        
        if(cell){
            [cell scaleEffect];
            self.editingScenes = YES;
            cell.editing = YES;
        }
    }
}

-(void) tapped:(UITapGestureRecognizer*) recognizer{
    if(self.editingScenes){
        
        [self stopEditingScenes];
        //self.currentGridView.editing = NO;
    } else {
        
        CGPoint position = [recognizer locationInView:self.currentCollectionView];
        NSIndexPath * indexPath = [self.currentCollectionView indexPathForItemAtPoint:position];
        
        if(indexPath){
            THClientScene * scene = [self.presets objectAtIndex:indexPath.row];
            [self proceedToScene:scene];
        }
    }
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
        self.scenesCollectionView.hidden = NO;
        self.presetsCollectionView.hidden = YES;
        self.editButton.enabled = YES;
    } else {
        self.scenesCollectionView.hidden = YES;
        self.presetsCollectionView.hidden = NO;
        self.editButton.enabled = NO;
    }
}

- (IBAction)filterControlChanged:(id)sender {
    [self updateGridViewsVisibility];
}

- (IBAction)editTapped:(id)sender {
    
    if(self.editingScenes){
        [self stopEditingScenes];
        self.editButton.title = @"Edit";
    } else {
        [self startEditingScenes];
        self.editButton.title = @"Done";
    }
}

#pragma mark - GridItem Delegate

-(void) didDeleteClientSceneCell:(THClientSceneCell*)cell {
    
    NSIndexPath * indexPath = [self.scenesCollectionView indexPathForCell:cell];
    if(indexPath){
        
        [self.scenes removeObjectAtIndex:indexPath.row];
        NSArray * indexPaths = [NSArray arrayWithObject:indexPath];
        [self.scenesCollectionView deleteItemsAtIndexPaths:indexPaths];
    }
}

#pragma mark - Other

-(BOOL) showingCustomApps{
    
    return (self.filterControl.selectedSegmentIndex == 0);
}

-(UICollectionView*) currentCollectionView{
    return self.showingCustomApps ? self.scenesCollectionView : self.presetsCollectionView;
}
-(NSMutableArray*) currentScenesArray{
    return self.showingCustomApps ? self.scenes : self.presets;
}

@end
