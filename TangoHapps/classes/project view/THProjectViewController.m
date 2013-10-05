
#import "THProjectViewController.h"
#import "THProjectViewController.h"
#import "THEditorToolsViewController.h"
#import "THEditorToolsDataSource.h"
#import "THTabbarViewController.h"
#import "THSimulator.h"
#import "THEditor.h"
#import "THiPhoneEditableObject.h"
#import "THProjectProxy.h"

@implementation THProjectViewController

float const kPalettePullY = 364;
float const kToolsTabMargin = 5;

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CCDirector * ccDirector = [CCDirector sharedDirector];
    
    ccDirector.delegate = self;
    
    [self addChildViewController:ccDirector];
    [self.view addSubview:ccDirector.view];
    [self.view sendSubviewToBack:ccDirector.view];
    [ccDirector didMoveToParentViewController:self];
    
    [THDirector sharedDirector].projectController = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    _tabController = [[THTabbarViewController alloc] initWithNibName:@"THTabbar" bundle:nil];
    
    _toolsController = [[THEditorToolsViewController alloc] initWithNibName:@"THEditorTools" bundle:nil];
    
    
    _playButton = [[UIBarButtonItem alloc]
                   initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                   target:self
                   action:@selector(startSimulation)];
    
    _stopButton = [[UIBarButtonItem alloc]
                   initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                   target:self
                   action:@selector(endSimulation)];
    
    
    [self.view addSubview:_tabController.view];
    
    [self addTools];
    [self addPlayButton];
    [self addTapRecognizer];
    
    // Observe some notifications so we can properly instruct the director.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillTerminate:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationSignificantTimeChange:)
                                                 name:UIApplicationSignificantTimeChangeNotification
                                               object:nil];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardHidden) name:UIKeyboardWillHideNotification object:nil];
    
    _state = kAppStateEditor;
    
    [self showTabBar];
    [self showTools];
    
    [self addTitleLabel];
    [self reloadContent];
    [self startWithEditor];
    
    [self addPalettePull];
    [self updatePalettePullVisibility];
    
    
    _currentProjectName = [THDirector sharedDirector].currentProject.name;
}

-(void) viewWillDisappear:(BOOL)animated{
    
    [self saveCurrentProjectAndPalette];
    
    [[THDirector sharedDirector].serverController stopServer];
    
    [self.toolsController unselectAllButtons];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:nil];
    
    
    [self.currentLayer prepareToDie];
    [[THDirector sharedDirector].currentProject prepareToDie];
    
    [_currentLayer removeFromParentAndCleanup:YES];
    
    _currentLayer = nil;
    _currentScene = nil;
    
    [THDirector sharedDirector].currentProject = nil;
    [THDirector sharedDirector].currentProxy = nil;   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[CCDirector sharedDirector] setDelegate:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [[CCDirector sharedDirector] purgeCachedData];
}


#pragma mark - Saving and restoring projects

-(void) saveCurrentProjectAndPalette{
    
    THDirector * director = [THDirector sharedDirector];
    if(!director.currentProject.isEmpty){
        [self saveCurrentProject];
    }
    [self.tabController.paletteController save];
}
/*
-(void) storeImageForCurrentProject:(UIImage*) image{
    NSString * imageFileName = [[THDirector sharedDirector].currentProject.name stringByAppendingString:@".png"];
    NSString * imageFilePath = [TFFileUtils dataFile:imageFileName
                                         inDirectory:kProjectImagesDirectory];
    [TFFileUtils saveImageToFile:image file:imageFilePath];
}*/

-(void) saveCurrentProject{
    THDirector * director = [THDirector sharedDirector];
    THProject * currentProject = director.currentProject;
    
    //_projectName = [THDirector sharedDirector].currentProject.name;
    
    UIImage * image = [TFHelper screenshot];
    
    if(![THProject doesProjectExistWithName:currentProject.name]){ // if it is a new project
        
        THProjectProxy * proxy = [THProjectProxy proxyWithName:director.currentProject.name];
        proxy.image = image;
        if(![director.projectProxies containsObject:proxy]){
            [director.projectProxies addObject:proxy];
            [director saveProjectProxies];
        }
    } else { //if it already existed, its name may have changed
        director.currentProxy.name = director.currentProject.name;
        director.currentProxy.image = image;
    }
    
    [director.currentProject save];
    
    //[self storeImageForCurrentProject:image];
}

-(void) restoreCurrentProject{
    
    THDirector * director = [THDirector sharedDirector];
    
    [director.currentProject prepareToDie];
    if(_currentProjectName != nil){
        director.currentProject = [THProject projectSavedWithName:_currentProjectName];
    }
}

#pragma mark - Notification handlers

- (void)applicationWillResignActive:(NSNotification *)notification
{
    [[CCDirector sharedDirector] pause];
}


- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [[CCDirector sharedDirector] resume];
}


- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    [[CCDirector sharedDirector] stopAnimation];
}


- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    [[CCDirector sharedDirector] startAnimation];
}


- (void)applicationWillTerminate:(NSNotification *)notification
{
    [[CCDirector sharedDirector] end];
}


