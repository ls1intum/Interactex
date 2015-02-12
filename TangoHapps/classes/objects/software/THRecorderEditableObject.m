//
//  THRecorderEditableObject.m
//  TangoHapps
//
//  Created by Guven Candogan on 27/01/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THRecorderEditableObject.h"
#import "THRecorderProperties.h"
#import "THRecorder.h"

@implementation THRecorderEditableObject

#pragma mark - Initializing

-(id) init{

    self = [super init];
    if(self){
        self.simulableObject = [[THRecorder alloc] init];
        [self load];
    }
    return self;
}

-(void) load{
    self.canBeRootView = NO;
    self.minSize = CGSizeMake(250, 100);
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    [self load];

    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THRecorderProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Method
/*
-(void) updateBoudingBox{
}
*/
/*
-(void) start{
    THRecorder * recorder = (THRecorder * ) self.simulableObject;
    [recorder start];
}

-(void) stop{
    THRecorder * recorder = (THRecorder * ) self.simulableObject;
    [recorder stop];
}

-(void) send{
    THRecorder * recorder = (THRecorder * ) self.simulableObject;
    [recorder send];
}
*/
-(void) appendData:(NSInteger)data{
    THRecorder * recorder = (THRecorder * ) self.simulableObject;
    [recorder appendData:data];
}

-(NSString*) description{
    return @"Recorder";
}

@end
