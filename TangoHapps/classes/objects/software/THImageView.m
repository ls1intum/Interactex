//
//  THImageView.m
//  TangoHapps3
//
//  Created by Juan Haladjian on 12/17/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

#import "THImageView.h"

@implementation THImageView
@dynamic image;
//@dynamic scaleMode;

-(void) loadImageView{
    
    UIImageView * view = [[UIImageView alloc] init];
    view.frame = CGRectMake(0, 0, self.width, self.height);
    view.layer.borderWidth = 1.0f;
    view.contentMode = UIViewContentModeScaleAspectFit;
    self.view = view;
}

-(id) init{
    self = [super init];
    if(self){
        
        self.width = 200;
        self.height = 200;
        
        [self loadImageView];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    [self loadImageView];
    
    self.image = [decoder decodeObjectForKey:@"image"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.image forKey:@"image"];
}


-(id)copyWithZone:(NSZone *)zone {
    THImageView * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Methods
/*
-(void) setScaleMode:(THImageViewScaleMode)scaleMode{
    ((UIImageView*) self.view).contentMode = [THHelper ScaleModeForCustomScaleMode:scaleMode];
}

-(THImageViewScaleMode) scaleMode{
    return [THHelper customScaleModeForScaleMode:((UIImageView*)self.view).contentMode];
}
*/

-(void) setImage:(UIImage *)image{
    ((UIImageView*) self.view).image = image;
}

-(UIImage*) image{
    return ((UIImageView*) self.view).image;
}

-(NSString*) description{
    return @"imageview";
}

-(void) prepareToDie{
    
    [super prepareToDie];
}

@end
