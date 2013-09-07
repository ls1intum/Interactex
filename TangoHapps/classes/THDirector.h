//
//  THDirector.h
//  TangoHapps
//
//  Created by Juan Haladjian on 1/11/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "THProjectSelectionViewController.h"
#import "TFPaletteViewController.h"
#import "TFProjectDelegate.h"
#import "TFTabbarView.h"

@class THProjectViewController;
@class THProjectProxy;
@class THClientGridView;
@class THEditorToolsDataSource;
@class TFLayer;

@protocol TFEditorToolsDataSource <NSObject>
-(NSInteger) numberOfToolbarButtonsForState:(TFAppState) state;
-(UIBarButtonItem*) toolbarButtonAtIdx:(NSInteger) idx forState:(TFAppState) state;
@end

typedef enum {
    kDirectorStateProjectSelection,
    kDirectorStateProjectEdition
} TFDirectorState;

@interface THDirector : NSObject <UINavigationControllerDelegate>
{
    NSString * _projectName;
    BOOL _alreadyStartedEditor;
}

@property (nonatomic, readonly) UINavigationController * navigationController;
@property (nonatomic, readonly) THProjectSelectionViewController * selectionController;
@property (nonatomic, readonly) THProjectViewController * projectController;
@property (nonatomic, readonly) TFLayer * currentLayer;
@property (nonatomic, strong) TFProject * currentProject;
@property (nonatomic, readonly) THProjectProxy * currentProxy;
@property (nonatomic, strong) NSMutableArray * projectProxies;
@property (nonatomic, strong) id<TFTabbarViewDataSource> paletteDataSource;
@property (nonatomic, strong) id<TFProjectControllerDelegate> projectDelegate;
@property (nonatomic, strong) THEditorToolsDataSource * editorToolsDataSource;
@property (nonatomic) TFDirectorState state;

+(THDirector*)sharedDirector;

-(void) start;
-(void) stop;

-(void) save;
-(void) saveCurrentProject;
-(void) restoreCurrentProject;

-(void) renameCurrentProjectToName:(NSString*) newName;
-(BOOL) renameProjectFile:(NSString*) name toName:(NSString*) newName;

//loading projects
-(void) startNewProject;
-(void) startProjectForProxy:(THProjectProxy*) proxy;

@end
