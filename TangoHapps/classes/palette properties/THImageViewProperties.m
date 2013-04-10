//
//  THImageViewProperties.m
//  TangoHapps3
//
//  Created by Juan Haladjian on 12/17/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

#import "THImageViewProperties.h"
#import "THImageViewEditable.h"

@implementation THImageViewProperties

-(NSString *)title {
    return @"Image View";
}

-(void) updateImageView{
    THImageViewEditable * imageView = (THImageViewEditable*) self.editableObject;
    if(imageView.image.size.width  > self.imageView.frame.size.width || imageView.image.size.height > self.imageView.frame.size.width){
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    
    self.imageView.image = imageView.image;
}

-(void) reloadState{
    [self updateImageView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.imageView.layer.cornerRadius = 3.0f;
    self.imageView.layer.borderWidth = 1.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePicker:(TFImagePickerController*) picker didSelectImage:(UIImage*)image imageName:(NSString *)imageName{
    if(image){
        
        THImageViewEditable * imageView = (THImageViewEditable*) self.editableObject;
        imageView.image = image;
        [self updateImageView];
        [self.imagePickerPopover dismissPopoverAnimated:YES];
    }
}

- (IBAction)changeTapped:(id)sender {
    if (self.imagePicker == nil) {

        self.imagePicker = [[TFImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePickerPopover = [[UIPopoverController alloc]
                                    initWithContentViewController:self.imagePicker];
    }

    [self.imagePickerPopover presentPopoverFromRect:self.changeButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

@end
