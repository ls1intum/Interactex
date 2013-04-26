//
//  THSound.m
//  TangoHapps
//
//  Created by Juan Haladjian on 4/23/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THSound.h"

@implementation THSound

-(id) init {
    self = [super init];
    if(self){        
        [self loadSound];
    }
    return self;
}

-(void) loadSound {
    
    TFMethod * method1 = [TFMethod methodWithName:@"play"];
    self.methods = [NSArray arrayWithObjects:method1, nil];
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        self.fileName = [decoder decodeObjectForKey:@"fileName"];
        [self loadSound];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:_fileName forKey:@"fileName"];
    
    [self loadSound];
}

-(id)copyWithZone:(NSZone *)zone {
    THSound * copy = [super copyWithZone:zone];
    
    copy.fileName = self.fileName;
    
    return copy;
}

#pragma mark - Methods

-(void) play{
    if(_fileName){
        [[SimpleAudioEngine sharedEngine] playEffect:_fileName];
    }
}


@end
