//
//  THWireProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 8/14/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "TFEditableObjectProperties.h"
#import "THColorPicker.h"

@interface THWireProperties : TFEditableObjectProperties <THColorPickerDelegate>
{
    THColorPicker *colorPicker;
    UIPopoverController *colorPickerPopover;
}

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UIButton *changeColorButton;

- (IBAction)changeColorTapped:(id)sender;
- (IBAction)addNodeTapped:(id)sender;

@end
