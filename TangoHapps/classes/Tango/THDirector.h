//
//  THDirector.h
//  TangoHapps
//
//  Created by Juan Haladjian on 1/11/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "THProjectSelectionViewController.h"
#import "THPaletteViewController.h"
#import "THTabbarView.h"
#import "THServerController.h"

@class THProjectViewController;
@class THProjectProxy;
@class THClientGridView;
@class THEditorToolsDataSource;
@class TFLayer;
@class THProject;

@protocol THEditorToolsDataSource <NSObject>
-(NSInteger) numberOfToolbarButtonsForState:(TFAppState) state;
-(UIBarButtonItem*) toolbarButtonAtIdx:(NSInteger) idx forState:(TFAppState) state;
@end

/*
typedef enum {
    kDirectorStateProjectSelection,
    kDirectorStateProjectEdition
} TFDirectorState;*/

@interface THDirector : NSObject <THServerControllerDelegate>
{
    BOOL _alreadyStartedEditor;
}

@property (nonatomic, weak) THProjectViewController * projectController;
@property (nonatomic, readonly) TFLayer * currentLayer;
@property (nonatomic, strong) THProject * currentProject;
@property (nonatomic, weak) THProjectProxy * currentProxy;
@property (nonatomic, strong) NSMutableArray * projectProxies;
@property (nonatomic, strong) THServerController * serverController;

+(THDirector*)sharedDirector;

-(NSMutableArray*) loadProjectProxies;
-(void) saveProjectProxies;

@end
