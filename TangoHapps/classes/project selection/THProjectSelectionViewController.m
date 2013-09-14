//
//  TFProjectSelectionViewController.m
//  TangoFramework
//
//  Created by Juan Haladjian on 10/17/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THProjectSelectionViewController.h"
#import "THProjectProxy.h"
#import "THCollectionProjectCell.h"
#import "THProjectDraggableCell.h"
#import "THCustomProject.h"
#import "THTableProjectCell.h"

@implementation THProjectSelectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.projectProxies = [THDirector sharedDirector].projectProxies;
    
    CCDirector *director = [CCDirector sharedDirector];
    if([director isViewLoaded] == NO) {
        director.view = [self createDirectorGLView];
        [self didInitializeDirector];
    }
    
    self.editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonTapped:)];
    
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
    
    self.navigationItem.leftBarButtonItem = self.editButton;
    
}

#pragma  mark - init cocos2d

- (CCGLView *)createDirectorGLView {

    float navBarHeight = self.navigationController.navigationBar.frame.size.height;
    float statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    CCGLView *glView = [CCGLView viewWithFrame:CGRectMake(0, 0, 1024, 768 - navBarHeight - statusBarHeight)
                                   pixelFormat:kEAGLColorFormatRGB565
                                   depthFormat:0
                            preserveBackbuffer:NO
                                    sharegroup:nil
                                 multiSampling:NO
                               numberOfSamples:0];
    return glView;
}

- (void)didInitializeDirector
{
    CCDirector *director = [CCDirector sharedDirector];
    
    [director setAnimationInterval:1.0f/60.0f];
    [director enableRetinaDisplay:YES];
}

-(void) viewWillAppear:(BOOL)animated{
    if(self.showingIcons){
        [self addGestureRecognizers];
    }
    
    [self.collectionView reloadData];
    [self.tableView reloadData];
    
    [self updateEditButtonEnabledState];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources  that can be recreated.
}

-(NSString*) title{
    return @"Projects";
}

-(void) addGestureRecognizers{
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

-(void) removeGestureRecognizers{
    [self.view removeGestureRecognizer: tapRecognizer];
    [self.view removeGestureRecognizer: panRecognizer];
    [self.view removeGestureRecognizer: longpressRecognizer];
    
    tapRecognizer = nil;
    panRecognizer = nil;
    longpressRecognizer = nil;
}

-(void) viewWillDisappear:(BOOL)animated{
    
    [self stopEditingScenes];
    [self removeGestureRecognizers];
}

#pragma mark - Private

- (void)proceedToProjectAtIndex:(NSInteger) index{
    
    THProjectProxy * proxy = [self.projectProxies objectAtIndex:index];
    THCustomProject * project = (THCustomProject*) [THCustomProject projectSavedWithName:proxy.name];
    
    [THDirector sharedDirector].currentProxy = proxy;
    [THDirector sharedDirector].currentProject = project;
    
    [self performSegueWithIdentifier:@"segueToProjectView" sender:self];
}

- (void)proceedToNewProject{
    
    THCustomProject * project = [THCustomProject newProject];
    
    [THDirector sharedDirector].currentProject = project;
    
    [self performSegueWithIdentifier:@"segueToProjectView" sender:self];
}

-(void) deleteProjectAtIndex:(NSInteger) index{
    
    THProjectProxy * projectProxy = [self.projectProxies objectAtIndex:index];
    [self.projectProxies removeObjectAtIndex:index];
    
    [TFFileUtils deleteDataFile:projectProxy.name fromDirectory:kProjectsDirectory];
    
    NSString * imageName = [projectProxy.name stringByAppendingString:@".png"];
    [TFFileUtils deleteDataFile:imageName fromDirectory:kProjectImagesDirectory];
}

#pragma mark - Collection DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [THDirector sharedDirector].projectProxies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    THProjectProxy * proxy = [[THDirector sharedDirector].projectProxies objectAtIndex:indexPath.row];

    THCollectionProjectCell * cell = (THCollectionProjectCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"projectCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.nameTextField.text = proxy.name;
    cell.imageView.image = proxy.image;
    cell.editing = NO;
    cell.nameTextField.hidden = NO;
    
    return cell;
}



#pragma mark - Collection View Delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"selected: %@",indexPath);
    return YES;
}

