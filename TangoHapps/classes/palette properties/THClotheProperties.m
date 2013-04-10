//
//  THClotheProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/13/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THClotheProperties.h"
#import "THClothe.h"

@implementation THClotheProperties

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(NSString *)title
{
    return @"Button";
}

-(void) updateLabel{
    THClothe * clothe = (THClothe*) self.editableObject;
    self.scaleLabel.text = [NSString stringWithFormat:@"%.2f",clothe.scale];
}

-(void) updateSlider{
    
    THClothe * clothe = (THClothe*) self.editableObject;
    self.scaleSlider.value = clothe.scale;
}

-(void) updateImageView{
    THClothe * clothe = (THClothe*) self.editableObject;
    
    UIImage * image = clothe.image;
    
    if(image.size.width > self.imageView.frame.size.width || image.size.height > self.imageView.frame.size.width){
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    
    self.imageView.image = image;
}

-(void) reloadState{
    [self updateLabel];
    [self updateSlider];
    
    [self updateImageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScaleLabel:nil];
    [self setScaleSlider:nil];
    [super viewDidUnload];
}

- (IBAction)scaleChanged:(id)sender {
    
    THClothe * clothe = (THClothe*) self.editableObject;
    clothe.scale = self.scaleSlider.value;
    
    [self updateLabel];
}

- (void)imagePicker:(TFImagePickerController*) picker didSelectImage:(UIImage*)image imageName:(NSString *)imageName{
    if(image){
        
        THClothe * clothe = (THClothe*) self.editableObject;
        clothe.image = image;
        
        [self updateImageView];
        [self.imagePickerPopover dismissPopoverAnimated:YES];
    }
}

- (IBAction)changeTapped:(id)sender {
    if (self.imagePicker == nil) {
        //NSBundle * tangoBundle = [TFHelper frameworkBundle];
        self.imagePicker = [[TFImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePickerPopover = [[UIPopoverController alloc]
                                   initWithContentViewController:self.imagePicker];
    }
    
    [self.imagePickerPopover presentPopoverFromRect:self.changeButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

@end
