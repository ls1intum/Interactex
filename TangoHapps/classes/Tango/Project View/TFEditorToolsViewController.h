//
//  TFEditorToolsViewController.h
//  Tango
//
//  Created by Juan Haladjian on 11/26/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFEditorToolsViewController : UIViewController {
    
    NSArray * _editingTools;
    NSArray * _lilypadTools;
    NSArray * _simulatingTools;
    NSMutableArray * _barButtonItems;
    
    UIColor * _iPhoneTintColor;
}

@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem * connectButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem * duplicateButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem * removeButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem * lilypadItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hideiPhoneItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem * tshirtItem;

@property (weak, nonatomic) IBOutlet UIBarButtonItem * pinsModeItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem * pushItem;
@property (strong, nonatomic) UIColor * iPhoneItemTintColor;

@property (nonatomic) BOOL hidden;


-(void) addEditionButtons;
-(void) addLilypadButtons;
-(void) addSimulationButtons;

-(void) unselectAllButtons;
-(void) updateHideIphoneButtonTint;

- (IBAction) connectTapped:(id)sender;
- (IBAction) duplicateTapped:(id)sender;
- (IBAction) removeTapped:(id)sender;
- (IBAction)lilypadPressed:(id)sender;
- (IBAction)tshirtPressed:(id)sender;
- (IBAction)hideiPhonePressed:(id)sender;
- (IBAction)pinsModePressed:(id)sender;
- (IBAction)pushPressed:(id)sender;

@end
