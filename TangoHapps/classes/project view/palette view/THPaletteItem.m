/*
THPaletteItem.m
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

#import "THPaletteItem.h"
#import "THPaletteItemProperties.h"

@implementation THPaletteItem

static inline double radians (double degrees) {return degrees * M_PI/180;}

@dynamic center;
@synthesize image = _image;
//@dynamic image;

+(id) paletteItemWithName:(NSString*) name{
    return [[THPaletteItem alloc] initWithName:name];
}

+(id) paletteItemWithName:(NSString*) name imageName:(NSString*) imageName{
    return [[THPaletteItem alloc] initWithName:name imageName:imageName];
}

-(void) addViews{
    
    //self.layer.borderWidth = 1.0f;
    
    CGRect frame = CGRectMake(0, 0, kPaletteItemWidth, kPaletteItemHeight);
    
    //container
    _container = [[UIView alloc] initWithFrame:frame];
    //nazmus added 21 sep 14
    [_container.layer setCornerRadius:4.0f];
    [_container.layer setBorderWidth:1.0f];
    [_container.layer setBackgroundColor:[UIColor clearColor].CGColor];
    [_container.layer setBorderColor:[UIColor clearColor].CGColor];
    ////
    
    [self addSubview:_container];
    
    //image view
    float diffx = kPaletteItemWidth - kPaletteItemImageSize.width;
    //float diffy = kPaletteItemHeight - kPaletteItemImageSize.height; //nazmus commented
    //CGRect imageFrame = CGRectMake(diffx/2.0f, diffy/2.0f, kPaletteItemImageSize.width, kPaletteItemImageSize.height);// nazmus commented
    CGRect imageFrame = CGRectMake(diffx/2.0f, kPaletteItemPaddingTop, kPaletteItemImageSize.width, kPaletteItemImageSize.height);// nazmus added
    
    _imageView = [[UIImageView alloc] initWithImage:self.image];
    _imageView.clipsToBounds = YES;
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    _imageView.frame = imageFrame;
    [_container addSubview:_imageView];
    
    //label
    //CGRect labelFrame = CGRectMake(2, 49, kPaletteItemLabelSize.width, kPaletteItemLabelSize.height);
    //CGRect labelFrame = CGRectMake(2, 40, kPaletteItemLabelSize.width, kPaletteItemLabelSize.height); // Nazmus commented 24 Aug 14
    CGRect labelFrame = CGRectMake(0, kPaletteItemLabelVerticalPosition, kPaletteItemLabelSize.width, kPaletteItemLabelSize.height); // Nazmus Added 24 Aug 14
    _label = [[UILabel alloc] initWithFrame:labelFrame];
    _label.numberOfLines = 2;
    _label.lineBreakMode = NSLineBreakByCharWrapping;
    _label.text = self.name;
    _label.backgroundColor = [UIColor clearColor];
    //_label.textColor = [UIColor whiteColor]; // Nazmus commented 24 Aug 14
    _label.textColor = [UIColor darkGrayColor]; // Nazmus added 24 Aug 14
    //_label.font = [UIFont boldSystemFontOfSize:8]; //nazmus commented
    _label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:9.0]; // nazmus added
    _label.textAlignment = NSTextAlignmentCenter;
    
    [_container addSubview:_label];
    
    //delete button
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * deleteImage = [UIImage imageNamed:@"removeButton.png"];
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
    return [NSArray arrayWithObject:[THPaletteItemProperties properties]];
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
            //nazmus added 21 sep 14
            [_container.layer setBackgroundColor:[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f].CGColor];
            [_container.layer setBorderColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f].CGColor];
            ////
            
        } else {
            //nazmus added 21 sep 14
            [_container.layer setBackgroundColor:[UIColor clearColor].CGColor];
            [_container.layer setBorderColor:[UIColor clearColor].CGColor];
            ////
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