- (void)applicationSignificantTimeChange:(NSNotification *)notification
{
    [[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

#pragma mark - Title

-(void) addTapRecognizer{

    UITapGestureRecognizer *tapRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
	[tapRecognizer setNumberOfTapsRequired:1];
    tapRecognizer.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:tapRecognizer];
}

-(void) tapped{
    if(self.editingSceneName){
        [_titleTextField resignFirstResponder];
    }
}

-(NSString*) title{
    THProject * project = [THDirector sharedDirector].currentProject;
    return project.name;
}

-(void) removeTitleLabel{
    self.navigationItem.titleView = nil;
}

-(void) addTitleLabel{
    THProject * project = [THDirector sharedDirector].currentProject;
    if(!_titleLabel){
        _titleLabel = [TFHelper navBarTitleLabelNamed:project.name];
        _titleLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startEditingSceneName)];
        [_titleLabel addGestureRecognizer:tapRecognizer];
        
    } else {
        _titleLabel.text = project.name;
    }
    self.navigationItem.titleView = _titleLabel;
}

-(void) addTitleTextField{
    if(!_titleTextField){
        _titleTextField =  [[UITextField alloc] init];
        _titleTextField.frame = _titleLabel.frame;
        _titleTextField.font = _titleLabel.font;
        _titleTextField.textAlignment = _titleLabel.textAlignment;
        _titleTextField.textColor = _titleLabel.textColor;
        _titleTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _titleTextField.layer.borderWidth = 1.0f;
        _titleTextField.layer.borderColor = [UIColor grayColor].CGColor;
        _titleTextField.delegate = self;
    }
    
    THProject * project = [THDirector sharedDirector].currentProject;
    _titleTextField.text = project.name;
    self.navigationItem.titleView = _titleTextField;
    [_titleTextField becomeFirstResponder];
}

-(BOOL) keyboardHidden{
    if(self.editingSceneName){
        [self stopEditingSceneName];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_titleTextField resignFirstResponder];
    return NO;
}


-(BOOL) canRenameProjectFile:(NSString*) name toName:(NSString*) newName{
    
    BOOL renamed = [TFFileUtils renameDataFile:name to:newName inDirectory:kProjectsDirectory];
    if(!renamed){
        return NO;
    }
    
    NSString * imageName = [name stringByAppendingString:@".png"];
    NSString * newImageName = [newName stringByAppendingString:@".png"];
    [TFFileUtils renameDataFile:imageName to:newImageName inDirectory:kProjectImagesDirectory];
    
    return YES;
}

-(void) renameCurrentProjectToName:(NSString*) newName{
    if([self canRenameProjectFile:_currentProjectName toName:newName]){
        [THDirector sharedDirector].currentProject.name = newName;
        [THDirector sharedDirector].currentProxy.name = newName;
        _currentProjectName = newName;
    }
}

-(void) stopEditingSceneName{
    [self renameCurrentProjectToName:_titleTextField.text];
    
    [self addTitleLabel];
    _editingSceneName = NO;
}

-(void) startEditingSceneName{
    [self addTitleTextField];
    _editingSceneName = YES;
}

#pragma mark - PalettePull

-(void) addPalettePullGestureRecognizer{
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moved:)];
    self.panRecognizer.delegate = self;
    self.panRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.panRecognizer];
}

-(void) removePalettePullRecognizer{
    [self.view removeGestureRecognizer:self.panRecognizer];
    self.panRecognizer = nil;
}

-(void) updatePalettePullVisibility{
    self.palettePullImageView.hidden = self.state;
}

-(void) addPalettePull{
    UIImage * image = [UIImage imageNamed:@"palettePull"];
    self.palettePullImageView = [[UIImageView alloc] initWithImage:image];
    
    CGRect paletteFrame = self.tabController.view.frame;
    self.palettePullImageView.frame = CGRectMake(paletteFrame.origin.x + paletteFrame.size.width, kPalettePullY, image.size.width, image.size.height);
    
    [self.view addSubview:self.palettePullImageView];
    
    [self addPalettePullGestureRecognizer];
}

-(void) moved:(UIPanGestureRecognizer*) sender{
    if(sender.state == UIGestureRecognizerStateBegan){
        
        CGPoint location = [sender locationInView:self.view];
        if(CGRectContainsPoint(self.palettePullImageView.frame,location)){
            self.movingTabBar = YES;
            
            THEditor * editor = (THEditor*) self.currentLayer;
            editor.shouldRecognizePanGestures = NO;
            
        } else {
            self.movingTabBar = NO;
        }
        
    } else if(sender.state == UIGestureRecognizerStateChanged){
        if(self.movingTabBar){
            
            CGPoint translation = [sender translationInView:self.view];
            
            //set palette frame
            CGRect paletteFrame = self.tabController.view.frame;
            paletteFrame.origin.x = paletteFrame.origin.x + translation.x;
            if(paletteFrame.origin.x > 0){
                paletteFrame.origin.x = 0;
            }
            self.tabController.view.frame = paletteFrame;
            
            //set 
            CGRect imageViewFrame = self.palettePullImageView.frame;
            imageViewFrame.origin.x = paletteFrame.origin.x + paletteFrame.size.width;
            if(imageViewFrame.origin.x < 0){
                imageViewFrame.origin.x = 0;
            }
            self.palettePullImageView.frame = imageViewFrame;
            
            [sender setTranslation:CGPointMake(0, 0) inView:self.view];
        }
    } else {
        self.movingTabBar = NO;
        
        THEditor * editor = (THEditor*) self.currentLayer;
        editor.shouldRecognizePanGestures = YES;
    }
}

