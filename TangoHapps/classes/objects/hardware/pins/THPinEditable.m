//
//  THPin.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/12/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THPinEditable.h"
#import "THPin.h"

@implementation THPinEditable

-(void) loadPin{
    self.highlightColor = kDefaultPinHighlightColor;
    self.contentSize = CGSizeMake(kLilypadPinRadius*2, kLilypadPinRadius*2);
}

-(id) init{
    self = [super init];
    if(self){
        self.size = kDefaultPinSize;
        
        [self loadPin];
    }
    return self;
}

-(id) initWithPin:(THPin*) pin{
    self = [super init];
    if(self){
        
        self.simulableObject = pin;
        [self loadPin];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    [self loadPin];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
}

#pragma mark - Methods

-(CGRect) boundingBox{
    CGPoint spriteLoc = [self convertToWorldSpace:CGPointZero];
    
    CGSize size = CGSizeMake(self.contentSize.width * self.scale * self.parent.parent.scale, self.contentSize.height * self.scale * self.parent.parent.scale);
    return CGRectMake(spriteLoc.x - size.width / 2, spriteLoc.y - size.height / 2, size.width, size.height);
}

@end
