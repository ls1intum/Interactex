/*
THClientSceneSelectionViewController.h
Interactex Client

Created by Juan Haladjian on 12/11/2013.

iGMP is an App to control an Arduino board over Bluetooth 4.0. iGMP uses the GMP protocol (based on Firmata): www.firmata.org

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany, 
	
Contacts:
juan.haladjian@cs.tum.edu
k.zhang@utwente.nl
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
It has been created with funding from EIT ICT, as part of the activity "Connected Textiles".


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import <UIKit/UIKit.h>
#import "THClientCollectionProjectCell.h"
#import "THClientTableProjectCell.h"
#import <THClientDownloadViewController.h>

@class THClientProjectProxy;
@class THClientProjectDraggableCell;

@interface THClientSceneSelectionViewController : UIViewController < UIGestureRecognizerDelegate, THClientProjectCellDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, THClientTableProjectCellDelegate, THClientDownloadViewControllerDelegate>
{
    UILabel * titleLabel;
    
    UITapGestureRecognizer * tapRecognizer;
    UIPanGestureRecognizer * panRecognizer;
    UILongPressGestureRecognizer * longpressRecognizer;
    
    THClientProjectProxy * currentProject;
    THClientCollectionProjectCell * currentProjectCell;
    THClientProjectDraggableCell * currentDraggableCell;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *projectTypeControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *viewControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) NSMutableArray * projectProxies;
@property (strong, nonatomic) NSMutableArray * presetProxies;
@property (nonatomic, readonly) NSMutableArray * currentProxiesArray;

@property (nonatomic) BOOL editingScenes;
@property (nonatomic) BOOL editingOneScene;

@property (nonatomic) BOOL showingIcons;
@property (nonatomic) BOOL showingCustomApps;

@property (strong, nonatomic) UIBarButtonItem * editButton;
@property (strong, nonatomic) UIBarButtonItem * doneButton;

-(IBAction)addButtonTapped:(id)sender;
-(IBAction)viewControlChanged:(id)sender;
-(IBAction)projectTypeControlChanged:(id)sender;


@end
