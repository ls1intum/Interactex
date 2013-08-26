//
//  THClientSceneSelectionViewController.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/25/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THClientSceneCell.h"

@class THClientPresetsGenerator;
@class THClientSceneCell;
@class THClientSceneDraggableCell;

@interface THClientSceneSelectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, THClientSceneCellDelegate> {
    
    THClientScene * currentScene;
    THClientSceneCell * currentSceneCell;
    THClientSceneDraggableCell * currentDraggableCell;
    
    UITapGestureRecognizer * tapRecognizer;
    UIPanGestureRecognizer * panRecognizer;
    UILongPressGestureRecognizer * longpressRecognizer;
}

@property (nonatomic) BOOL editingScenes;
@property (nonatomic) BOOL showingCustomApps;

@property (nonatomic, strong) NSMutableArray * presets;
@property (nonatomic, weak) NSMutableArray * scenes;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UICollectionView * scenesCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView * presetsCollectionView;

@property (weak, nonatomic) IBOutlet UISegmentedControl * filterControl;

@property (nonatomic, readonly) UICollectionView * currentCollectionView;
@property (nonatomic, readonly) NSMutableArray * currentScenesArray;

@property (nonatomic, strong) THClientPresetsGenerator * fakeScenesSource;

- (IBAction) filterControlChanged:(id)sender;
- (IBAction) editTapped:(id)sender;

@end
