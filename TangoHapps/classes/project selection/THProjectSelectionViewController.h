//
//  TFProjectSelectionViewController.h
//  TangoFramework
//
//  Created by Juan Haladjian on 10/17/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THProjectCell.h"

@class THProjectProxy;
@class THProjectDraggableCell;

@interface THProjectSelectionViewController : UIViewController < UIGestureRecognizerDelegate, THProjectCellDelegate>
{
    UILabel * titleLabel;
    
    UITapGestureRecognizer * tapRecognizer;
    UIPanGestureRecognizer * panRecognizer;
    UILongPressGestureRecognizer * longpressRecognizer;
    
    THProjectProxy * currentProject;
    THProjectCell * currentProjectCell;
    THProjectDraggableCell * currentDraggableCell;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *filterControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *orderControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) BOOL editingScenes;
@property (nonatomic) BOOL editingOneScene;
@property (strong, nonatomic) UIBarButtonItem * editButton;
@property (strong, nonatomic) UIBarButtonItem * doneButton;
@property (weak, nonatomic) NSMutableArray * projectProxies;

-(void) reloadData;
-(IBAction) addButtonTapped:(id)sender;
-(IBAction) filterControlChanged:(id)sender;
-(IBAction) orderControlChanged:(id)sender;
-(IBAction) editButtonTapped:(id)sender;


@end
