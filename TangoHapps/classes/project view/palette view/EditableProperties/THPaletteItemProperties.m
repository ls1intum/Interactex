/*
 * TangoFramework
 *
 * Copyright (c) 2012 Juan Haladjian
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
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
