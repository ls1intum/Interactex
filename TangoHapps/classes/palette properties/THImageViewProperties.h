//
//  THImageViewProperties.h
//  TangoHapps3
//
//  Created by Juan Haladjian on 12/17/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

@interface THImageViewProperties : TFEditableObjectProperties <TFImagePickerDelegate>
{
}

@property (weak, nonatomic) IBOutlet UIButton *changeButton;

@property (nonatomic, strong) TFImagePickerController * imagePicker;
@property (nonatomic, strong) UIPopoverController * imagePickerPopover;
@property (weak, nonatomic) IBOutlet UIImageView * imageView;

- (IBAction)changeTapped:(id)sender;

@end
