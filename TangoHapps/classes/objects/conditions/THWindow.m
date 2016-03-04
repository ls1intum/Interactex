//
//  THWindow.m
//  TangoHapps
//
//  Created by Juan Haladjian on 03/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THWindow.h"

@implementation THWindow


-(id) init{
    self = [super init];
    if(self){
        [self loadWindow];
        
    }
    return self;
}

-(void) loadWindow{
    TFMethod * startMethod = [TFMethod methodWithName:@"start"];
    TFMethod * addSampleMethod = [TFMethod methodWithName:@"addSample"];
    addSampleMethod.numParams = 1;
    addSampleMethod.firstParamType = kDataTypeAny;
    TFMethod * stopMethod = [TFMethod methodWithName:@"stop"];
    
    self.methods = [NSMutableArray arrayWithObjects:startMethod,stopMethod,addSampleMethod, nil];
    
    TFEvent * event = [TFEvent eventNamed:kEventWindowFull];
    TFProperty * property = [[TFProperty alloc] initWithName:@"data" andType:kDataTypeAny];
    
    event.param1 = [TFPropertyInvocation invocationWithProperty:property target:self];
    self.events = [NSMutableArray arrayWithObjects:event,nil];
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        
        [self loadWindow];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THWindow * copy = [super copyWithZone:zone];
    return copy;
}

#pragma mark - Methods

-(void) start{
    _started = YES;
    self.data = [NSMutableArray array];
}

-(void) stop{
    _started = NO;
}

-(void) emptyWindow{

    NSRange range = NSMakeRange(self.windowSize - self.overlap, self.overlap);
    NSArray * subArray = [self.data subarrayWithRange:range];
    self.data = [NSMutableArray arrayWithArray:subArray];
}

-(void) addSample:(id) sample{
    if(self.started){
        [self.data addObject:sample];
        if(self.data.count >= self.windowSize){
            [self triggerEventNamed:kEventWindowFull];
            [self emptyWindow];
        }
    }
}

@end
