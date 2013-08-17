//
//  THClientSceneSelectionViewController.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/25/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THClientGridView.h"

@class THClientPresetsGenerator;

@interface THClientSceneSelectionViewController : UIViewController <THClientGridViewDataSource, THClientGridViewDelegate> {
    
}

@property (nonatomic, strong) NSMutableArray * presets;
@property (nonatomic, strong) NSMutableArray * scenes;
@property (weak, nonatomic) IBOutlet THClientGridView * gridView;
@property (weak, nonatomic) IBOutlet THClientGridView * presetsGridView;
@property (weak, nonatomic) IBOutlet UISegmentedControl * filterControl;
@property (nonatomic) BOOL showingCustomApps;

- (IBAction)filterControlChanged:(id)sender;
- (IBAction)editTapped:(id)sender;

@end
