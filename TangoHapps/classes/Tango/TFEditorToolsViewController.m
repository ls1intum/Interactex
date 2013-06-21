//
//  TFEditorToolsViewController.m
//  Tango
//
//  Created by Juan Haladjian on 11/26/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "TFEditorToolsViewController.h"
#import "TFEditor.h"
#import "THProjectViewController.h"

@implementation TFEditorToolsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) unselectAllButtons{
    
    self.connectButton.tintColor = nil;
    self.duplicateButton.tintColor = nil;
    self.removeButton.tintColor = nil;
}

-(void) updateButtons{
    TFEditor * editor = (TFEditor*) [TFDirector sharedDirector].currentLayer;
    
    [self unselectAllButtons];
    
    if(editor.state == kEditorStateConnect){
        self.connectButton.tintColor = [UIColor blueColor];
    } else if(editor.state == kEditorStateDuplicate){
        self.duplicateButton.tintColor = [UIColor blueColor];
    } else if(editor.state == kEditorStateDelete){
        self.removeButton.tintColor = [UIColor blueColor];
    }
}

-(void) checkSwitchToState:(TFEditorState) state{
    THProjectViewController * projectController = [THDirector sharedDirector].projectController;
    if(projectController.state == kAppStateEditor){
        TFEditor * editor = (TFEditor*) projectController.currentLayer;
        if(editor.state == state){
            editor.state = kEditorStateNormal;
        } else {
            editor.state = state;
        }
        [self updateButtons];
    }
}

- (IBAction)connectTapped:(id)sender {
    [self checkSwitchToState:kEditorStateConnect];
}

- (IBAction)duplicateTapped:(id)sender {
    
    [self checkSwitchToState:kEditorStateDuplicate];
}

- (IBAction)removeTapped:(id)sender {
    [self checkSwitchToState:kEditorStateDelete];
}

-(void) setHidden:(BOOL)hidden{
    if(!hidden){
        [self unselectAllButtons];
    }
    self.view.hidden = hidden;
}

-(BOOL) hidden{
    return self.view.hidden;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