#pragma mark - Methods

-(void)hideTabBar
{
    _tabController.hidden = YES;
}

-(void)showTabBar
{
    _tabController.hidden = NO;
}

-(void)hideTools
{
    _toolsController.hidden = YES;
}

-(void)showTools
{
    _toolsController.hidden = NO;
}

#pragma mark - Simulation

-(void) startWithEditor{
    
    THEditor * editor = [THEditor node];
    editor.dragDelegate = self.tabController.paletteController;
    _currentLayer = editor;
    [_currentLayer willAppear];
    CCScene * scene = [CCScene node];

    [scene addChild:_currentLayer];
    
    if([CCDirector sharedDirector].runningScene){
        [[CCDirector sharedDirector] replaceScene:scene];
    } else {
        [[CCDirector sharedDirector] runWithScene:scene];
    }
    
    _tabController.paletteController.delegate = editor;
    _state = kAppStateEditor;
}

-(void) switchToLayer:(TFLayer*) layer{
    [_currentLayer willDisappear];
    _currentLayer = layer;
    [_currentLayer willAppear];
    
    CCScene * scene = [CCScene node];
    [scene addChild:_currentLayer];
    
    [[CCDirector sharedDirector] replaceScene:scene];
}

-(void) startSimulation {
    if(_state == kAppStateEditor){

        _state = kAppStateSimulator;
        
        [self saveCurrentProject];
        
        THEditor * editor = (THEditor*) [THDirector sharedDirector].currentLayer;
        THSimulator * simulator = [THSimulator node];
        
        //wasEditorInLilypadMode = editor.isLilypadMode;
        
        [self switchToLayer:simulator];
        simulator.zoomLevel = editor.zoomLevel;
        
        [self hideTabBar];
        
        [self.toolsController addSimulationButtons];
        [self addStopButton];
        [self.toolsController unselectAllButtons];
        
        THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
        project.iPhone.visible = YES;
        [self.toolsController updateHideIphoneButtonTint];
        [self updatePalettePullVisibility];
        [self addPalettePullGestureRecognizer];
    }
}

-(void) endSimulation {
    if(_state == kAppStateSimulator){
        
        _state = kAppStateEditor;
        
        [self restoreCurrentProject];
        
        THSimulator * simulator = (THSimulator*) [THDirector sharedDirector].currentLayer;
        THEditor * editor = [THEditor node];
        
        editor.dragDelegate = self.tabController.paletteController;
        [self switchToLayer:editor];
        editor.zoomLevel = simulator.zoomLevel;

        /*
        if(wasEditorInLilypadMode){
            THPaletteDataSource * dataSource = (THPaletteDataSource*) self.tabController.paletteController.dataSource;
            dataSource
            [dataSource reloadPalettes];
            [self.tabController.paletteController reloadPalettes];
        }*/
        
        _tabController.paletteController.delegate = editor;
        
        [self showTabBar];
        [self.toolsController addEditionButtons];
        [self addPlayButton];
        [self updatePalettePullVisibility];
        [self removePalettePullRecognizer];
    }
}

- (void)toggleAppState {
    if(_state == kAppStateEditor){
        [self startSimulation];
    } else{
        [self endSimulation];
    }
}

#pragma mark - View Lifecycle

-(void) reloadContent{
    [self.tabController.paletteController reloadPalettes];
    //[self.toolsController reloadBarButtonItems];
}

-(void) addBarButtonWithImageName:(NSString*) imageName{
    
    //UIImage * image = [UIImage imageNamed:@"play.png"];
}

-(void) addTools{
    
    CGRect frame = _toolsController.view.frame;
    CGRect tabBarFrame = self.tabController.view.frame;
    frame.origin = CGPointMake(tabBarFrame.origin.x + tabBarFrame.size.width + kToolsTabMargin, kToolsTabMargin);
    _toolsController.view.frame = frame;
    //_toolsController.view.center = ccp(1024/2.0f, frame.size.height / 2.0f);
    [self.view addSubview:_toolsController.view];
}

-(void) addPlayButton {
    
    NSArray * array = [NSArray arrayWithObject:_playButton];
    self.navigationItem.rightBarButtonItems = array;
}

-(void) addStopButton {
    
    NSArray * array = [NSArray arrayWithObject:_stopButton];
    self.navigationItem.rightBarButtonItems = array;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

-(NSString*) description{
    return @"ProjectController";
}

-(void) dealloc{
    if ([@"YES" isEqualToString: [[[NSProcessInfo processInfo] environment] objectForKey:@"printUIDeallocs"]]) {
        NSLog(@"deallocing %@",self);
    }
}

@end
