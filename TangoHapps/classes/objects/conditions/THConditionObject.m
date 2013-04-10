//
//  THConditionObject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/16/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THConditionObject.h"

@implementation THConditionObject
@dynamic isTrue;

-(void) loadEvents{
    
    TFEvent * event1 = [TFEvent eventNamed:kEventConditionIsTrue];
    TFEvent * event2 = [TFEvent eventNamed:kEventConditionIsFalse];
    
    self.events = [NSMutableArray arrayWithObjects:event1,event2,nil];
    
    /*
    THMethod * method = [THMethod methodWithName:@"setCondition"];
    method.numParams = 1;
    method.firstParamType = kDataTypeBoolean;
    self.methods = [NSArray arrayWithObject:method];*/
    
}

-(id) init{
    self = [super init];
    if(self){        
        [self loadEvents];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
            
    [self loadEvents];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
}

#pragma mark - Protocols

-(void) evaluateAndTrigger{
    if([self testCondition]){
        [self triggerEventNamed:kEventConditionIsTrue];
    } else {
        [self triggerEventNamed:kEventConditionIsFalse];
    }
}

-(BOOL) isTrue{
    return [self testCondition];
}

-(BOOL) testCondition{
    NSLog(@"warning, testCondition called on THConditionObject");
    return NO;
}

-(NSString*) description{
    return @"conditionAbs";
}

-(void) prepareToDie{
    [super prepareToDie];
}
@end
