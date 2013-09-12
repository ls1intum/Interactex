//
//  THImageViewProperties.h
//  TangoHapps3
//
//  Created by Juan Haladjian on 12/17/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

#import "THEditableObjectProperties.h"
#import "THImagePickerController.h"

@interface THImageViewProperties : THEditableObjectProperties <TFImagePickerDelegate>
{
}

@property (weak, nonatomic) IBOutlet UIButton *changeButton;

@property (nonatomic, strong) THImagePickerController * imagePicker;
@property (nonatomic, strong) UIPopoverController * imagePickerPopover;
@property (weak, nonatomic) IBOutlet UIImageView * imageView;

- (IBAction)changeTapped:(id)sender;

@end
