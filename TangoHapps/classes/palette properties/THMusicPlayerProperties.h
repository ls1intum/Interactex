//
//  THMusicPlayerProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/23/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//


@interface THMusicPlayerProperties : TFEditableObjectProperties
@property (weak, nonatomic) IBOutlet UISwitch *playSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *nextSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *previousSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *visibleSwitch;

- (IBAction)playChanged:(id)sender;
- (IBAction)nextChanged:(id)sender;
- (IBAction)previousChanged:(id)sender;
- (IBAction)visibleChanged:(id)sender;

@end
