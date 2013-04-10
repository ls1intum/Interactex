//
//  THImageViewEditable.m
//  TangoHapps3
//
//  Created by Juan Haladjian on 12/17/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

#import "THImageViewEditable.h"
#import "THImageView.h"
#import "THImageViewProperties.h"

@implementation THImageViewEditable

@dynamic image;

-(void) loadImageView{
    self.acceptsConnections = YES;
    self.canBeRootView = NO;
}

-(id) init{
    self = [super init];
    if(self){
        
        self.simulableObject = [[THImageView alloc] init];
        [self loadImageView];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    [self loadImageView];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone
{
    THImageViewEditable * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THImageViewProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods
/*
-(void) setScaleMode:(THImageViewScaleMode)scaleMode{
    THImageView * imageView = (THImageView*) self.simulableObject;
    imageView.scaleMode = scaleMode;
}

-(THImageViewScaleMode) scaleMode{
    THImageView * imageView = (THImageView*) self.simulableObject;
    return imageView.scaleMode;
}*/

-(void) setImage:(UIImage *)image{
    THImageView * imageView = (THImageView*) self.simulableObject;
    imageView.image = image;
}

-(UIImage*) image{
    THImageView * imageView = (THImageView*) self.simulableObject;
    return imageView.image;
}

-(void) prepareToDie{
    [super prepareToDie];
}

-(NSString*) description{
    return @"ImageView";
}

@end
