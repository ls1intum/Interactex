//
//  THMusicPlayerProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/23/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THMusicPlayerProperties.h"
#import "THMusicPlayerEditableObject.h"

@implementation THMusicPlayerProperties

-(NSString*) title{
    return @"Music Player";
}

-(void) updatePlaySwitch{
    
    THMusicPlayerEditableObject * musicPlayer = (THMusicPlayerEditableObject*) self.editableObject;
    self.playSwitch.on = musicPlayer.showPlayButton;
}

-(void) updateNextSwitch{
    
    THMusicPlayerEditableObject * musicPlayer = (THMusicPlayerEditableObject*) self.editableObject;
    self.nextSwitch.on = musicPlayer.showNextButton;
}

-(void) updatePreviousSwitch{
    
    THMusicPlayerEditableObject * musicPlayer = (THMusicPlayerEditableObject*) self.editableObject;
    self.previousSwitch.on = musicPlayer.showPreviousButton;
}

-(void) updateVisibleSwitch{
    
    THMusicPlayerEditableObject * musicPlayer = (THMusicPlayerEditableObject*) self.editableObject;
    self.visibleSwitch.on = musicPlayer.visibleDuringSimulation;
}

-(void) reloadState{
    [self updatePlaySwitch];
    [self updateNextSwitch];
    [self updatePreviousSwitch];
    [self updateVisibleSwitch];
}

- (IBAction)playChanged:(id)sender {
    THMusicPlayerEditableObject * musicPlayer = (THMusicPlayerEditableObject*) self.editableObject;
    musicPlayer.showPlayButton = self.playSwitch.on;
}

- (IBAction)nextChanged:(id)sender {
    THMusicPlayerEditableObject * musicPlayer = (THMusicPlayerEditableObject*) self.editableObject;
    musicPlayer.showNextButton = self.nextSwitch.on;
}

- (IBAction)previousChanged:(id)sender {
    THMusicPlayerEditableObject * musicPlayer = (THMusicPlayerEditableObject*) self.editableObject;
    musicPlayer.showPreviousButton = self.previousSwitch.on;
}

- (IBAction)visibleChanged:(id)sender {
    
    THMusicPlayerEditableObject * musicPlayer = (THMusicPlayerEditableObject*) self.editableObject;
    musicPlayer.visibleDuringSimulation = self.visibleSwitch.on;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setPlaySwitch:nil];
    [self setNextSwitch:nil];
    [self setPreviousSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


@end
