/*
THProjectSelectionViewController.m
Interactex Designer

Created by Juan Haladjian on 05/10/2013.

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

#import "THProjectSelectionViewController.h"
#import "THProjectProxy.h"
#import "THCollectionProjectCell.h"
#import "THProjectDraggableCell.h"
#import "THProject.h"
#import "THTableProjectCell.h"

@implementation THProjectSelectionViewController

CGSize const kProjectSelectionActivityIndicatorViewSize = {200,100};
CGSize const kProjectSelectionActivityIndicatorLabelSize = {180,80};

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.projectProxies = [THDirector sharedDirector].projectProxies;
    
    CCDirector *director = [CCDirector sharedDirector];
    if([director isViewLoaded] == NO) {
        director.view = [self createDirectorGLView];
        [self didInitializeDirector];
    }
    
    self.editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonTapped:)];
    
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
    
    self.navigationItem.leftBarButtonItem = self.editButton;
    
    [self addActivityView];
}

-(void) addActivityView{
    
    CGSize viewSize = self.view.frame.size;
    
    CGRect rect = CGRectMake(viewSize.height/2 - kProjectSelectionActivityIndicatorViewSize.width/2, viewSize.width/2 - kProjectSelectionActivityIndicatorViewSize.height/2,kProjectSelectionActivityIndicatorViewSize.width,kProjectSelectionActivityIndicatorViewSize.height);
                                                                                                                         
    self.activityIndicatorView = [[UIView alloc] initWithFrame:rect];
    self.activityIndicatorView.backgroundColor = [UIColor grayColor];
    self.activityIndicatorView.hidden = YES;
    [self.view addSubview:self.activityIndicatorView];
    
    rect = CGRectMake(rect.size.width/2 - kProjectSelectionActivityIndicatorLabelSize.width/2, rect.size.height/2 - kProjectSelectionActivityIndicatorLabelSize.height/2 - 30,kProjectSelectionActivityIndicatorLabelSize.width,kProjectSelectionActivityIndicatorLabelSize.height);
    UILabel * label = [[UILabel alloc] initWithFrame:rect];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Loading project...";
    [self.activityIndicatorView addSubview:label];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGRect frame = self.activityIndicator.frame;
                             
    viewSize = self.activityIndicatorView.frame.size;
    frame.origin = CGPointMake(viewSize.width/2 - frame.size.width/2, viewSize.height/2 - frame.size.height/2 +10);
    self.activityIndicator.frame = frame;
    [self.activityIndicatorView addSubview: self.activityIndicator];
    
    self.activityIndicatorView.layer.borderWidth = 1.0f;
    self.activityIndicatorView.layer.cornerRadius = 5.0f;
    self.activityIndicatorView.layer.masksToBounds = YES;
}

#pragma  mark - init cocos2d

- (CCGLView *)createDirectorGLView {

    float navBarHeight = self.navigationController.navigationBar.frame.size.height;
    //float statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    CCGLView *glView = [CCGLView viewWithFrame:CGRectMake(0, 0, 1024, 768 - navBarHeight)
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
    
    [director setAnimationInterval:1.0f/30.0f];
    [director enableRetinaDisplay:YES];
}

-(void) viewWillAppear:(BOOL)animated{
    if(self.showingIcons){
        [self addGestureRecognizers];
    }
    
    [self.collectionView reloadData];
    [self.tableView reloadData];
    [self.tableViewSecond reloadData];
    
    [self updateEditButtonEnabledState];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.totalNumberOfProjects = self.projectProxies.count; // nazmus added
    
    //Nazmus 15 Nov 14
    [self beautifyProjectSelectionScreen];
    [self setupIndicesForMultipleTables];
    
}

//Nazmus 15 Nov 14
- (void) beautifyProjectSelectionScreen {
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:font, @1.3, nil] forKeys:[NSArray arrayWithObjects:NSFontAttributeName, NSKernAttributeName, nil]];
    
    
    //"VIEW AS:" label
    NSString *lblContent = @"VIEW AS:";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:lblContent];
    [attributedString addAttribute:NSKernAttributeName
                             value:@(1.3)
                             range:NSMakeRange(0, [lblContent length])];
    
    UILabel *viewAsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 11.0f, 70.0f, 21.0f)];
    [viewAsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f]];
    [viewAsLabel setBackgroundColor:[UIColor clearColor]];
    [viewAsLabel setTextColor:[UIColor whiteColor]];
    [viewAsLabel setAttributedText:attributedString];
    [viewAsLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.labelViewAs setCustomView:viewAsLabel];
    ////
    
    //Segmented control
    // Set divider images
    [self.viewControl setDividerImage:[UIImage imageNamed:@"segDivider.png"]
                  forLeftSegmentState:UIControlStateNormal
                    rightSegmentState:UIControlStateNormal
                           barMetrics:UIBarMetricsDefault];
    [self.viewControl setDividerImage:[UIImage imageNamed:@"segDivider.png"]
                  forLeftSegmentState:UIControlStateSelected
                    rightSegmentState:UIControlStateNormal
                           barMetrics:UIBarMetricsDefault];
    [self.viewControl setDividerImage:[UIImage imageNamed:@"segDivider.png"]
                  forLeftSegmentState:UIControlStateNormal
                    rightSegmentState:UIControlStateSelected
                           barMetrics:UIBarMetricsDefault];
    
    // Set background images
    UIImage *normalBackgroundImage = [[UIImage imageNamed:@"segBg"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)];
    [self.viewControl  setBackgroundImage:normalBackgroundImage
                                 forState:UIControlStateNormal
                               barMetrics:UIBarMetricsDefault];
    UIImage *selectedBackgroundImage = [[UIImage imageNamed:@"segBgSelected"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)];
    [self.viewControl setBackgroundImage:selectedBackgroundImage
                                forState:UIControlStateSelected
                              barMetrics:UIBarMetricsDefault];
    
    [self.viewControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    ////
    
    //"ABOUT INTERACTEX" button
    lblContent = @"ABOUT INTERACTEX";
    attributedString = [[NSMutableAttributedString alloc] initWithString:lblContent];

    [attributedString addAttribute:NSKernAttributeName
                             value:@(1.3)
                             range:NSMakeRange(0, [lblContent length])];
    
    UIButton *aboutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [lblContent length]*10, 29)];
    [aboutButton setBackgroundColor:[UIColor clearColor]];
    [aboutButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f]];
    [aboutButton.titleLabel setTextColor:[UIColor whiteColor]];
    [aboutButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    [aboutButton addTarget:self action:@selector(aboutButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttonAbout setCustomView:aboutButton];
    ////
    
    //"IMPRINT" button
    lblContent = @"IMPRINT";
    attributedString = [[NSMutableAttributedString alloc] initWithString:lblContent];
    
    [attributedString addAttribute:NSKernAttributeName
                             value:@(1.3)
                             range:NSMakeRange(0, [lblContent length])];
    
    UIButton *imprintButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [lblContent length]*10, 29)];
    [imprintButton setBackgroundColor:[UIColor clearColor]];
    [imprintButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f]];
    [imprintButton.titleLabel setTextColor:[UIColor whiteColor]];
    [imprintButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    [imprintButton addTarget:self action:@selector(imprintButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttonImprint setCustomView:imprintButton];
    ////
    
    //Table view
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableViewSecond.layoutMargins = UIEdgeInsetsZero;
    ////
    
    //"YOUR PROJECT" label
    lblContent = @"YOUR PROJECTS";
    attributedString = [[NSMutableAttributedString alloc] initWithString:lblContent];
    [attributedString addAttribute:NSKernAttributeName
                             value:@(1.3)
                             range:NSMakeRange(0, [lblContent length])];
    [self.labelProjects setAttributedText:attributedString];
    
    
}

- (void)setupIndicesForMultipleTables {
    self.oddProjectProxyIndices = [[NSMutableArray alloc] init];
    self.evenProjectProxyIndices = [[NSMutableArray alloc] init];
    for(int i = 0 ; i < self.projectProxies.count ; i++){
        if (i%2 == 1) { //odd
            [self.oddProjectProxyIndices addObject:[NSNumber numberWithInt:i]];
        } else {
            [self.evenProjectProxyIndices addObject:[NSNumber numberWithInt:i]];
        }
    }
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
    
    [[THDirector sharedDirector] saveProjectProxies];
    
    [self stopActivityIndicator];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - Private

-(void) startActivityIndicator{
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicator startAnimating];
}

-(void) stopActivityIndicator{
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicator stopAnimating];
}

- (void)proceedToProjectAtIndex:(NSInteger) index{
    
    [self startActivityIndicator];
    
    THProjectProxy * proxy = [self.projectProxies objectAtIndex:index];
    THProject * project = (THProject*) [THProject projectSavedWithName:proxy.name];
    
    //update its name since it could have been renamed while it was not loaded
    project.name = proxy.name;
    
    [THDirector sharedDirector].currentProxy = proxy;
    [THDirector sharedDirector].currentProject = project;
    
    [self performSegueWithIdentifier:@"segueToProjectView" sender:self];
}

- (void)proceedToNewProject{
    
    [self startActivityIndicator];
    
    THProject * project = [THProject newProject];
    
    [THDirector sharedDirector].currentProject = project;
    
    [self performSegueWithIdentifier:@"segueToProjectView" sender:self];
}

-(void) deleteProjectAtIndex:(NSInteger) index{
    
    THProjectProxy * projectProxy = [self.projectProxies objectAtIndex:index];
    [self.projectProxies removeObjectAtIndex:index];
    
    [TFFileUtils deleteDataFile:projectProxy.name fromDirectory:kProjectsDirectory];
    /*
    NSString * imageName = [projectProxy.name stringByAppendingString:@".png"];
    [TFFileUtils deleteDataFile:imageName fromDirectory:kProjectImagesDirectory];*/
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
    if(tableView == self.tableView) {
        return ceil((float)[THDirector sharedDirector].projectProxies.count / 2);
    } else if(tableView == self.tableViewSecond) {
        return floor((float)[THDirector sharedDirector].projectProxies.count / 2);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    THProjectProxy * proxy;
    if(tableView == self.tableView) {
        proxy = [[THDirector sharedDirector].projectProxies objectAtIndex:[self.evenProjectProxyIndices[indexPath.row] integerValue]];
    } else if(tableView == self.tableViewSecond) {
        proxy = [[THDirector sharedDirector].projectProxies objectAtIndex:[self.oddProjectProxyIndices[indexPath.row] integerValue]];
    }
    
    THTableProjectCell * cell = (THTableProjectCell*) [tableView dequeueReusableCellWithIdentifier:@"projectTableCell"];
    cell.nameLabel.text = proxy.name;
    
    //Nazmus 15 Nov 14
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.contentView.superview.backgroundColor = [UIColor clearColor];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor darkGrayColor];
    [cell setSelectedBackgroundView:bgColorView];
    ////
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    dateFormat.dateStyle = NSDateFormatterMediumStyle;
    
    //[dateFormat setDateFormat:@"HH:mm:ss zzz"];
    NSString *dateString = [dateFormat stringFromDate:proxy.date];
    
    cell.dateLabel.text = dateString;
    cell.delegate = self;
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.tableView) {
        [self proceedToProjectAtIndex:[self.evenProjectProxyIndices[indexPath.row] integerValue]];
    } else if(tableView == self.tableViewSecond) {
        [self proceedToProjectAtIndex:[self.oddProjectProxyIndices[indexPath.row] integerValue]];
    }
    //[self proceedToProjectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (tableView == self.tableView) {
            THTableProjectCell * cell = (THTableProjectCell*) [self.tableView cellForRowAtIndexPath:indexPath];
            [cell.textField resignFirstResponder];
            
            //[self deleteProjectAtIndex:indexPath.row];
            [self deleteProjectAtIndex:[self.evenProjectProxyIndices[indexPath.row] integerValue]];
            
        } else if (tableView == self.tableViewSecond){
            THTableProjectCell * cell = (THTableProjectCell*) [self.tableViewSecond cellForRowAtIndexPath:indexPath];
            [cell.textField resignFirstResponder];
            
            [self deleteProjectAtIndex:[self.oddProjectProxyIndices[indexPath.row] integerValue]];
            
        }
        [self.tableView reloadData];
        [self.tableViewSecond reloadData];
        if(self.projectProxies.count == 0){
            [self stopEditingScenes];
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSUInteger actualSourceIndexPathRow = nil;
    NSUInteger actualDestinationIndexPathRow = nil;
    
    if (tableView == self.tableView) {
        actualSourceIndexPathRow = [self.evenProjectProxyIndices[sourceIndexPath.row] integerValue];
        actualDestinationIndexPathRow = [self.evenProjectProxyIndices[destinationIndexPath.row] integerValue];
    } else if (tableView == self.tableViewSecond) {
        actualSourceIndexPathRow = [self.evenProjectProxyIndices[sourceIndexPath.row] integerValue];
        actualDestinationIndexPathRow = [self.evenProjectProxyIndices[destinationIndexPath.row] integerValue];
    }
    
    id object = [self.projectProxies objectAtIndex:actualSourceIndexPathRow];
    [self.projectProxies removeObjectAtIndex:actualSourceIndexPathRow];
    [self.projectProxies insertObject:object atIndex:actualDestinationIndexPathRow];
    
    //[self setupIndicesForMultipleTables];
    //[self.tableView reloadData];
    //[self.tableViewSecond reloadData];
    //[self.collectionView reloadData];
    
}

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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

