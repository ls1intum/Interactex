//
//  TFProjectSelectionViewController.h
//  TangoFramework
//
//  Created by Juan Haladjian on 10/17/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THProjectCell.h"
#import "THTableProjectCell.h"

@class THProjectProxy;
@class THProjectDraggableCell;

@interface THProjectSelectionViewController : UIViewController < UIGestureRecognizerDelegate, THProjectCellDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate, THTableProjectCellDelegate>
{
    UILabel * titleLabel;
    
    UITapGestureRecognizer * tapRecognizer;
    UIPanGestureRecognizer * panRecognizer;
    UILongPressGestureRecognizer * longpressRecognizer;
    
    THProjectProxy * currentProject;
    THProjectCell * currentProjectCell;
    THProjectDraggableCell * currentDraggableCell;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *viewControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *orderControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL editingScenes;
@property (nonatomic) BOOL editingOneScene;
@property (nonatomic) BOOL showingIcons;
@property (strong, nonatomic) UIBarButtonItem * editButton;
@property (strong, nonatomic) UIBarButtonItem * doneButton;
@property (weak, nonatomic) NSMutableArray * projectProxies;

-(IBAction) addButtonTapped:(id)sender;
-(IBAction)viewControlChanged:(id)sender;

-(IBAction) orderControlChanged:(id)sender;



@end
