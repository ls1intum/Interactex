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


#import "TFImagePickerController.h"
#import <AssetsLibrary/ALAssetRepresentation.h>

float const kImagePickerPadding = 5;
CGSize const kImagePickerImageSize = {60,60};

@implementation TFImagePickerController

-(void) loadGui{
    CGRect frame = CGRectMake(0, 0, 300, 300);
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor grayColor];
    
    CGRect imagesContainerFrame = CGRectMake(10, 10, 280, 200);
    self.imagesContainer = [[UIScrollView alloc] initWithFrame:imagesContainerFrame];
    self.imagesContainer.backgroundColor = [UIColor lightGrayColor];
    self.imagesContainer.contentSize = imagesContainerFrame.size;
    [self.view addSubview:self.imagesContainer];
    
    CGRect imageViewFrame = CGRectMake(20, 233, 60, 60);
    self.currentImageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    self.currentImageView.layer.borderWidth = 1.0f;
    self.currentImageView.layer.cornerRadius = 3.0f;
    self.currentImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.currentImageView];
    
    CGRect buttonFrame = CGRectMake(214, 233, 60, 60);
    self.okButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.okButton.frame = buttonFrame;
    [self.okButton addTarget:self action:@selector(okButtonTapped:) forControlEvents:UIControlEventTouchDown];
    [self.okButton setTitle:@"OK" forState:UIControlStateNormal];
    [self.view addSubview:self.okButton];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicator.center = self.imagesContainer.center;
    [self.view addSubview:_activityIndicator];
    
    [self viewDidLoad];
}

-(id) init{
    self = [super init];
    if(self){
        [self loadGui];
    }
    return self;
}

-(void)okButtonTapped:(UIButton *)sender
{
    [self.delegate imagePicker:self didSelectImage:self.currentImageView.image imageName:self.imageName];
}

-(void)addPhoto:(ALAssetRepresentation *)asset
{
    UIImage * image = [UIImage imageWithCGImage:[asset fullResolutionImage]];
    [_images addObject:image];
    NSString * name = [asset filename];
    NSLog(@"%@",name);
    [_imageNames addObject:name];
}

-(void)loadImages {
    _images = [[NSMutableArray alloc] init];
    _imageNames = [[NSMutableArray alloc] init];
    ALAssetsLibrary * library = [[ALAssetsLibrary alloc] init];
    
    [_activityIndicator startAnimating];
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop)
         {
             // Within the group enumeration block, filter if necessary
             [group setAssetsFilter:[ALAssetsFilter allPhotos]];
             [group enumerateAssetsUsingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
                 if (alAsset) {
                     ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                     [self addPhoto:representation];
                 }
                 else {
                     [_activityIndicator stopAnimating];
                     [self layoutImages];
                 }
             }];
         }
                             failureBlock: ^(NSError *error) {
                                 NSLog(@"No groups");
                             }];
    }
}

-(void) buttonTapped:(UIButton*) button{
    self.currentImageView.image = [_images objectAtIndex:button.tag];
    self.imageName = [_imageNames objectAtIndex:button.tag];
}

-(void) layoutImages {/*
    UIImage * button = [UIImage imageNamed:@"button.png"];
    UIImage * led = [UIImage imageNamed:@"led.png"];
    NSArray * images = [NSArray arrayWithObjects:button,led, nil];*/
    
    NSInteger idx = 0;
    _currentPos = CGPointMake(kImagePickerPadding,kImagePickerPadding);
    for (UIImage * image in _images) {
        
        CGRect frame = CGRectMake(_currentPos.x, _currentPos.y, kImagePickerImageSize.width, kImagePickerImageSize.height);
        UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
        imageView.image = image;
        imageView.frame = frame;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        //button.layer.borderWidth = 1.0f;
        //button.layer.cornerRadius = 3.0f;
        button.tag = idx;
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchDown];
        
        [self.imagesContainer addSubview:button];
        [self.imagesContainer addSubview:imageView];
        
        _currentPos.x += frame.size.width + kImagePickerPadding;
        if(_currentPos.x + kImagePickerImageSize.width >= self.imagesContainer.frame.size.width){
            _currentPos.x = kImagePickerPadding;
            _currentPos.y += frame.size.height + kImagePickerPadding;
        }
        idx++;
        
        self.imagesContainer.contentSize = CGSizeMake(self.imagesContainer.contentSize.width, _currentPos.y - 10);
    }
}

-(void)tap:(UIPanGestureRecognizer*)sender
{
    //ImagePaletteItem * item = [imagesScrollView objectAtIndex:sender.view.tag];
    //self.currentImageName = item.fileName;
}

#pragma mark - View lifecycle

//-(void) present
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadImages];
    self.contentSizeForViewInPopover = self.view.frame.size;
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIDeviceOrientationLandscapeRight);
}

@end