-(void) collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.editingScenes){
        
        for(int i = 0 ; i < self.projectProxies.count ; i++){
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            THCollectionProjectCell * cell =  (THCollectionProjectCell*) [self.collectionView cellForItemAtIndexPath:indexPath];
            [cell startShaking];
        }
    }
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.editingScenes || self.editingOneScene) return NO;
    
    THCollectionProjectCell * cell = (THCollectionProjectCell*) [self.collectionView cellForItemAtIndexPath:indexPath];
    [self showDuplicateMenuForCell:cell];
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    
    return YES;
}

-(void) collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [THDirector sharedDirector].projectProxies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    THProjectProxy * proxy = [[THDirector sharedDirector].projectProxies objectAtIndex:indexPath.row];
    
    THTableProjectCell * cell = (THTableProjectCell*) [tableView dequeueReusableCellWithIdentifier:@"projectTableCell"];
    cell.nameLabel.text = proxy.name;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"HH:mm:ss zzz"];
    NSString *dateString = [dateFormat stringFromDate:proxy.date];
    
    cell.dateLabel.text = dateString;
    cell.imageView.image = proxy.image;
    cell.delegate = self;
    
    /*
    cell.delegate = self;
    cell.title = proxy.name;
    cell.imageView.image = proxy.image;
    cell.editing = NO;
    cell.titleTextField.hidden = NO;*/
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       
    [self proceedToProjectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        THTableProjectCell * cell = (THTableProjectCell*) [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.textField resignFirstResponder];
        
        [self deleteProjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        if(self.projectProxies.count == 0){
            [self stopEditingScenes];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    id object = [self.projectProxies objectAtIndex:sourceIndexPath.row];
    [self.projectProxies removeObjectAtIndex:sourceIndexPath.row];
    [self.projectProxies insertObject:object atIndex:destinationIndexPath.row];
    
    [self.collectionView reloadData];
}

//
-(BOOL) tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIMenuItem * menuItem = [[UIMenuItem alloc] initWithTitle:@"Duplicate" action:@selector(duplicate:)];
    [[UIMenuController sharedMenuController] setMenuItems: @[menuItem]];
    [[UIMenuController sharedMenuController] update];
    
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    return YES;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    
}

#pragma mark - Table Project Cell Delegate

-(void) tableProjectCell:(THTableProjectCell*) cell didChangeNameTo:(NSString*) name{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    if(indexPath){
        THProjectProxy * proxy = [self.projectProxies objectAtIndex:indexPath.row];
        NSString * oldName = proxy.name;
        BOOL success = [THCustomProject renameProjectNamed:proxy.name toName:name];
        if(success){
            [TFFileUtils renameDataFile:oldName to:name inDirectory:kProjectImagesDirectory];
            
            cell.nameLabel.text = name;
            proxy.name = name;
            
            NSArray * indexPaths = [NSArray arrayWithObject:indexPath];
            [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

-(void) didDuplicateTableProjectCell:(THTableProjectCell*) cell{
    
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    if(indexPath){
        
        [self duplicateProjectAtIndex:indexPath.row];

        NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Editing

-(void) startEditingScenes{
    
    if(self.showingIcons){
        for(int i = 0 ; i < self.projectProxies.count ; i++){
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            THCollectionProjectCell * cell =  (THCollectionProjectCell*) [self.collectionView cellForItemAtIndexPath:indexPath];
            cell.editing = YES;
        }
    } else {
        [self.tableView setEditing:YES animated:YES];
    }
    
    self.editButton.title = @"Done";
    self.editingScenes = YES;
    self.editingOneScene = NO;
    
    self.navigationItem.leftBarButtonItem = self.doneButton;
}

-(void) stopEditingScenes{
    
    //if(self.showingIcons){
        for(int i = 0 ; i < self.projectProxies.count ; i++){
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            THCollectionProjectCell * cell =  (THCollectionProjectCell*) [self.collectionView cellForItemAtIndexPath:indexPath];
            cell.editing = NO;
        }
    //} else {
        [self.tableView setEditing:NO animated:YES];
    //}
    
    self.editButton.title = @"Edit";
    self.editingScenes = NO;
    self.editingOneScene = NO;
    
    self.navigationItem.leftBarButtonItem = self.editButton;
}

#pragma mark - Gestures

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if([touch.view isKindOfClass:[UIControl class]]){
        return NO;
    }
    return YES;
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if((self.editingScenes || self.editingOneScene) && currentProject && (gestureRecognizer == panRecognizer || otherGestureRecognizer == panRecognizer)) {
        
        return NO;
    }
    
    if((gestureRecognizer == tapRecognizer && otherGestureRecognizer == longpressRecognizer) || (gestureRecognizer == longpressRecognizer && otherGestureRecognizer == tapRecognizer)){
        return (self.editingScenes || self.editingOneScene);
    }

    return YES;
}

-(void) handleStartedMoving:(CGPoint) position{
    
    NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:position];
    
    if(indexPath){
        
        currentProjectCell = (THCollectionProjectCell*) [self.collectionView cellForItemAtIndexPath:indexPath];
        currentProject = [self.projectProxies objectAtIndex:indexPath.row];
        
        if(currentProjectCell.editing){
            
            currentDraggableCell = [[THProjectDraggableCell alloc] initWithFrame:currentProjectCell.frame];
            currentDraggableCell.imageView.image = currentProjectCell.imageView.image;
            currentDraggableCell.imageView.frame = currentProjectCell.imageView.frame;
            
            [self.projectProxies removeObject:currentProject];
            NSArray * indexPaths = [NSArray arrayWithObjects:indexPath, nil];
            [self.collectionView deleteItemsAtIndexPaths:indexPaths];
            
            [self.view addSubview:currentDraggableCell];
            
        }
    }
}

-(void) handleStoppedMoving{
    
    if(currentProjectCell){
        
        NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:currentDraggableCell.center];
        
        if(!indexPath){
            indexPath = [NSIndexPath indexPathForRow:self.projectProxies.count inSection:0];
        }
        
        [self.projectProxies insertObject:currentProject atIndex:indexPath.row];
        [currentDraggableCell removeFromSuperview];
        
        NSArray * indexPaths = [NSArray arrayWithObject:indexPath];
        [self.collectionView insertItemsAtIndexPaths:indexPaths];
        
        currentProject = nil;
        currentProjectCell = nil;
        currentDraggableCell = nil;
        
        //[self stopEditingScenes];
    }
}

-(void) moved:(UIPanGestureRecognizer*) recognizer{
    
    if(self.editingScenes || self.editingOneScene){
        
        CGPoint position = [recognizer locationInView:self.collectionView];
        
        if(recognizer.state == UIGestureRecognizerStateBegan){
            
            [self handleStartedMoving:position];
            
        } else if(recognizer.state == UIGestureRecognizerStateChanged){
            
            currentDraggableCell.center = position;
            
        } else if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded){
            
            //[self handleStoppedMoving];
        }
    }
}

-(void) startEditingScene{
    
    self.editingOneScene = YES;
    currentProjectCell.editing = YES;
}

-(void) duplicateProjectAtIndex:(NSInteger) index{
    
    THProjectProxy * proxy = [self.projectProxies objectAtIndex:index];
    
    //project
    THCustomProject * project = [THCustomProject projectNamed:proxy.name];
    project.name = [THCustomProject nextProjectNameForName:project.name];
    [project save];
    
    //image
    NSString * imageFileName = [project.name stringByAppendingString:@".png"];
    NSString * imageFilePath = [TFFileUtils dataFile:imageFileName
                                         inDirectory:kProjectImagesDirectory];
    [TFFileUtils saveImageToFile:proxy.image file:imageFilePath];
    
    //proxy array
    THProjectProxy * proxyCopy = [proxy copy];
    proxyCopy.name = project.name;
    [self.projectProxies insertObject:proxyCopy atIndex:index+1];
}

-(void) showDuplicateMenuForCell:(THCollectionProjectCell*) cell{
    
    //[cell becomeFirstResponder];
    
    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"Duplicate" action:@selector(duplicate:)];
    UIMenuController *menuCont = [UIMenuController sharedMenuController];
    [menuCont setTargetRect:cell.frame inView:self.collectionView];
    menuCont.arrowDirection = UIMenuControllerArrowUp;
    menuCont.menuItems = @[menuItem];
}

-(void) pressedLong:(UILongPressGestureRecognizer*) recognizer{
    
    if(recognizer.state == UIGestureRecognizerStateBegan){
        if(self.showingIcons &&  !(self.editingScenes || self.editingOneScene)){
            
            CGPoint position = [recognizer locationInView:self.collectionView];
            NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:position];
            THCollectionProjectCell * cell = (THCollectionProjectCell*) [self.collectionView cellForItemAtIndexPath: indexPath];
            
            if(cell){
                [cell scaleEffect];
                currentProjectCell = cell;
                [NSTimer scheduledTimerWithTimeInterval:kProjectCellScaleEffectDuration target:self selector:@selector(startEditingScene) userInfo:nil repeats:NO];
                
                //[self showDuplicateMenuForCell:cell];
            }
        }        
    }
}

-(void) tapped:(UITapGestureRecognizer*) recognizer{
    
    if(self.editingScenes || self.editingOneScene){
        
        [self stopEditingScenes];

    } else {
        
        CGPoint position = [recognizer locationInView:self.collectionView];
        NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:position];
        
        if(indexPath){            
            [self proceedToProjectAtIndex:indexPath.row];
        }
    }
}

