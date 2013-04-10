//
//  TFProjectSelectionViewController.m
//  TangoFramework
//
//  Created by Juan Haladjian on 10/17/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THProjectSelectionViewController.h"
#import "THProjectProxy.h"

@implementation THProjectSelectionViewController

-(void) load{
    
    THGridView * grid = [[THGridView alloc] init];
    grid.dataSource = self;
    self.view = grid;
    [self viewDidLoad];
    
}

-(id)init {
    self = [super init];
    if(self){
        [self load];
        [self addTitleLabel];
    }
    return self;
}

-(void) addTitleLabel{
    _titleLabel = [TFHelper navBarTitleLabelNamed:@"Projects"];
    self.navigationItem.titleView = _titleLabel;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        [self load];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*) title{
    return @"Projects";
}

#pragma mark - Methods

-(void) reloadData{
    
    [(THGridView*) self.view reloadData];
}

#pragma mark - GridViewDataSource

-(NSUInteger)numberOfItemsInGridView:(THClientGridView *)gridView
{
    return [THDirector sharedDirector].projectProxies.count + 1;
}

-(THGridItem *)gridView:(THClientGridView *)gridView
            viewAtIndex:(NSUInteger)index {
    THGridItem * item = nil;
    if(index < [THDirector sharedDirector].projectProxies.count){
        
        THProjectProxy * proxy = [[THDirector sharedDirector].projectProxies objectAtIndex:index];
        item = [[THGridItem alloc] initWithName:proxy.name image:proxy.image];
        item.editable = YES;
        
    } else if(index == [THDirector sharedDirector].projectProxies.count){
        /*
        NSBundle * tangoBundle = [NSBundle frameworkBundle];
        NSString * imagePath = [tangoBundle pathForResource:@"newProjectIcon" ofType:@"png"];*/
        
        UIImage * image = [UIImage imageNamed:@"newProjectIcon"];

        item = [[THGridItem alloc]  initWithName:@"New Project" image:image];
        item.userInteractionEnabled = YES;
    }
    return item;
}

- (void)gridView:(THClientGridView*)gridView didSelectViewAtIndex:(NSUInteger)index {
    
    if(index == [THDirector sharedDirector].projectProxies.count){
        [[THDirector sharedDirector] startNewProject];
    } else {
        THProjectProxy * proxy = [[THDirector sharedDirector].projectProxies objectAtIndex:index];
        [[THDirector sharedDirector] startProjectForProxy:proxy];
    }
}

- (void)gridView:(THClientGridView *)gridView didDeleteViewAtIndex:(NSUInteger)index {
    THProjectProxy * proxy = [[THDirector sharedDirector].projectProxies objectAtIndex:index];
    [[THDirector sharedDirector].projectProxies removeObjectAtIndex:index];
    
    [TFFileUtils deleteDataFile:proxy.name fromDirectory:kProjectsDirectory];
    
    NSString * imageName = [proxy.name stringByAppendingString:@".png"];
    [TFFileUtils deleteDataFile:imageName fromDirectory:kProjectImagesDirectory];
}

- (void)gridView:(THClientGridView *)gridView didRenameViewAtIndex:(NSUInteger)index
         newName:(NSString *)newName {
    
    THProjectProxy * proxy = [[THDirector sharedDirector].projectProxies objectAtIndex:index];
    
    [[THDirector sharedDirector] renameProjectFile:proxy.name toName:newName];
    
    if(![proxy.name isEqualToString:newName]){        
        //NSLog(@"gets name: %@",newName);
        proxy.name = newName;
    }
}


@end
