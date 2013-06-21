//
//  THSoundProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 4/23/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "TFEditableObjectProperties.h"
#import <MediaPlayer/MediaPlayer.h>
#import "THSoundPicker.h"

@interface THSoundProperties : TFEditableObjectProperties <THSoundPickerDelegate>
{

}

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;

@property (nonatomic, strong) UIPopoverController * soundPickerPopover;
@property (nonatomic, strong) THSoundPicker * soundPicker;

- (IBAction)changeTapped:(id)sender;
- (IBAction)playTapped:(id)sender;

@end
