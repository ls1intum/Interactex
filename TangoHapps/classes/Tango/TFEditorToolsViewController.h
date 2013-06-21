//
//  TFEditorToolsViewController.h
//  Tango
//
//  Created by Juan Haladjian on 11/26/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFEditorToolsViewController : UIViewController

- (IBAction)connectTapped:(id)sender;
- (IBAction)duplicateTapped:(id)sender;
- (IBAction)removeTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *connectButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *duplicateButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *removeButton;

@property (nonatomic) BOOL hidden;

@end
