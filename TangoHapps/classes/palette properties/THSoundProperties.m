//
//  THSoundProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 4/23/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THSoundProperties.h"
#import "THSoundEditable.h"

@implementation THSoundProperties

-(NSString*) title{
    return @"Sound";
}

-(void) updateNameLabel{
    
    THSoundEditable * sound = (THSoundEditable*) self.editableObject;
    if(sound.fileName){
        self.nameLabel.text = [NSString stringWithFormat: @"%@", sound.fileName];
    } else {
        self.nameLabel.text = @"";
    }
}

-(void) reloadState{
    
    [self updateNameLabel];
}

- (IBAction)playTapped:(id)sender {
    
    THSoundEditable * sound = (THSoundEditable*) self.editableObject;
    [sound play];
}

- (void)soundPicker:(THSoundPicker*)picker didPickSound:(NSString*)soundName{
    NSLog(@"selected: %@",soundName);
    if(soundName){
        
        THSoundEditable * sound = (THSoundEditable*) self.editableObject;
        sound.fileName = soundName;
        [self updateNameLabel];
        [self.soundPickerPopover dismissPopoverAnimated:YES];
    }
}

- (IBAction)changeTapped:(id)sender {
    
    if (self.soundPicker == nil) {
        self.soundPicker = [[THSoundPicker alloc] init];
        self.soundPicker.delegate = self;
        self.soundPickerPopover = [[UIPopoverController alloc]
                                   initWithContentViewController:self.soundPicker];
    }
    
    [self.soundPickerPopover presentPopoverFromRect:self.changeButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

@end
