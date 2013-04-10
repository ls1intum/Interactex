//
//  THDirector.m
//  TangoHapps
//
//  Created by Juan Haladjian on 1/11/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THDirector.h"
#import "THProjectProxy.h"
#import "THProjectViewController.h"
#import "THEditorToolsDataSource.h"

@implementation THDirector
@dynamic gridDelegate;
@dynamic currentProject;
@dynamic currentLayer;

#pragma mark - Singleton

static THDirector * _sharedInstance = nil;

+(THDirector*)sharedDirector {
    @synchronized([THDirector class]){
        if (!_sharedInstance)
            _sharedInstance = [[THDirector alloc] init];
        
        return _sharedInstance;
    }
    
    return nil;
}

+(id)alloc {
    @synchronized([THDirector class]) {
        NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedInstance = [super alloc];
        return _sharedInstance;
    }
    
    return nil;
}

-(void) preload{
    [[SimpleAudioEngine sharedEngine] preloadEffect:kConnectionMadeEffect];
}

-(id) init{
    self = [super init];
    if(self){
        
        _projectController = [[THProjectViewController alloc] init];
        _navigationController = [[UINavigationController alloc] init];
        _navigationController.delegate = self;
        _selectionController = [[THProjectSelectionViewController alloc] init];
    }
    return self;
}

#pragma mark - Methods

-(TFDirectorState) state{
    return self.navigationController.visibleViewController == self.projectController;
}

-(void) savePalette{
    [self.projectController.tabController.paletteController save];
}

-(void) save{
    if(self.state == kDirectorStateProjectEdition){
        [self saveCurrentProject];
    }
    [self savePalette];
}

-(void) loadProjects {
    
    NSString * directory = [TFFileUtils dataDirectory:kProjectsDirectory];
    NSArray * files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:nil];
    _projectProxies = [[NSMutableArray alloc] init];
    for(NSString *archivePath in files){
        THProjectProxy * proxy = [THProjectProxy proxyWithName:[archivePath lastPathComponent]];
        [_projectProxies addObject:proxy];
    }
}

-(void) stop{
    self.currentProject = nil;
    _currentProxy = nil;
    _projectController = nil;
    _projectDelegate = nil;
    self.paletteDataSource = nil;
    self.editorToolsDataSource = nil;
    [self.navigationController removeFromParentViewController];
}

-(void) start{
        
    TFTabbarViewController * tabController = self.projectController.tabController;
    [tabController.paletteController reloadPalettes];
    [tabController.paletteController addCustomPaletteItems];
    
    [self loadProjects];
    
    [_navigationController pushViewController:_selectionController animated:NO];
}

-(void) startProject:(TFProject*) project{
    
    self.currentProject = project;
    
    [_navigationController pushViewController:self.projectController animated:YES];
}

-(void) checkSaveCurrentProject{
    if(!self.currentProject.isEmpty){
        [self saveCurrentProject];
    }
}

-(void) storeImageForCurrentProject:(UIImage*) image{
    NSString * imageFileName = [self.currentProject.name stringByAppendingString:@".png"];
    NSString * imageFilePath = [TFFileUtils dataFile:imageFileName
                                         inDirectory:kProjectImagesDirectory];
    [TFFileUtils saveImageToFile:image file:imageFilePath];
}

-(void) saveCurrentProject{
    
    _projectName = self.currentProject.name;
    [self.currentProject save];
    
    UIImage * image = [TFHelper screenshot];
    [self storeImageForCurrentProject:image];
    
    _currentProxy.name = self.currentProject.name;
    _currentProxy.image = image;
    if(![_projectProxies containsObject:_currentProxy]){
        [_projectProxies addObject:_currentProxy];
    }
}

-(void) restoreCurrentProject{
    if(_projectName != nil){
        [self.currentProject prepareToDie];
        self.currentProject = [TFProject restoreProjectNamed:_projectName];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if(viewController == self.selectionController){
        if(_alreadyStartedEditor){
            [self checkSaveCurrentProject];
            [self.currentProject prepareToDie];
            self.currentProject = nil;
            [self.projectController.tabController.propertiesController removeAllControllers];
        }
        [self.projectDelegate willStopEditingProject:self.currentProject];
        [self.selectionController reloadData];
        
        [self.editorToolsDataSource.serverController stopServer];
        
    } else {
        _alreadyStartedEditor = YES;
        [self.projectDelegate willStartEditingProject:self.currentProject];
        [self.editorToolsDataSource.serverController startServer];
    }
}

-(BOOL) renameProjectFile:(NSString*) name toName:(NSString*) newName{
    
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
    if([self renameProjectFile:self.currentProject.name toName:newName]){
        _currentProxy.name = newName;
        self.currentProject.name = newName;
    }
}

#pragma mark - Loading Projects

-(void) startNewProject{
    
    [self.projectController load];
    
    TFProject * newProject = [self.projectDelegate newCustomProject];
    newProject.name = [TFFileUtils resolveProjectNameConflictFor:newProject.name];
    
    THProjectProxy * proxy = [THProjectProxy proxyWithName:newProject.name];
    _currentProxy = proxy;
    
    [self startProject:newProject];
}

-(void) startProjectForProxy:(THProjectProxy*) proxy{
    
    [self.projectController load];
    
    _currentProxy = proxy;
    TFProject * project = [TFProject restoreProjectNamed:proxy.name];
    project.name = proxy.name;
    [self startProject:project];
}

#pragma mark - Palette Data Source

-(void) setPaletteDataSource:(id<TFPaleteViewControllerDataSource>)paletteDataSource{
    
    TFTabbarViewController * tabController = self.projectController.tabController;
    tabController.paletteController.dataSource = paletteDataSource;
}

-(id<TFPaleteViewControllerDataSource>) paletteDataSource {
    
    TFTabbarViewController * tabController = self.projectController.tabController;
    return tabController.paletteController.dataSource;
}

#pragma mark - GridView Delegate

-(void) setGridDelegate:(id<THGridViewDelegate>)gridDelegate{
    
    THGridView * gridView = (THGridView*) self.selectionController.view;
    gridView.gridDelegate = gridDelegate;
}

-(id<THGridViewDelegate>) gridDelegate {
    
    THGridView * gridView = (THGridView*) self.selectionController.view;
    return gridView.gridDelegate;
}

#pragma mark - Project

-(TFProject*) currentProject{
    return [TFDirector sharedDirector].currentProject;
}

-(void) setCurrentProject:(TFProject*) project{
    [TFDirector sharedDirector].currentProject = project;
}

#pragma mark - Layer

-(TFLayer*) currentLayer{
    return self.projectController.currentLayer;
}
/*
-(void) setCurrentLayer:(TFLayer*) layer{
    [TFDirector sharedDirector].currentLayer = layer;
    
}*/


@end