#pragma mark - Segue

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

}

#pragma mark - GridItem Delegate

-(void) resignAllCellFirstResponders{
    
    for (int i = 0 ; i < self.projectProxies.count; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        THCollectionProjectCell * aCell = (THCollectionProjectCell*) [self.collectionView cellForItemAtIndexPath:indexPath];
        [aCell.nameTextField resignFirstResponder];
    }
}

-(void) didDeleteProjectCell:(THCollectionProjectCell*) cell {
    
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
    if(indexPath){
        //[self resignFirstResponder];
        
        [self deleteProjectAtIndex:indexPath.row];
        [self resignAllCellFirstResponders];
        
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        
        if(self.projectProxies.count == 0){
            [self stopEditingScenes];
            [self updateEditButtonEnabledState];
        }
    }
}

-(void) didDuplicateProjectCell:(THCollectionProjectCell*) cell {
    
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
    if(indexPath){
        
        [self duplicateProjectAtIndex:indexPath.row];
        
        //collection view
        NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
        [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
    }
}

-(void) didRenameProjectCell:(THCollectionProjectCell *)cell toName:(NSString *)name{
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
    if(indexPath){
        THProjectProxy * proxy = [self.projectProxies objectAtIndex:indexPath.row];
        NSString * oldName = [proxy.name stringByAppendingString:@".png"];
        BOOL success = [THCustomProject renameProjectNamed:proxy.name toName:name];
        if(success){

            NSString * imageName = [name stringByAppendingString:@".png"];
            [TFFileUtils renameDataFile:oldName to:imageName inDirectory:kProjectImagesDirectory];
            
            cell.nameTextField.text = name;
            proxy.name = name;
            
            //[self.collectionView reloadData];
            //[self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
    }
}

#pragma mark - UI Interaction

-(BOOL) showingIcons{
    return (self.viewControl.selectedSegmentIndex == 0);
}

-(void) updateEditButtonEnabledState{
    if(self.projectProxies.count == 0){
        self.editButton.enabled = NO;
    } else{
        self.editButton.enabled = YES;
    }
}

- (IBAction)addButtonTapped:(id)sender {
    
    [self proceedToNewProject];
}

- (IBAction)viewControlChanged:(id)sender {
    
    if(self.editingScenes){
        [self stopEditingScenes];
    }
    
    if(self.showingIcons){
        [self.collectionView reloadData];
        
        self.tableView.hidden = YES;
        self.collectionView.hidden = NO;
        [self addGestureRecognizers];
        
        
        
    } else {
        [self.tableView reloadData];
        
        self.tableView.hidden = NO;
        self.collectionView.hidden = YES;
        
        [self removeGestureRecognizers];
    }
    
}

- (IBAction)filterControlChanged:(id)sender {
}

- (IBAction)orderControlChanged:(id)sender {
}

- (IBAction)textEditingFinished:(id)sender {
}

- (void) editButtonTapped:(id)sender {
    [self startEditingScenes];
}

- (void) doneButtonTapped:(id)sender {
    
    [self stopEditingScenes];
}


@end
