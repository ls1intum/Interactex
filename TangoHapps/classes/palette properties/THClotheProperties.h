//
//  THClotheProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 10/13/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "TFEditableObjectProperties.h"
#import "TFImagePickerController.h"

@interface THClotheProperties : TFEditableObjectProperties <TFImagePickerDelegate>


@property (weak, nonatomic) IBOutlet UILabel * scaleLabel;
@property (weak, nonatomic) IBOutlet UISlider *scaleSlider;
- (IBAction)scaleChanged:(id)sender;

@property (nonatomic, strong) TFImagePickerController * imagePicker;
@property (nonatomic, strong) UIPopoverController * imagePickerPopover;
@property (weak, nonatomic) IBOutlet UIImageView * imageView;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;

- (IBAction)changeTapped:(id)sender;

@end