#pragma mark - Table Project Cell Delegate

-(void) tableProjectCell:(THTableProjectCell*) cell didChangeNameTo:(NSString*) name {
    NSIndexPath * indexPath;
    if ([cell getParentTableView] == self.tableView) {
        indexPath = [self.tableView indexPathForCell:cell];
        if(indexPath){
            THProjectProxy * proxy = [self.projectProxies objectAtIndex:[self.evenProjectProxyIndices[indexPath.row] integerValue]];
            //NSString * oldName = proxy.name;
            BOOL success = [THProject renameProjectNamed:proxy.name toName:name];
            if(success){
                //[TFFileUtils renameDataFile:oldName to:name inDirectory:kProjectImagesDirectory];
                
                cell.nameLabel.text = name;
                proxy.name = name;
                
                //NSArray * indexPaths = [NSArray arrayWithObject:indexPath];
                //[self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            }
        }

    } else if ([cell getParentTableView] == self.tableViewSecond) {
        indexPath = [self.tableViewSecond indexPathForCell:cell];
        if(indexPath){
            THProjectProxy * proxy = [self.projectProxies objectAtIndex:[self.oddProjectProxyIndices[indexPath.row] integerValue]];
            BOOL success = [THProject renameProjectNamed:proxy.name toName:name];
            if(success){
                cell.nameLabel.text = name;
                proxy.name = name;
                //NSArray * indexPaths = [NSArray arrayWithObject:indexPath];
                //[self.tableViewSecond reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
    [self.tableView reloadData];
    [self.tableViewSecond reloadData];
}

-(void) didDuplicateTableProjectCell:(THTableProjectCell*) cell{
    NSIndexPath * indexPath;
    if ([cell getParentTableView] == self.tableView) {
        indexPath = [self.tableView indexPathForCell:cell];
        if(indexPath){
            [self duplicateProjectAtIndex:[self.evenProjectProxyIndices[indexPath.row] integerValue]];
        }
    } else if ([cell getParentTableView] == self.tableViewSecond) {
        indexPath = [self.tableViewSecond indexPathForCell:cell];
        if(indexPath){
            [self duplicateProjectAtIndex:[self.evenProjectProxyIndices[indexPath.row] integerValue]];
        }
    }
    
    //NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
    //[self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.tableView reloadData];
    [self.tableViewSecond reloadData];
    
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
        [self.tableViewSecond setEditing:YES animated:YES];
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
        [self.tableViewSecond setEditing:NO animated:YES];
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
    
    if((self.editingScenes || self.editingOneScene) && self.currentProject && (gestureRecognizer == panRecognizer || otherGestureRecognizer == panRecognizer)) {
        
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
        
        self.currentProjectCell = (THCollectionProjectCell*) [self.collectionView cellForItemAtIndexPath:indexPath];
        self.currentProject = [self.projectProxies objectAtIndex:indexPath.row];
        
        if(self.currentProjectCell.editing){
            
            self.currentDraggableCell = [[THProjectDraggableCell alloc] initWithFrame:self.currentProjectCell.frame];
            self.currentDraggableCell.imageView.image = self.currentProjectCell.imageView.image;
            self.currentDraggableCell.imageView.frame = self.currentProjectCell.imageView.frame;
            
            [self.projectProxies removeObject:self.currentProject];
            NSArray * indexPaths = [NSArray arrayWithObjects:indexPath, nil];
            [self.collectionView deleteItemsAtIndexPaths:indexPaths];
            
            [self.view addSubview:self.currentDraggableCell];
            
        }
    }
}

-(NSInteger) indexForPoint:(CGPoint) point{
    NSInteger totalWidth = self.collectionView.frame.size.width;
    NSInteger cellWidth = self.currentProjectCell.frame.size.width;
    NSInteger cellHeight = self.currentProjectCell.frame.size.height;
    

    float spacingX = 10;
    float spacingY = 10;
    
    NSInteger fullCellWidth = spacingX * 2 + cellWidth;
    NSInteger fullCellHeight = spacingY * 2 + cellHeight;
    
    NSInteger maxCols = totalWidth / cellWidth;
    NSInteger row = (NSInteger) (point.y) / fullCellHeight;
    NSInteger col = (NSInteger) (point.x) / fullCellWidth;

    //NSLog(@"%.2f %.2f %d %d",point.x,point.y, row,col);
    
    NSInteger index = row * maxCols + col;
    
    if(index > self.projectProxies.count){
        index = self.projectProxies.count-1;
    }
    
    return index;
}

-(void) temporaryInsertDragCellAtIndex:(NSInteger) index{
        [self.projectProxies insertObject:self.currentProject atIndex:index];

        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        NSArray * indexPaths = [NSArray arrayWithObject:indexPath];
        [self.collectionView insertItemsAtIndexPaths:indexPaths];
        
        THCollectionProjectCell * cell = (THCollectionProjectCell*) [self.collectionView cellForItemAtIndexPath:indexPath];
        cell.editing = YES;
}

-(void) handleStoppedMoving{
    
    if(self.currentDraggableCell){
        
        [self.currentDraggableCell removeFromSuperview];
        
        //NSInteger index = [self indexForPoint:self.currentDraggableCell.center];
        //[self temporaryInsertDragCellAtIndex:index];
        
        self.currentProject = nil;
        self.currentProjectCell = nil;
        self.currentDraggableCell = nil;
    }
    
}

-(void) handleMovedToPosition:(CGPoint) position{
    
    if(self.currentDraggableCell){
        
        self.currentDraggableCell.center = position;
        
        NSInteger index = [self indexForPoint:self.currentDraggableCell.center];
        
        if(index != self.currentDraggableCellIndex && index < self.projectProxies.count){
            
            if(insertedTemporaryProject){
                [self.projectProxies removeObjectAtIndex:self.currentDraggableCellIndex];
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.currentDraggableCellIndex inSection:0];
                NSArray * indexPaths = [NSArray arrayWithObject:indexPath];
                [self.collectionView deleteItemsAtIndexPaths:indexPaths];
            }
            
            [self temporaryInsertDragCellAtIndex:index];
            
            insertedTemporaryProject = YES;
            
            self.currentDraggableCellIndex = index;
            
        }
    }
}

-(void) moved:(UIPanGestureRecognizer*) recognizer{
    
    // nazmus added to stop movement, if there is only one project
    if (self.totalNumberOfProjects < 2) {
        return;
    }
    ////
    
    if(self.editingScenes || self.editingOneScene){
        
        CGPoint position = [recognizer locationInView:self.collectionView];
        
        if(recognizer.state == UIGestureRecognizerStateBegan){
            self.currentDraggableCellIndex = -1;
            insertedTemporaryProject = NO;
            
            [self handleStartedMoving:position];
            
        } else if(recognizer.state == UIGestureRecognizerStateChanged){
            
            [self handleMovedToPosition:position];
                
        } else if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded){
            
            [self handleStoppedMoving];
        }
    }
}

-(void) startEditingScene{
    
    self.editingOneScene = YES;
    self.currentProjectCell.editing = YES;
}

-(void) duplicateProjectAtIndex:(NSInteger) index{
    
    THProjectProxy * proxy = [self.projectProxies objectAtIndex:index];
    
    //project
    THProject * project = [THProject projectSavedWithName:proxy.name];
    project.name = [THProject nextProjectNameForName:project.name];
    [project save];
    
    /*
    //image
    NSString * imageFileName = [project.name stringByAppendingString:@".png"];
    NSString * imageFilePath = [TFFileUtils dataFile:imageFileName
                                         inDirectory:kProjectImagesDirectory];
    [TFFileUtils saveImageToFile:proxy.image file:imageFilePath];*/
    
    //proxy array
    THProjectProxy * proxyCopy = [proxy copy];
    proxyCopy.name = project.name;
    [self.projectProxies insertObject:proxyCopy atIndex:index+1];
    
    self.totalNumberOfProjects = self.projectProxies.count; // nazmus added
    [self setupIndicesForMultipleTables];
    
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
                self.currentProjectCell = cell;
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
        
        if(self.editingOneScene){
            self.editingOneScene = NO;
        }
        
        if(self.projectProxies.count == 0){
            [self stopEditingScenes];
            [self updateEditButtonEnabledState];
        }
        
        self.totalNumberOfProjects = self.projectProxies.count; // nazmus added
        [self setupIndicesForMultipleTables];
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
        //NSString * oldName = [proxy.name stringByAppendingString:@".png"];
        BOOL success = [THProject renameProjectNamed:proxy.name toName:name];
        
        if(success){
/*
            NSString * imageName = [name stringByAppendingString:@".png"];
            [TFFileUtils renameDataFile:oldName to:imageName inDirectory:kProjectImagesDirectory];*/
            
            cell.nameTextField.text = name;
            proxy.name = name;
            
            //[self.collectionView reloadData];
            //[self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
    }
}

-(void) willStartEditingCellName:(THCollectionProjectCell *)cell{

    self.currentRenamingCell = cell;
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
    [self setupIndicesForMultipleTables];
    
    if(self.editingScenes){
        [self stopEditingScenes];
    }
    
    if(self.showingIcons){
        [self.collectionView reloadData];
        
        self.tableView.hidden = YES;
        self.tableViewSecond.hidden = YES;
        self.collectionView.hidden = NO;
        [self addGestureRecognizers];
        
        
        
    } else {
        [self.tableView reloadData];
        [self.tableViewSecond reloadData];
        
        self.tableView.hidden = NO;
        self.tableViewSecond.hidden = NO;
        self.collectionView.hidden = YES;
        
        [self removeGestureRecognizers];
    }
    
}

- (void) editButtonTapped:(id)sender {
    [self startEditingScenes];
}

- (void) doneButtonTapped:(id)sender {
    
    [self stopEditingScenes];
}


#pragma mark - Scrolling up when textFild

-(void)keyboardWillShow:(NSNotification*) notification {
    CGRect currentCellFrame = self.currentRenamingCell.frame;
    
    NSDictionary* userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    keyboardHeight = keyboardSize.height;
    
    if(currentCellFrame.origin.y + currentCellFrame.size.height > self.view.frame.size.height - keyboardHeight){
        
        [self moveScrollViewUp:YES];
        didMoveViewUp = YES;
    } else {
        didMoveViewUp = NO;
    }
}

-(void)keyboardWillHide:(NSNotification*) notification {
    
    if(didMoveViewUp){
        NSDictionary* userInfo = [notification userInfo];
        CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        keyboardHeight = keyboardSize.height;
        
        [self moveScrollViewUp:NO];
    }
}

-(void)moveScrollViewUp:(BOOL)movedUp {
    
    //CGPoint contentOffset = self.view.contentOffset;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = self.view.frame;
    if (movedUp) {
        rect.origin.y -= keyboardHeight;
        rect.size.height += keyboardHeight;
    } else {
        
        rect.origin.y += keyboardHeight;
        rect.size.height -= keyboardHeight;
    }
    self.view.frame = rect;
    
    //self.scrollView.contentOffset = contentOffset;
    
    [UIView commitAnimations];
}

-(IBAction)imprintButtonClicked:(UIButton*)sender {
    NSString *body = @"<html><body style='text-align:center; color:#302e2a; padding-top:40px; background-color:#f6f6f6;'><div style='font-size:14px; line-height:20px; letter-spacing:1px;'><b>IMPRINT</b></div>";
    body = [body stringByAppendingString:@"<div style='height:1px; margin:15px auto; width:30px; background-color:#302e2a;'></div>"];
    body = [body stringByAppendingString:@"<div style='font-size:13px; line-height:20px;'><b>Bernd Brügge, Gesche Joost</b><br>(Project Lead)<br><br></div>"];
    body = [body stringByAppendingString:@"<div style='font-size:13px; line-height:20px;'><b>Katharina Bredies</b><br>(Project Lead, Design)<br><br></div>"];
    body = [body stringByAppendingString:@"<div style='font-size:13px; line-height:20px;'><b>Attila Mann</b><br>(Design)<br><br></div>"];
    body = [body stringByAppendingString:@"<div style='font-size:13px; line-height:20px;'><b>Juan Haladjian</b><br>(Lead Developer)<br><br></div>"];
    body = [body stringByAppendingString:@"<div style='font-size:13px; line-height:20px;'><b>Nazmus Shaon, Michael Conrads, Timm Beckmann, Martijn ten Bhömer, Aarón Pérez Martín, Güven Cadogan, Magued Farah</b><br>(Developer)<br></div>"];
    body = [body stringByAppendingString:@"</body></html>"];
    
    [self showSimplePopoverWebview:body];
}

-(IBAction)aboutButtonClicked:(UIButton*)sender {
    NSString *body = @"<html><body style='text-align:center; color:#302e2a; padding-top:40px; background-color:#f6f6f6;'><div style='font-size:14px; line-height:20px; letter-spacing:1px;'><b>ABOUT INTERACTEX</b></div>";
    body = [body stringByAppendingString:@"<div style='height:1px; margin:15px auto; width:30px; background-color:#302e2a;'></div>"];
    body = [body stringByAppendingString:@"<div style='font-size:13px; line-height:20px;'><b><span style=' letter-spacing:1px;'>Interactex Designer</span></b><br>Version 1.0<br>www.interactex.de</div>"];
    body = [body stringByAppendingString:@"<div style='height:1px; margin:15px auto; width:30px; background-color:#302e2a;'></div>"];
    body = [body stringByAppendingString:@"<div style='font-size:13px; line-height:20px;'>You can use the Interactex Designer to visually create and test software for your eTextiles<br>without the need to write any code.<br><br>It supports every hardware components of the Arduino Lilypad family such as LEDs, buttons,<br>accelerometers, light sensors etc. and every iOS user interface elements such as buttons,<br>labels, switches etc.</div>"];
    body = [body stringByAppendingString:@"<div style='height:1px; margin:15px auto; width:30px; background-color:#302e2a;'></div>"];
    body = [body stringByAppendingString:@"<div style='font-size:13px; line-height:18px;'>This is an open source software:<br><a style='color:#007aff; text-decoration:none;' href='https://github.com/avenix/Interactex'>https://github.com/avenix/Interactex</a></div>"];
    body = [body stringByAppendingString:@"</body></html>"];
    
    [self showSimplePopoverWebview:body];
}

-(void)showSimplePopoverWebview: (NSString*) body {
    UIViewController *popoverView =[[UIViewController alloc] init];
    popoverView.preferredContentSize=CGSizeMake(732, 480);
    
    [popoverView.view.layer setBackgroundColor:[[UIColor clearColor] CGColor]];
    
    UIWebView *webContent = [[UIWebView alloc] initWithFrame:CGRectMake(20, 20, popoverView.preferredContentSize.width - 40, popoverView.preferredContentSize.height - 40)];
    
    NSString *htmlString = [NSString stringWithFormat:@"<font face='HelveticaNeue' size='3'>%@", body];
    [webContent loadHTMLString:htmlString baseURL:nil];
    
    [popoverView.view addSubview:webContent];
    
    UIPopoverController *popController = [[UIPopoverController alloc] initWithContentViewController:popoverView];
    [popController setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.15f]];
    
    [popController presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2-popoverView.preferredContentSize.width/2, self.view.frame.size.height/2-popoverView.preferredContentSize.height/2, popoverView.preferredContentSize.width, popoverView.preferredContentSize.height) inView:self.view permittedArrowDirections:0 animated:YES];
    
    
}

@end
