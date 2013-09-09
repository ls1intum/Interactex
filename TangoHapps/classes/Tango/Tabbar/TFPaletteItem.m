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


#import "TFPaletteItem.h"
#import "TFEditor.h"
#import "TFPaletteItemProperties.h"

@implementation TFPaletteItem

static inline double radians (double degrees) {return degrees * M_PI/180;}

@dynamic center;
@synthesize image = _image;
//@dynamic image;

+(id) paletteItemWithName:(NSString*) name{
    return [[TFPaletteItem alloc] initWithName:name];
}

+(id) paletteItemWithName:(NSString*) name imageName:(NSString*) imageName{
    return [[TFPaletteItem alloc] initWithName:name imageName:imageName];
}

-(void) addViews{
    
    CGRect frame = CGRectMake(0, 0, kPaletteItemSize, kPaletteItemSize);
    
    //container
    _container = [[UIView alloc] initWithFrame:frame];
    _container.layer.borderWidth = 1.0f;
    _container.layer.cornerRadius = 5.0f;
    [self addSubview:_container];
    
    //[self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    
    //image view
    float diffx = kPaletteItemSize - kPaletteItemImageSize.width;
    float diffy = kPaletteItemSize - kPaletteItemImageSize.height;
    CGRect imageFrame = CGRectMake(diffx/2.0f, diffy/2.0f - 5, kPaletteItemImageSize.width, kPaletteItemImageSize.height);
    
    _imageView = [[UIImageView alloc] initWithImage:self.image];
    _imageView.clipsToBounds = YES;
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    _imageView.frame = imageFrame;
    [_container addSubview:_imageView];
    
    //label
    //CGRect labelFrame = CGRectMake(2, 49, kPaletteItemLabelSize.width, kPaletteItemLabelSize.height);
    CGRect labelFrame = CGRectMake(2, 40, kPaletteItemLabelSize.width, kPaletteItemLabelSize.height);
    _label = [[UILabel alloc] initWithFrame:labelFrame];
    _label.numberOfLines = 2;
    _label.lineBreakMode = NSLineBreakByCharWrapping;
    _label.text = self.name;
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont boldSystemFontOfSize:8];
    _label.textAlignment = NSTextAlignmentCenter;
    
    [_container addSubview:_label];
    
    //delete button
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * deleteImage = [UIImage imageNamed:@"removeButton"];
    [_deleteButton setBackgroundImage:deleteImage forState:UIControlStateNormal];
    _deleteButton.frame = CGRectMake(-7, -7, 25, 25);
    _deleteButton.hidden = YES;
    [_deleteButton addTarget:self action:@selector(removeButtonTapped) forControlEvents:UIControlEventTouchDown];
    
    /*
    //text field
    labelFrame = CGRectMake(2, 49, 30, kPaletteItemLabelSize.height);
    _textField = [[UITextField alloc] initWithFrame:labelFrame];
    _textField.layer.borderColor = [UIColor whiteColor].CGColor;
    _textField.delegate = self;
    [_container addSubview:_textField];
    */
    
    [self addSubview:_deleteButton];
}

-(void) addGestureRecognizers{
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    tapRecognizer.cancelsTouchesInView = NO;
    //[self addGestureRecognizer:tapRecognizer];
}

-(void) loadPaletteItem{
    
    [self addViews];
    [self addGestureRecognizers];
    
    self.userInteractionEnabled = YES;
}

-(id)initWithName:(NSString*) name imageName:(NSString*) imageName{
    self = [super init];
    if(self){
        self.name = name;
        self.imageName = imageName;
        self.image = [UIImage imageNamed:self.imageName];
        [self loadPaletteItem];
    }
    return self;
}

-(id)initWithName:(NSString*) name {
    self = [super init];
    if(self){
        self.name = name;
        self.imageName = [NSString stringWithFormat:@"palette_%@.png",name];
        self.image = [UIImage imageNamed:self.imageName];
        [self loadPaletteItem];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    if(self){
        self.name = [decoder decodeObjectForKey:@"name"];
        //self.imageName = [decoder decodeObjectForKey:@"imageName"];
        self.image = [decoder decodeObjectForKey:@"image"];
        self.isEditable = YES;
        [self loadPaletteItem];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.name forKey:@"name"];
    //[aCoder encodeObject:self.imageName forKey:@"imageName"];
    [aCoder encodeObject:self.image forKey:@"image"];
}

#pragma mark - Property Controllers

-(NSArray*) propertyControllers{
    return [NSArray arrayWithObject:[TFPaletteItemProperties properties]];
}

-(void) dealloc
{
    [_imageView removeFromSuperview];
}

#pragma mark Getters/Setters

-(CGPoint)center:(CGPoint)position
{
    return _imageView.center;
}

- (bool)testPoint: (CGPoint) point
{
    return CGRectContainsPoint(_imageView.frame, point);
}

-(void) setImage:(UIImage *)image{
    _image = image;
    _imageView.image = image;
}

-(UIImage*) image{
    return _image;
    //return _imageView.image;
}

#pragma mark Getters/Setters

-(BOOL) testHit:(CGPoint) location{
    
    return CGRectContainsPoint(self.frame, location);
}

-(void) setSelected:(BOOL)selected{
    if(selected != _selected){
        _selected = selected;
        if(selected){
            _container.layer.borderColor = [UIColor blueColor].CGColor;
        } else {
            _container.layer.borderColor = [UIColor blackColor].CGColor;
        }
    }
}

-(void) setName:(NSString *)name{
    _name = name;
    _label.text = name;
}

-(void) startShaking{
    float const kItemShakingAngle = 1.0f;
    CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, radians(-kItemShakingAngle));
    CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, radians(kItemShakingAngle));
    
    self.transform = leftWobble;  // starting point
    
    [UIView beginAnimations:@"wobble" context:nil];
    [UIView setAnimationRepeatAutoreverses:YES]; // important
    [UIView setAnimationRepeatCount:MAXFLOAT];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(shakingEnded:finished:context:)];
    
    self.transform = rightWobble; // end here & auto-reverse
    
    [UIView commitAnimations];
}

- (void) shakingEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([finished boolValue]) {
        self.transform = CGAffineTransformIdentity;
    }
}

-(void) stopShaking {
    [self.layer removeAllAnimations];
    self.transform = CGAffineTransformIdentity;
}

-(void) scaleAnimation {
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         _imageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.25
                                               delay:0
                                             options:UIViewAnimationOptionBeginFromCurrentState
                                          animations:(void (^)(void)) ^{
                                              _imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                          }
                                          completion:^(BOOL finished){
                                              
                                              _imageView.transform=CGAffineTransformIdentity;
                                              [self startShaking];
                                          }];
                         
                     }];
}

-(void) setEditing:(BOOL)editing{
    if(self.isEditable){
        if(_editing != editing){
            _editing = editing;
            if(editing){
                _deleteButton.hidden = NO;
                [self scaleAnimation];
                _textField.layer.borderWidth = 1.0f;
            } else {
                _deleteButton.hidden = YES;
                [self stopShaking];
                _textField.layer.borderWidth = 0.0f;
            }
            _textField.hidden = !editing;
        }
    }
}

-(void) removeButtonTapped{
    [self.delegate didRemovePaletteItem:self];
}

-(void) handleTap{
    [self.delegate didTapPaletteItem:self];
}

#pragma mark Droppable

- (BOOL)canBeDroppedAt:(CGPoint)location
{
    return YES;
}

- (void) dropAt:(CGPoint)location
{
    NSAssert(NO, @"Do not call drop at from abstract class");
}

@end
