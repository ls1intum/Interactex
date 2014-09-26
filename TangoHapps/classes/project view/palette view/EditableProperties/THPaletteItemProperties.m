/*
THPaletteItemProperties.m
Interactex Designer

Created by Juan Haladjian on 05/10/2013.

Interactex Designer is a configuration tool to easily setup, simulate and connect e-Textile hardware with smartphone functionality. Interactex Client is an app to store and replay projects made with Interactex Designer.

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
The first version of the software was designed and implemented as part of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was founded by Telekom Innovation Laboratories Berlin. It has been extended with funding from EIT ICT, as part of the activity "Connected Textiles".

Interactex is built using the Tango framework developed by TU Munich.

In the Interactex software, we use the GHUnit (a test framework for iOS developed by Gabriel Handford) and cocos2D libraries (a framework for building 2D games and graphical applications developed by Zynga Inc.). 
www.cocos2d-iphone.org
github.com/gabriel/gh-unit

Interactex also implements the Firmata protocol. Its software serial library is based on the original Arduino Firmata library.
www.firmata.org

All hardware part graphics in Interactex Designer are reproduced with kind permission from Fritzing. Fritzing is an open-source hardware initiative to support designers, artists, researchers and hobbyists to work creatively with interactive electronics.
www.frizting.org

Martijn ten Bhömer from TU Eindhoven contributed PureData support. Contact: m.t.bhomer@tue.nl.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

#import "THPaletteItemProperties.h"
#import "THCustomPaletteItem.h"

@implementation THPaletteItemProperties

+(id) properties{
    return [[[self class] alloc] init];
}

-(id) init{
    self = [ super init];
    if(self){
        CGRect frame = CGRectMake(0, 0, 230, 250);
        self.view = [[UIView alloc] initWithFrame:frame];
        
        CGRect labelRect = CGRectMake(10, 16, 60, 30);
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:labelRect];
        nameLabel.text = @"Name";
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:nameLabel];
        
        CGRect textRect = CGRectMake(87, 16, 120, 30);
        self.nameTextField = [[UITextField alloc] initWithFrame:textRect];
        self.nameTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.nameTextField.enabled = YES;
        self.nameTextField.font = [UIFont systemFontOfSize:13];
        self.nameTextField.backgroundColor = [UIColor whiteColor];
        [self.nameTextField addTarget:self action:@selector(textEntered:) forControlEvents:UIControlEventEditingDidEnd];
        [self.view addSubview:self.nameTextField];
         
        CGRect imageRect = CGRectMake(20, 70, 70, 60);
        self.imageView = [[UIImageView alloc] initWithFrame:imageRect];
        self.imageView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:self.imageView];
        
        CGRect buttonRect = CGRectMake(100, 80, 80, 40);
        self.changeImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.changeImageButton.frame = buttonRect;
        [self.changeImageButton setTitle:@"Change" forState:UIControlStateNormal];
        //self.changeImageButton.titleLabel.font = [UIFont systemFontOfSize:13];
        self.changeImageButton.enabled = YES;
        [self.changeImageButton addTarget:self action:@selector(changeImageTapped:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:self.changeImageButton];
    }
    return self;
}
    
-(NSString *)title {
    return @"Palette Item";
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.nameTextField resignFirstResponder];
    return NO;
}

-(void) updateEnabledState {
    THPaletteItem * paletteItem = (THPaletteItem*) self.editableObject;
    self.changeImageButton.enabled = paletteItem.isEditable;
    self.nameTextField.enabled = paletteItem.isEditable;
}

-(void) updateImage{
    THPaletteItem * paletteItem = (THPaletteItem*) self.editableObject;

    if(paletteItem.image.size.width  > self.imageView.frame.size.width || paletteItem.image.size.height > self.imageView.frame.size.width){
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    
    self.imageView.image = paletteItem.image;
}

-(void) updateName{
    THPaletteItem * paletteItem = (THPaletteItem*) self.editableObject;
    self.nameTextField.text = paletteItem.name;
}

-(void) reloadState{
    [self updateEnabledState];
    [self updateImage];
    [self updateName];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePicker:(THImagePickerController*) picker didSelectImage:(UIImage*)image imageName:(NSString *)imageName{
    if(image){
        
        THPaletteItem * paletteItem = (THPaletteItem*) self.editableObject;
        paletteItem.image = image;
        paletteItem.imageName = imageName;
        
        [self updateImage];
        
        [self.imagePickerPopover dismissPopoverAnimated:YES];
    }
}

- (void)changeImageTapped:(id)sender {
    if (self.imagePicker == nil) {
        //NSBundle * tangoBundle = [TFHelper frameworkBundle];
        self.imagePicker = [[THImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePickerPopover = [[UIPopoverController alloc]
                                   initWithContentViewController:self.imagePicker];
    }
    
    [self.imagePickerPopover presentPopoverFromRect:self.changeImageButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)textEntered:(id)sender {
    
    THCustomPaletteItem * paletteItem = (THCustomPaletteItem*) self.editableObject;
    if(![paletteItem.name isEqualToString:self.nameTextField.text]){
        [paletteItem renameTo:self.nameTextField.text];
        self.nameTextField.text = paletteItem.name;
    }
}

@end
